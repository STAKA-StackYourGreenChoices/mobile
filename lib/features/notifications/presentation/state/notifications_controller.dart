import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/core/notifications/notifications_repository.dart';

part 'notifications_controller.g.dart';

/// The inbox's states.
sealed class NotificationsState {
  const new();
}

final class NotificationsLoading extends NotificationsState {
  const new();
}

final class NotificationsEmpty extends NotificationsState {
  const new();
}

final class NotificationsFailed extends NotificationsState {
  const new(this.failure);

  final Failure failure;
}

final class NotificationsLoaded extends NotificationsState {
  const new({
    required this.items,
    required this.total,
    required this.unreadCount,
    required this.loadedPages,
    this.isLoadingMore = false,
    this.loadMoreFailure,
    this.isMarkingAll = false,
  });

  final List<AppNotification> items;
  final int total;
  final int unreadCount;
  final int loadedPages;
  final bool isLoadingMore;

  /// The next page failed; the list stays and offers to try again.
  final Failure? loadMoreFailure;
  final bool isMarkingAll;

  bool get hasMore => items.length < total;

  NotificationsLoaded copy({
    List<AppNotification>? items,
    int? unreadCount,
    bool isLoadingMore = false,
    Failure? loadMoreFailure,
    bool isMarkingAll = false,
  }) => NotificationsLoaded(
    items: items ?? this.items,
    total: total,
    unreadCount: unreadCount ?? this.unreadCount,
    loadedPages: loadedPages,
    isLoadingMore: isLoadingMore,
    loadMoreFailure: loadMoreFailure,
    isMarkingAll: isMarkingAll,
  );
}

/// The notification inbox (V2-9), 20 at a time as the person scrolls.
/// Opening one marks it read; "Mark all as read" reads them all. Both
/// update the list at once and tell the bell to reload.
@riverpod
class NotificationsController extends _$NotificationsController {
  /// Bumped on every reload, so answers to an older one are dropped.
  int _generation = 0;

  @override
  NotificationsState build() {
    unawaited(Future.microtask(_reload));
    return const NotificationsLoading();
  }

  NotificationsRepository get _repository =>
      ref.read(notificationsRepositoryProvider);

  Future<void> retry() async {
    state = const NotificationsLoading();
    await _reload();
  }

  /// Pull to refresh: back to the first page, the list stays meanwhile.
  Future<void> refresh() => _reload();

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }
    final generation = _generation;
    state = current.copy(isLoadingMore: true);
    final result = await _repository.fetchPage(current.loadedPages + 1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(:final value) => NotificationsLoaded(
        items: [...current.items, ...value.items],
        total: value.total,
        unreadCount: value.unreadCount,
        loadedPages: current.loadedPages + 1,
      ),
      Err(:final failure) => current.copy(loadMoreFailure: failure),
    };
  }

  /// Marks [notification] read (if it isn't). The list changes at once; a
  /// failed request is not worth troubling the person with — it simply
  /// shows as unread again next time.
  Future<void> open(AppNotification notification) async {
    if (notification.isRead) return;
    final current = state;
    if (current is NotificationsLoaded) {
      final now = DateTime.now();
      state = current.copy(
        items: [
          for (final item in current.items)
            if (item.id == notification.id) item.markedRead(now) else item,
        ],
        unreadCount: max(current.unreadCount - 1, 0),
        isLoadingMore: current.isLoadingMore,
        loadMoreFailure: current.loadMoreFailure,
      );
    }
    final revision = ref.read(notificationsRevisionProvider.notifier);
    final result = await _repository.markRead(notification.id);
    if (result is Ok) revision.bump();
  }

  /// Answers the failure, if any, for a snackbar.
  Future<Failure?> markAllRead() async {
    final current = state;
    if (current is! NotificationsLoaded ||
        current.unreadCount == 0 ||
        current.isMarkingAll) {
      return null;
    }
    state = current.copy(
      isMarkingAll: true,
      isLoadingMore: current.isLoadingMore,
      loadMoreFailure: current.loadMoreFailure,
    );
    final revision = ref.read(notificationsRevisionProvider.notifier);
    final result = await _repository.markAllRead();
    if (result is Ok) revision.bump();
    if (!ref.mounted) return null;
    final latest = state;
    if (latest is! NotificationsLoaded) return null;
    switch (result) {
      case Ok():
        final now = DateTime.now();
        state = latest.copy(
          items: [for (final item in latest.items) item.markedRead(now)],
          unreadCount: 0,
          isLoadingMore: latest.isLoadingMore,
          loadMoreFailure: latest.loadMoreFailure,
        );
        return null;
      case Err(:final failure):
        state = latest.copy(
          isLoadingMore: latest.isLoadingMore,
          loadMoreFailure: latest.loadMoreFailure,
        );
        return failure;
    }
  }

  Future<void> _reload() async {
    final generation = ++_generation;
    final result = await _repository.fetchPage(1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(value: NotificationPage(items: [])) => const NotificationsEmpty(),
      Ok(:final value) => NotificationsLoaded(
        items: value.items,
        total: value.total,
        unreadCount: value.unreadCount,
        loadedPages: 1,
      ),
      Err(:final failure) => NotificationsFailed(failure),
    };
  }
}
