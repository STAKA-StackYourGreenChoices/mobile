import 'package:dio/dio.dart';

import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/features/admin/products/domain/models/product_draft.dart';

/// One product: `GET`, `POST`, `PATCH` and `DELETE /products[/:id]`, with
/// the body the website's `saveProduct` sends.
class ProductEditorRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<ProductDto> fetch(String id) =>
      _product(_dio.get<Map<String, dynamic>>('/products/$id'));

  Future<ProductDto> create(ProductDraft draft) => _product(
    _dio.post<Map<String, dynamic>>(
      '/products',
      data: _body(draft, isEdit: false),
    ),
  );

  Future<ProductDto> update(String id, ProductDraft draft) => _product(
    _dio.patch<Map<String, dynamic>>(
      '/products/$id',
      data: _body(draft, isEdit: true),
    ),
  );

  Future<void> delete(String id) => _dio.delete<void>('/products/$id');

  Future<ProductDto> _product(
    Future<Response<Map<String, dynamic>>> request,
  ) async => ProductDto.fromJson((await request).data!);

  /// On edit an empty description or photo is sent as null, which clears
  /// it; on create it is left out. Figures, once added, are always sent.
  static Map<String, Object?> _body(
    ProductDraft draft, {
    required bool isEdit,
  }) => {
    'name': draft.name,
    'brandId': draft.brandId,
    'gtin': draft.gtin,
    'sku': draft.sku,
    if (draft.description != null || isEdit) 'description': draft.description,
    if (draft.imageUrl != null || isEdit) 'imageUrl': draft.imageUrl,
    if (draft.figures case final figures?)
      'sustainabilityInfo': {
        'carbonScoreGrams': figures.carbonScoreGrams,
        'recyclabilityPercent': figures.recyclabilityPercent,
        'verified': figures.isVerified,
        if (figures.isVerified) 'certifierName': figures.certifierName,
      },
  };
}
