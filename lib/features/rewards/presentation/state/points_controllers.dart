import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staka/core/cards/cards_revision.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/core/rewards/points_revision.dart';
import 'package:staka/features/rewards/data/points_repository.dart';

part 'points_controllers.g.dart';

/// The Rewards tab's balance (first page of `/me/points`). Reloads when
/// points may have changed: tags (verified, shared) or a redeem.
@riverpod
Future<Result<PointsPage>> pointsOverview(Ref ref) {
  ref
    ..watch(cardsRevisionProvider)
    ..watch(pointsRevisionProvider);
  return ref.read(pointsRepositoryProvider).fetchPoints(1);
}

/// "How to earn"; null when the rules couldn't be loaded (section hidden).
@riverpod
Future<List<EarnRule>?> earnRules(Ref ref) async =>
    switch (await ref.read(pointsRepositoryProvider).fetchEarnRules()) {
      Ok(:final value) => value,
      Err() => null,
    };

sealed class PointsHistoryState {
  const new();
}

final class PointsHistoryLoading extends PointsHistoryState {
  const new();
}

final class PointsHistoryEmpty extends PointsHistoryState {
  const new();
}

final class PointsHistoryFailed extends PointsHistoryState {
  const new(this.failure);

  final Failure failure;
}

final class PointsHistoryLoaded extends PointsHistoryState {
  const new({
    required this.entries,
    required this.total,
    required this.loadedPages,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<PointsEntry> entries;
  final int total;
  final int loadedPages;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;

  bool get hasMore => entries.length < total;

  PointsHistoryLoaded copy({
    bool isLoadingMore = false,
    Failure? loadMoreFailure,
  }) => PointsHistoryLoaded(
    entries: entries,
    total: total,
    loadedPages: loadedPages,
    isLoadingMore: isLoadingMore,
    loadMoreFailure: loadMoreFailure,
  );
}

/// Every points entry, newest first, 20 at a time as the shopper scrolls.
@riverpod
class PointsHistoryController extends _$PointsHistoryController {
  /// Bumped on every reload, so answers to an older one are dropped.
  int _generation = 0;

  @override
  PointsHistoryState build() {
    unawaited(Future.microtask(_reload));
    return const PointsHistoryLoading();
  }

  Future<void> retry() async {
    state = const PointsHistoryLoading();
    await _reload();
  }

  Future<void> refresh() => _reload();

  Future<void> loadMore() async {
    final current = state;
    if (current is! PointsHistoryLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }
    final generation = _generation;
    state = current.copy(isLoadingMore: true);
    final result = await ref
        .read(pointsRepositoryProvider)
        .fetchPoints(current.loadedPages + 1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(:final value) => PointsHistoryLoaded(
        entries: [...current.entries, ...value.entries],
        total: value.total,
        loadedPages: current.loadedPages + 1,
      ),
      Err(:final failure) => current.copy(loadMoreFailure: failure),
    };
  }

  Future<void> _reload() async {
    final generation = ++_generation;
    final result = await ref.read(pointsRepositoryProvider).fetchPoints(1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(value: PointsPage(entries: [])) => const PointsHistoryEmpty(),
      Ok(:final value) => PointsHistoryLoaded(
        entries: value.entries,
        total: value.total,
        loadedPages: 1,
      ),
      Err(:final failure) => PointsHistoryFailed(failure),
    };
  }
}
