import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/features/manage/shared/manage_scope.dart';

part 'admin_claims_revision.g.dart';

/// Bumped after a claim is approved or rejected, so the claim lists in
/// that [ManageScope] reload (the website's `revalidatePath`).
@Riverpod(keepAlive: true)
class AdminClaimsRevision extends _$AdminClaimsRevision {
  @override
  int build(ManageScope scope) => 0;

  void bump() => state++;
}
