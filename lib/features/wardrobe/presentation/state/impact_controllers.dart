import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/cards/cards_revision.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/wardrobe/data/repositories/impact_repository_impl.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';

part 'impact_controllers.g.dart';

/// The wardrobe's impact summary (V2-5). Null when it couldn't be loaded
/// (e.g. an API without it): the wardrobe then simply has no card.
/// Reloads whenever the tags change.
@riverpod
Future<Impact?> wardrobeImpact(Ref ref) async {
  ref.watch(cardsRevisionProvider);
  final result = await ref.read(impactRepositoryProvider).fetchImpact();
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
}

/// The Activity screen's states.
sealed class ActivityState {
  const new();
}

final class ActivityLoading extends ActivityState {
  const new();
}

final class ActivityEmpty extends ActivityState {
  const new();
}

final class ActivityFailed extends ActivityState {
  const new(this.failure);

  final Failure failure;
}

final class ActivityLoaded extends ActivityState {
  const new({
    required this.items,
    required this.total,
    required this.loadedPages,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<ActivityItem> items;
  final int total;
  final int loadedPages;
  final bool isLoadingMore;

  /// The next page failed; the list stays and offers to try again.
  final Failure? loadMoreFailure;

  bool get hasMore => items.length < total;

  ActivityLoaded copy({bool isLoadingMore = false, Failure? loadMoreFailure}) =>
      ActivityLoaded(
        items: items,
        total: total,
        loadedPages: loadedPages,
        isLoadingMore: isLoadingMore,
        loadMoreFailure: loadMoreFailure,
      );
}

/// The activity timeline, 20 entries at a time as the shopper scrolls.
@riverpod
class ActivityController extends _$ActivityController {
  /// Bumped on every reload, so answers to an older one are dropped.
  int _generation = 0;

  @override
  ActivityState build() {
    unawaited(Future.microtask(_reload));
    return const ActivityLoading();
  }

  Future<void> retry() async {
    state = const ActivityLoading();
    await _reload();
  }

  /// Pull to refresh: back to the first page, the list stays meanwhile.
  Future<void> refresh() => _reload();

  Future<void> loadMore() async {
    final current = state;
    if (current is! ActivityLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }
    final generation = _generation;
    state = current.copy(isLoadingMore: true);
    final result = await ref
        .read(impactRepositoryProvider)
        .fetchActivity(current.loadedPages + 1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(:final value) => ActivityLoaded(
        items: [...current.items, ...value.items],
        total: value.total,
        loadedPages: current.loadedPages + 1,
      ),
      Err(:final failure) => current.copy(loadMoreFailure: failure),
    };
  }

  Future<void> _reload() async {
    final generation = ++_generation;
    final result = await ref.read(impactRepositoryProvider).fetchActivity(1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(value: ActivityPage(items: [])) => const ActivityEmpty(),
      Ok(:final value) => ActivityLoaded(
        items: value.items,
        total: value.total,
        loadedPages: 1,
      ),
      Err(:final failure) => ActivityFailed(failure),
    };
  }
}
