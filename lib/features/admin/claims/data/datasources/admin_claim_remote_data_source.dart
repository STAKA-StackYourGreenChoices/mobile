import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/features/admin/claims/data/dtos/claim_dto.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';

/// `/claims` (list, detail, receipt, approve, reject) and the claimed
/// product, as the website's claims pages call them.
class AdminClaimRemoteDataSource {
  const new(this._dio);

  static const pageSize = 20;

  final Dio _dio;

  Future<ClaimPage> list(ClaimStatus status, int page) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/claims',
      queryParameters: {
        'status': status.apiName,
        'page': page,
        'limit': pageSize,
      },
    );
    final body = response.data!;
    return ClaimPage(
      items: [
        for (final item in body['items'] as List<dynamic>)
          ClaimDto.fromJson(item as Map<String, dynamic>).toDomain(),
      ],
      total: body['total'] as int,
    );
  }

  Future<ClaimDetail> detail(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/claims/$id');
    return claimDetailFromJson(response.data!);
  }

  Future<ClaimReceipt> receipt(String id) async {
    final response = await _dio.get<List<int>>(
      '/claims/$id/receipt',
      options: Options(responseType: ResponseType.bytes),
    );
    return ClaimReceipt(
      bytes: Uint8List.fromList(response.data!),
      mimeType:
          response.headers.value(Headers.contentTypeHeader)?.split(';').first ??
          '',
    );
  }

  Future<ProductDto> product(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/products/$id');
    return ProductDto.fromJson(response.data!);
  }

  Future<ClaimDetail> approve(String id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/claims/$id/approve',
    );
    return claimDetailFromJson(response.data!);
  }

  Future<ClaimDetail> reject(String id, String reason) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/claims/$id/reject',
      data: {'reason': reason},
    );
    return claimDetailFromJson(response.data!);
  }
}
