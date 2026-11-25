import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/rewards/points_revision.dart';
import 'package:staka/core/utils/idempotency_key.dart';
import 'package:staka/features/rewards/data/rewards_repository.dart';
import 'package:staka/features/rewards/domain/reward.dart';

part 'rewards_controllers.g.dart';

/// The catalog on the Rewards tab. Reloads after a redeem (stock and what
/// the shopper can afford change).
@riverpod
Future<Result<List<Reward>>> rewardsCatalog(Ref ref) {
  ref.watch(pointsRevisionProvider);
  return ref.read(rewardsRepositoryProvider).fetchRewards();
}

@riverpod
Future<Result<Reward>> rewardDetail(Ref ref, String id) {
  ref.watch(pointsRevisionProvider);
  return ref.read(rewardsRepositoryProvider).fetchReward(id);
}

/// Why a redeem didn't happen.
enum RedeemProblem {
  /// 422: the balance is below the cost.
  notEnoughPoints,

  /// 409: no codes left.
  outOfStock,

  /// 404 / 410: the reward ended or was switched off.
  ended,

  /// Anything else; [RedeemFailed.failure] says what.
  other,
}

sealed class RedeemState {
  const new();
}

final class RedeemIdle extends RedeemState {
  const new();
}

final class RedeemSending extends RedeemState {
  const new();
}

final class RedeemDone extends RedeemState {
  const new(this.voucher);

  final Voucher voucher;
}

final class RedeemFailed extends RedeemState {
  const new(this.problem, this.failure);

  final RedeemProblem problem;
  final Failure failure;
}

/// Redeeming one reward. Every tap sends a new `Idempotency-Key`, except
/// a retry after an answer that never came (network, server error): that
/// one sends the same key, so the API answers the first redeem instead of
/// taking points twice.
@riverpod
class RedeemController extends _$RedeemController {
  /// Kept while the last outcome is unknown.
  String? _pendingKey;

  @override
  RedeemState build(String rewardId) => const RedeemIdle();

  Future<void> redeem(Reward reward) async {
    if (state is RedeemSending || state is RedeemDone) return;
    final key = _pendingKey ?? ref.read(idempotencyKeysProvider)();
    _pendingKey = key;
    final revision = ref.read(pointsRevisionProvider.notifier);
    state = const RedeemSending();
    final result = await ref
        .read(rewardsRepositoryProvider)
        .redeem(reward, idempotencyKey: key);
    switch (result) {
      case Ok():
        _pendingKey = null;
        revision.bump();
      case Err(:final failure):
        if (!_isUnknownOutcome(failure)) _pendingKey = null;
    }
    if (!ref.mounted) return;
    // Stock or the reward itself changed: show what's true now.
    if (result case Err(:final failure)
        when _problem(failure) == RedeemProblem.outOfStock ||
            _problem(failure) == RedeemProblem.ended) {
      ref
        ..invalidate(rewardsCatalogProvider)
        ..invalidate(rewardDetailProvider(rewardId));
    }
    state = switch (result) {
      Ok(:final value) => RedeemDone(value),
      Err(:final failure) => RedeemFailed(_problem(failure), failure),
    };
  }

  static bool _isUnknownOutcome(Failure failure) => switch (failure) {
    NetworkFailure() || ServerFailure() || UnknownFailure() => true,
    _ => false,
  };

  static RedeemProblem _problem(Failure failure) => switch (failure) {
    ConflictFailure() => RedeemProblem.outOfStock,
    NotFoundFailure() => RedeemProblem.ended,
    ApiFailure(statusCode: 422) => RedeemProblem.notEnoughPoints,
    ApiFailure(statusCode: 410) => RedeemProblem.ended,
    _ => RedeemProblem.other,
  };
}

sealed class VouchersState {
  const new();
}

final class VouchersLoading extends VouchersState {
  const new();
}

final class VouchersEmpty extends VouchersState {
  const new();
}

final class VouchersFailed extends VouchersState {
  const new(this.failure);

  final Failure failure;
}

final class VouchersLoaded extends VouchersState {
  const new({
    required this.items,
    required this.total,
    required this.loadedPages,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<Voucher> items;
  final int total;
  final int loadedPages;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;

  bool get hasMore => items.length < total;

  VouchersLoaded copy({bool isLoadingMore = false, Failure? loadMoreFailure}) =>
      VouchersLoaded(
        items: items,
        total: total,
        loadedPages: loadedPages,
        isLoadingMore: isLoadingMore,
        loadMoreFailure: loadMoreFailure,
      );
}

/// My vouchers, newest first, 20 at a time. Reloads after a redeem.
@riverpod
class VouchersController extends _$VouchersController {
  int _generation = 0;

  @override
  VouchersState build() {
    ref.watch(pointsRevisionProvider);
    unawaited(Future.microtask(_reload));
    return const VouchersLoading();
  }

  Future<void> retry() async {
    state = const VouchersLoading();
    await _reload();
  }

  Future<void> refresh() => _reload();

  Future<void> loadMore() async {
    final current = state;
    if (current is! VouchersLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }
    final generation = _generation;
    state = current.copy(isLoadingMore: true);
    final result = await ref
        .read(rewardsRepositoryProvider)
        .fetchVouchers(current.loadedPages + 1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(:final value) => VouchersLoaded(
        items: [...current.items, ...value.items],
        total: value.total,
        loadedPages: current.loadedPages + 1,
      ),
      Err(:final failure) => current.copy(loadMoreFailure: failure),
    };
  }

  Future<void> _reload() async {
    final generation = ++_generation;
    final result = await ref.read(rewardsRepositoryProvider).fetchVouchers(1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(value: VoucherPage(items: [])) => const VouchersEmpty(),
      Ok(:final value) => VouchersLoaded(
        items: value.items,
        total: value.total,
        loadedPages: 1,
      ),
      Err(:final failure) => VouchersFailed(failure),
    };
  }
}
