import 'package:dio/dio.dart';

import 'package:staka/core/api_models/brand_summary_dto.dart';

/// `GET /brands`, sorted by name. Shared by the admin products filter, the
/// product form's brand picker and the brands screen.
class BrandsApi {
  const new(this._dio);

  final Dio _dio;

  Future<List<BrandSummaryDto>> fetchAll() async {
    final response = await _dio.get<List<dynamic>>('/brands');
    return [
      for (final item in response.data!)
        BrandSummaryDto.fromJson(item as Map<String, dynamic>),
    ];
  }
}
