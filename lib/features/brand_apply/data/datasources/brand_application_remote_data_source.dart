import 'package:dio/dio.dart';

import 'package:staka/features/brand_apply/data/dtos/brand_application_dto.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application_draft.dart';

/// `POST /brand-applications`, `PATCH /brand-applications/:id` (multipart)
/// and `GET /me/brand-applications` (API plan V2-12). All signed in.
class BrandApplicationRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<List<BrandApplicationDto>> fetchMine() async {
    final response = await _dio.get<List<dynamic>>('/me/brand-applications');
    return [
      for (final item in response.data!)
        BrandApplicationDto.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<BrandApplicationDto> apply(BrandApplicationDraft draft) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/brand-applications',
      data: formFor(draft),
    );
    return BrandApplicationDto.fromJson(response.data!);
  }

  Future<BrandApplicationDto> resubmit(
    String applicationId,
    BrandApplicationDraft draft,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/brand-applications/${Uri.encodeComponent(applicationId)}',
      data: formFor(draft),
    );
    return BrandApplicationDto.fromJson(response.data!);
  }

  /// The API's field names. Empty optional fields and unpicked files are
  /// left out (the API rejects unknown or blank fields); the API checks a
  /// file's real type from its bytes, not its name.
  static FormData formFor(BrandApplicationDraft draft) => FormData.fromMap({
    'name': draft.name,
    'legalName': draft.legalName,
    'contactEmail': draft.contactEmail,
    'contactPhone': ?draft.contactPhone,
    'websiteUrl': ?draft.websiteUrl,
    'gstin': ?draft.gstin,
    'description': ?draft.description,
    'existingBrandId': ?draft.existingBrandId,
    if (draft.logo case final logo?)
      'logo': MultipartFile.fromBytes(logo.bytes, filename: logo.name),
    if (draft.document case final document?)
      'document': MultipartFile.fromBytes(
        document.bytes,
        filename: document.name,
      ),
  });
}
