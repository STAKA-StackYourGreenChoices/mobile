import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_claims_revision.g.dart';

/// Bumped after a claim is approved or rejected, so the claim lists reload
/// (the website's `revalidatePath('/admin/claims')`).
@Riverpod(keepAlive: true)
class AdminClaimsRevision extends _$AdminClaimsRevision {
  @override
  int build() => 0;

  void bump() => state++;
}
