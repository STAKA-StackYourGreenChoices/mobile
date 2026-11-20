import 'package:dio/dio.dart';

import 'package:staka/core/api_models/brand_summary_dto.dart';
import 'package:staka/features/admin/brands/domain/models/brand_draft.dart';

/// `POST`, `PATCH` and `DELETE /brands[/:id]`, with the body the website's
/// `saveBrand` sends.
class BrandEditorRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<BrandSummaryDto> create(BrandDraft draft) => _brand(
    _dio.post<Map<String, dynamic>>(
      '/brands',
      data: _body(draft, isEdit: false),
    ),
  );

  Future<BrandSummaryDto> update(String id, BrandDraft draft) => _brand(
    _dio.patch<Map<String, dynamic>>(
      '/brands/$id',
      data: _body(draft, isEdit: true),
    ),
  );

  Future<void> delete(String id) => _dio.delete<void>('/brands/$id');

  Future<BrandSummaryDto> _brand(
    Future<Response<Map<String, dynamic>>> request,
  ) async => BrandSummaryDto.fromJson((await request).data!);

  /// On edit an empty field is sent as null, which clears it; on create it
  /// is left out.
  static Map<String, Object?> _body(
    BrandDraft draft, {
    required bool isEdit,
  }) => {
    'name': draft.name,
    if (draft.description != null || isEdit) 'description': draft.description,
    if (draft.logoUrl != null || isEdit) 'logoUrl': draft.logoUrl,
  };
}
