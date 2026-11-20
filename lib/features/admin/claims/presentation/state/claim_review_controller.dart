import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/admin/claims/presentation/state/claim_review_state.dart';

part 'claim_review_controller.g.dart';

/// One claim with its history, then its product for the hang tag: what
/// the website's `/admin/claims/[id]` loads.
@riverpod
class ClaimReviewController extends _$ClaimReviewController {
  static final _uuid = RegExp(r'^[0-9a-f-]{36}$', caseSensitive: false);

  @override
  ClaimReviewState build(String claimId) {
    unawaited(Future.microtask(_load));
    return const ClaimReviewLoading();
  }

  Future<void> retry() async {
    state = const ClaimReviewLoading();
    await _load();
  }

  Future<void> _load() async {
    if (!_uuid.hasMatch(claimId)) {
      state = const ClaimReviewNotFound();
      return;
    }
    final repository = ref.read(adminClaimRepositoryProvider);
    final result = await repository.fetchClaim(claimId);
    if (!ref.mounted) return;
    switch (result) {
      case Err(failure: NotFoundFailure()):
        state = const ClaimReviewNotFound();
      case Err(:final failure):
        state = ClaimReviewFailed(failure);
      case Ok(:final value):
        final product = await repository.fetchProduct(value.claim.product.id);
        if (!ref.mounted) return;
        state = ClaimReviewReady(
          value,
          product: switch (product) {
            Ok(value: final product) => product,
            Err() => null,
          },
        );
    }
  }
}
