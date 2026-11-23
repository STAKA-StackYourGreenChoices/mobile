import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/brand_portal/data/repositories/brand_portal_repository_impl.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';

part 'brand_team_controllers.g.dart';

/// [brandId]'s team, owners first. Loading while the future runs.
@riverpod
Future<Result<List<BrandMember>>> brandMembers(Ref ref, String brandId) =>
    ref.read(brandPortalRepositoryProvider).fetchMembers(brandId);

/// Owners invite someone by email or number (`POST …/members`).
@riverpod
class BrandInviteController extends _$BrandInviteController {
  @override
  RequestState<void> build(String brandId) => const RequestIdle();

  Future<void> invite({
    required String emailOrPhone,
    required BrandRole role,
  }) async {
    if (state is RequestSending) return;
    state = const RequestSending();
    final result = await ref
        .read(brandPortalRepositoryProvider)
        .invite(brandId, emailOrPhone: emailOrPhone, role: role);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }

  void reset() => state = const RequestIdle();
}

/// Owners take someone off the team; the list reloads afterwards.
@riverpod
class BrandMemberRemoveController extends _$BrandMemberRemoveController {
  @override
  RequestState<void> build(String brandId, String userId) =>
      const RequestIdle();

  Future<void> remove() async {
    if (state is RequestSending) return;
    state = const RequestSending();
    final result = await ref
        .read(brandPortalRepositoryProvider)
        .removeMember(brandId, userId);
    if (!ref.mounted) return;
    if (result is Ok) ref.invalidate(brandMembersProvider(brandId));
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }

  void reset() => state = const RequestIdle();
}
