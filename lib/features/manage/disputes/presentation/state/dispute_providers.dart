import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/claims/presentation/state/admin_claims_revision.dart';
import 'package:staka/features/manage/disputes/data/dispute_repository_impl.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'dispute_providers.g.dart';

/// Bumped after every resolution, so the lists and the hub count reload.
@Riverpod(keepAlive: true)
class DisputesRevision extends _$DisputesRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

@riverpod
Future<Result<List<AdminDispute>>> disputes(Ref ref, DisputeStatus status) {
  ref.watch(disputesRevisionProvider);
  return ref.read(disputeRepositoryProvider).fetchDisputes(status);
}

/// One dispute by id. The API has no detail endpoint, so it is looked up
/// in the open list, then the resolved ones.
@riverpod
Future<Result<AdminDispute>> adminDispute(Ref ref, String id) async {
  Failure? failure;
  for (final status in DisputeStatus.values) {
    final result = await ref.watch(disputesProvider(status).future);
    switch (result) {
      case Ok(:final value):
        for (final dispute in value) {
          if (dispute.id == id) return Ok(dispute);
        }
      case Err(failure: final error):
        failure ??= error;
    }
  }
  return Err(failure ?? const NotFoundFailure([]));
}

/// How many disputes wait for a decision; null if unknown.
@riverpod
Future<int?> openDisputeCount(Ref ref) async {
  final result = await ref.watch(disputesProvider(DisputeStatus.open).future);
  return switch (result) {
    Ok(:final value) => value.length,
    Err() => null,
  };
}

/// Uphold or overturn one dispute, with a note for the shopper.
@riverpod
class DisputeResolveController extends _$DisputeResolveController {
  @override
  RequestState<void> build(String disputeId) => const RequestIdle();

  Future<void> resolve(DisputeOutcome outcome, String note) async {
    if (state is RequestSending) return;
    final revision = ref.read(disputesRevisionProvider.notifier);
    // Overturning approves the claim: the claim lists change too.
    final claims = ref.read(
      adminClaimsRevisionProvider(const AdminScope()).notifier,
    );
    state = const RequestSending();
    final result = await ref
        .read(disputeRepositoryProvider)
        .resolve(disputeId, outcome, note);
    if (result is Ok) {
      revision.bump();
      claims.bump();
    }
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }

  void reset() {
    if (state is! RequestSending) state = const RequestIdle();
  }
}
