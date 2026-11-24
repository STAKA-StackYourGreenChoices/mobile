import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:staka/features/brand_apply/data/dtos/brand_application_dto.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';

/// `/admin/brand-applications` (read) and `/admin/brands/:id/*` (decide).
class BrandReviewRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  static String apiStatus(BrandApplicationStatus status) => switch (status) {
    BrandApplicationStatus.pending => 'PENDING',
    BrandApplicationStatus.approved => 'ACTIVE',
    BrandApplicationStatus.rejected => 'REJECTED',
    BrandApplicationStatus.suspended => 'SUSPENDED',
  };

  Future<List<ReviewBrand>> list(BrandApplicationStatus status) async {
    final response = await _dio.get<Object>(
      '/admin/brand-applications',
      queryParameters: {'status': apiStatus(status)},
    );
    // A plain list, or a page with `items`: the contract doesn't say.
    final items = switch (response.data) {
      final List<dynamic> list => list,
      {'items': final List<dynamic> list} => list,
      _ => const <dynamic>[],
    };
    return [
      for (final item in items)
        reviewBrandFromJson(item as Map<String, dynamic>),
    ];
  }

  Future<ReviewBrand> detail(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/admin/brand-applications/${Uri.encodeComponent(id)}',
    );
    return reviewBrandFromJson(response.data!);
  }

  Future<BrandDocument> document(String id) async {
    final response = await _dio.get<List<int>>(
      '/admin/brand-applications/${Uri.encodeComponent(id)}/document',
      options: Options(responseType: ResponseType.bytes),
    );
    return BrandDocument(
      bytes: Uint8List.fromList(response.data!),
      mimeType:
          response.headers.value(Headers.contentTypeHeader)?.split(';').first ??
          '',
    );
  }

  /// `approve`, `reject`, `suspend` or `reinstate`; the answer isn't read.
  Future<void> decide(String id, String action, {String? reason}) =>
      _dio.post<void>(
        '/admin/brands/${Uri.encodeComponent(id)}/$action',
        data: {'reason': ?reason},
      );
}

/// Lenient: the application fields the shopper side already reads, plus
/// the member count (`memberCount`, or Prisma's `_count.members`) and
/// whether a document was sent.
ReviewBrand reviewBrandFromJson(Map<String, dynamic> json) => ReviewBrand(
  application: BrandApplicationDto.fromJson(json).toDomain(),
  memberCount: switch (json) {
    {'memberCount': final int count} => count,
    {'_count': {'members': final int count}} => count,
    _ => null,
  },
  hasDocument: switch (json) {
    {'hasDocument': final bool has} => has,
    {'verificationDocPath': final String path} => path.isNotEmpty,
    _ => false,
  },
  reviewedAt: switch (json['reviewedAt']) {
    final String at => DateTime.tryParse(at),
    _ => null,
  },
);
