import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';

/// A brand's own profile and team (V2-12), under `/brand/:brandId`. Every
/// call needs an approved brand the person belongs to; owners only for
/// changes.
abstract interface class BrandPortalRepository {
  Future<Result<BrandProfile>> fetchProfile(String brandId);

  /// Owners only.
  Future<Result<BrandProfile>> updateProfile(
    String brandId,
    BrandProfileDraft draft,
  );

  Future<Result<List<BrandMember>>> fetchMembers(String brandId);

  /// Owners only. [emailOrPhone] is an email or an E.164 number; the API
  /// sends the invite link.
  Future<Result<void>> invite(
    String brandId, {
    required String emailOrPhone,
    required BrandRole role,
  });

  /// Owners only. Refused when [userId] is the last owner.
  Future<Result<void>> removeMember(String brandId, String userId);
}
