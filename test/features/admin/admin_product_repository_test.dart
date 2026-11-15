import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/data/datasources/admin_product_remote_data_source.dart';
import 'package:staka/features/admin/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';

import '../../helpers/fake_http_adapter.dart';

Map<String, Object?> _product() => {
  'id': 'p1',
  'gtin': '08901234500019',
  'sku': 'TT-TEE-01',
  'name': 'Organic Cotton Tee',
  'brand': {'id': 'b1', 'name': 'Terra Threads'},
  'createdAt': '2026-11-01T00:00:00.000Z',
  'updatedAt': '2026-11-02T00:00:00.000Z',
  'sustainabilityInfo': {
    'carbonScoreGrams': 2100,
    'recyclabilityPercent': 80,
    'verified': true,
    'certifierName': 'Global Organic Textile Standard',
  },
};

(AdminProductRepositoryImpl, FakeHttpAdapter) _repository(
  List<FakeReply> replies,
) {
  final adapter = FakeHttpAdapter(replies);
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = adapter;
  return (
    AdminProductRepositoryImpl(
      AdminProductRemoteDataSource(dio),
      BrandsApi(dio),
    ),
    adapter,
  );
}

void main() {
  test(
    'asks for a page of 20 with the search and brand, like the website',
    () async {
      final (repository, adapter) = _repository([
        json(200, {
          'items': [_product()],
          'total': 41,
          'page': 3,
          'limit': 20,
        }),
      ]);

      final result = await repository.fetchProducts(
        const ProductFilter(search: 'tee', brandId: 'b1'),
        3,
      );

      final request = adapter.requests.single;
      expect(request.path, '/products');
      expect(request.queryParameters, {
        'page': 3,
        'limit': 20,
        'search': 'tee',
        'brandId': 'b1',
      });
      final page = (result as Ok<ProductPage>).value;
      expect(page.total, 41);
      expect(page.items.single.name, 'Organic Cotton Tee');
      expect(page.items.single.sustainabilityInfo?.isVerified, isTrue);
    },
  );

  test('no filter: only page and limit are sent', () async {
    final (repository, adapter) = _repository([
      json(200, {'items': <Object?>[], 'total': 0, 'page': 1, 'limit': 20}),
    ]);

    await repository.fetchProducts(const ProductFilter(), 1);

    expect(adapter.requests.single.queryParameters, {'page': 1, 'limit': 20});
  });

  test('brands for the filter', () async {
    final (repository, adapter) = _repository([
      json(200, [
        {
          'id': 'b1',
          'name': 'Terra Threads',
          'productCount': 4,
          'createdAt': '2026-11-01T00:00:00.000Z',
        },
      ]),
    ]);

    final result = await repository.fetchBrands();

    expect(adapter.requests.single.path, '/brands');
    final brand = (result as Ok<List<BrandSummary>>).value.single;
    expect(
      (brand.id, brand.name, brand.productCount),
      ('b1', 'Terra Threads', 4),
    );
  });

  test('a refusal comes back as a failure, not an exception', () async {
    final (repository, _) = _repository([
      json(403, {'message': 'Forbidden resource', 'statusCode': 403}),
    ]);

    final result = await repository.fetchProducts(const ProductFilter(), 1);

    expect((result as Err<ProductPage>).failure, isA<ForbiddenFailure>());
  });
}
