import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/admin/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';
import 'package:staka/features/admin/claims/domain/repositories/admin_claim_repository.dart';
import 'package:staka/features/admin/claims/presentation/state/admin_claims_revision.dart';

part 'claim_decision_controller.g.dart';

/// Approve or reject one claim. Done holds the decision made.
@riverpod
class ClaimDecisionController extends _$ClaimDecisionController {
  @override
  RequestState<ClaimStatus> build(String claimId) => const RequestIdle();

  Future<void> approve() => _decide(
    ClaimStatus.approved,
    (repository) => repository.approve(claimId),
  );

  Future<void> reject(String reason) => _decide(
    ClaimStatus.rejected,
    (repository) => repository.reject(claimId, reason),
  );

  Future<void> _decide(
    ClaimStatus decision,
    Future<Result<ClaimDetail>> Function(AdminClaimRepository repository) call,
  ) async {
    if (state is RequestSending) return;
    final repository = ref.read(adminClaimRepositoryProvider);
    final revision = ref.read(adminClaimsRevisionProvider.notifier);
    state = const RequestSending();
    final result = await call(repository);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => RequestDone(decision),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
