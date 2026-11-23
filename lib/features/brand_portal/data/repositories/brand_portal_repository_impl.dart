import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/brand_portal/data/datasources/brand_portal_remote_data_source.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';
import 'package:staka/features/brand_portal/domain/repositories/brand_portal_repository.dart';

part 'brand_portal_repository_impl.g.dart';

@riverpod
BrandPortalRepository brandPortalRepository(Ref ref) =>
    BrandPortalRepositoryImpl(
      BrandPortalRemoteDataSource(ref.watch(dioProvider)),
    );

class BrandPortalRepositoryImpl implements BrandPortalRepository {
  const new(this._remote);

  final BrandPortalRemoteDataSource _remote;

  @override
  Future<Result<BrandProfile>> fetchProfile(String brandId) =>
      guardApi(() => _remote.fetchProfile(brandId));

  @override
  Future<Result<BrandProfile>> updateProfile(
    String brandId,
    BrandProfileDraft draft,
  ) => guardApi(() => _remote.updateProfile(brandId, draft));

  /// Owners first, then by name, whatever order the API sends.
  @override
  Future<Result<List<BrandMember>>> fetchMembers(String brandId) =>
      guardApi(() async {
        final members = await _remote.fetchMembers(brandId);
        return members..sort(
          (a, b) => switch ((a.role, b.role)) {
            (BrandRole.owner, BrandRole.staff) => -1,
            (BrandRole.staff, BrandRole.owner) => 1,
            _ => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          },
        );
      });

  /// The form sends a trimmed email or an E.164 number.
  @override
  Future<Result<void>> invite(
    String brandId, {
    required String emailOrPhone,
    required BrandRole role,
  }) => guardApi(
    () => _remote.invite(brandId, emailOrPhone: emailOrPhone, role: role),
  );

  @override
  Future<Result<void>> removeMember(String brandId, String userId) =>
      guardApi(() => _remote.removeMember(brandId, userId));
}
