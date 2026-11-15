import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';
import 'package:staka/features/admin/claims/presentation/state/admin_claims_revision.dart';
import 'package:staka/features/admin/claims/presentation/state/claim_list_state.dart';

part 'admin_claims_controller.g.dart';

/// The claims with one [status], 20 at a time as the admin scrolls (the
/// website pages them with Previous / Next).
@riverpod
class AdminClaimsController extends _$AdminClaimsController {
  /// Bumped on every reload, so answers to an older one are dropped.
  int _generation = 0;

  @override
  ClaimListState build(ClaimStatus status) {
    ref.listen(adminClaimsRevisionProvider, (_, _) => unawaited(refresh()));
    unawaited(Future.microtask(_reload));
    return const ClaimListLoading();
  }

  Future<void> retry() async {
    state = const ClaimListLoading();
    await _reload();
  }

  /// Pull to refresh: back to the first page, the list stays meanwhile.
  Future<void> refresh() => _reload();

  Future<void> loadMore() async {
    final current = state;
    if (current is! ClaimListLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }
    final generation = _generation;
    state = current.copy(isLoadingMore: true);
    final result = await ref
        .read(adminClaimRepositoryProvider)
        .fetchClaims(status, current.loadedPages + 1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(:final value) => ClaimListLoaded(
        items: [...current.items, ...value.items],
        total: value.total,
        loadedPages: current.loadedPages + 1,
      ),
      Err(:final failure) => current.copy(loadMoreFailure: failure),
    };
  }

  Future<void> _reload() async {
    final generation = ++_generation;
    final result = await ref
        .read(adminClaimRepositoryProvider)
        .fetchClaims(status, 1);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(value: ClaimPage(total: 0)) => const ClaimListEmpty(),
      Ok(:final value) => ClaimListLoaded(
        items: value.items,
        total: value.total,
        loadedPages: 1,
      ),
      Err(:final failure) => ClaimListFailed(failure),
    };
  }
}
