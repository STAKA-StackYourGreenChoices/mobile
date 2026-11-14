import 'package:dio/dio.dart';

import 'package:staka/core/api_models/product_dto.dart';

/// `GET /products/gtin/:gtin`. The API validates the check digit (400) and
/// answers 404 for a code no brand has added.
class ProductRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<ProductDto> fetchByGtin(String gtin) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/products/gtin/${Uri.encodeComponent(gtin)}',
    );
    return ProductDto.fromJson(response.data!);
  }
}
