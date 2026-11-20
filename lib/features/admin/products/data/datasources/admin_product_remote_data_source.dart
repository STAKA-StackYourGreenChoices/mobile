import 'package:dio/dio.dart';

import 'package:staka/core/api_models/product_dto.dart';

/// `GET /products` with the website's query: `search`, `brandId`, `page`,
/// `limit`.
class AdminProductRemoteDataSource {
  const new(this._dio);

  static const pageSize = 20;

  final Dio _dio;

  Future<({List<ProductDto> items, int total, int page, int limit})> fetch({
    required int page,
    String search = '',
    String? brandId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/products',
      queryParameters: {
        'page': page,
        'limit': pageSize,
        if (search.isNotEmpty) 'search': search,
        'brandId': ?brandId,
      },
    );
    final body = response.data!;
    return (
      items: [
        for (final item in body['items'] as List<dynamic>)
          ProductDto.fromJson(item as Map<String, dynamic>),
      ],
      total: body['total'] as int,
      page: body['page'] as int,
      limit: body['limit'] as int,
    );
  }
}
