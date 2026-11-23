import 'package:dio/dio.dart';

import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/data/dtos/brand_portal_dtos.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';

/// `GET/PATCH /brand/:brandId`, `GET/POST /brand/:brandId/members`,
/// `DELETE /brand/:brandId/members/:userId` (API plan V2-12).
class BrandPortalRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  static String _brand(String brandId) =>
      '/brand/${Uri.encodeComponent(brandId)}';

  Future<BrandProfile> fetchProfile(String brandId) async {
    final response = await _dio.get<Map<String, dynamic>>(_brand(brandId));
    return brandProfileFromJson(response.data!);
  }

  /// Multipart like the application, so the logo can go with it; empty
  /// optional fields and an unchanged logo are left out.
  Future<BrandProfile> updateProfile(
    String brandId,
    BrandProfileDraft draft,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      _brand(brandId),
      data: FormData.fromMap({
        'name': draft.name,
        'contactEmail': draft.contactEmail,
        'description': ?draft.description,
        'websiteUrl': ?draft.websiteUrl,
        'contactPhone': ?draft.contactPhone,
        if (draft.logo case final logo?)
          'logo': MultipartFile.fromBytes(logo.bytes, filename: logo.name),
      }),
    );
    return brandProfileFromJson(response.data!);
  }

  Future<List<BrandMember>> fetchMembers(String brandId) async {
    final response = await _dio.get<List<dynamic>>(
      '${_brand(brandId)}/members',
    );
    return [
      for (final item in response.data!)
        brandMemberFromJson(item as Map<String, dynamic>),
    ];
  }

  Future<void> invite(
    String brandId, {
    required String emailOrPhone,
    required BrandRole role,
  }) => _dio.post<void>(
    '${_brand(brandId)}/members',
    data: {'emailOrPhone': emailOrPhone, 'role': brandRoleToJson(role)},
  );

  Future<void> removeMember(String brandId, String userId) => _dio.delete<void>(
    '${_brand(brandId)}/members/${Uri.encodeComponent(userId)}',
  );
}
