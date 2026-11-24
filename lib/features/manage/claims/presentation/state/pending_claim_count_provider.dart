import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/state/admin_claims_revision.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'pending_claim_count_provider.g.dart';

/// How many claims wait for a decision in [scope] (the list's `total` for
/// the first pending page). Null when it couldn't be loaded; the hub then
/// shows its usual text. Reloads after each decision.
@riverpod
Future<int?> pendingClaimCount(Ref ref, ManageScope scope) async {
  ref.watch(adminClaimsRevisionProvider(scope));
  final result = await ref
      .read(adminClaimRepositoryProvider(scope))
      .fetchClaims(ClaimStatus.pending, 1);
  return switch (result) {
    Ok(:final value) => value.total,
    Err() => null,
  };
}
