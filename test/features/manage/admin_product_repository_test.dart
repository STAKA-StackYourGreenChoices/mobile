import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/manage/products/data/datasources/admin_product_remote_data_source.dart';
import 'package:staka/features/manage/products/data/datasources/product_editor_remote_data_source.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

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
      AdminProductRemoteDataSource(dio, const AdminScope()),
      BrandsApi(dio),
      ProductEditorRemoteDataSource(dio, const AdminScope()),
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

  group('saving', () {
    const draft = ProductDraft(
      name: 'Hemp Cap',
      brandId: 'b1',
      variants: [VariantDraft(gtin: '8901234500057', sku: 'TT-CAP-01')],
      figures: FiguresDraft(
        carbonScoreGrams: 900,
        recyclabilityPercent: 70,
        isVerified: false,
        certifierName: 'ignored when not verified',
      ),
    );

    test('add: POST, empty optional fields left out', () async {
      final (repository, adapter) = _repository([json(201, _product())]);

      final result = await repository.createProduct(draft);

      final request = adapter.requests.single;
      expect((request.method, request.path), ('POST', '/products'));
      expect(request.data, {
        'name': 'Hemp Cap',
        'brandId': 'b1',
        'gtin': '8901234500057',
        'sku': 'TT-CAP-01',
        'category': 'OTHER',
        'variants': [
          {'gtin': '8901234500057', 'sku': 'TT-CAP-01'},
        ],
        'sustainabilityInfo': {
          'carbonScoreGrams': 900,
          'recyclabilityPercent': 70,
          'verified': false,
        },
      });
      expect((result as Ok<EditableProduct>).value.product.id, 'p1');
    });

    test('edit: PATCH, empty optional fields sent as null to clear', () async {
      final (repository, adapter) = _repository([json(200, _product())]);

      await repository.updateProduct('p1', draft);

      final request = adapter.requests.single;
      expect((request.method, request.path), ('PATCH', '/products/p1'));
      final body = request.data as Map<String, Object?>;
      expect(body['description'], isNull);
      expect(body.containsKey('description'), isTrue);
      expect(body.containsKey('imageUrl'), isTrue);
      expect(body.containsKey('styleCode'), isTrue);
      expect(body['variants'], [
        {
          'gtin': '8901234500057',
          'sku': 'TT-CAP-01',
          'size': null,
          'colour': null,
        },
      ]);
    });

    test('variants (V2-2): ids kept, the first is the primary', () async {
      final (repository, adapter) = _repository([json(200, _product())]);

      await repository.updateProduct(
        'p1',
        const ProductDraft(
          name: 'Hemp Cap',
          brandId: 'b1',
          category: ProductCategory.accessories,
          styleCode: 'CAP',
          variants: [
            VariantDraft(
              id: 'v1',
              gtin: '8901234500057',
              sku: 'CAP-S',
              size: 'S',
            ),
            VariantDraft(gtin: '8901234500064', sku: 'CAP-M', size: 'M'),
          ],
        ),
      );

      final body = adapter.requests.single.data as Map<String, Object?>;
      expect(body['gtin'], '8901234500057');
      expect(body['sku'], 'CAP-S');
      expect(body['category'], 'ACCESSORIES');
      expect(body['styleCode'], 'CAP');
      expect(body['variants'], [
        {
          'id': 'v1',
          'gtin': '8901234500057',
          'sku': 'CAP-S',
          'size': 'S',
          'colour': null,
        },
        {'gtin': '8901234500064', 'sku': 'CAP-M', 'size': 'M', 'colour': null},
      ]);
    });

    test('other shop codes: POST and DELETE on the variant', () async {
      final (repository, adapter) = _repository([json(201, {}), json(200, {})]);
      const alias = SkuAlias(source: 'Myntra', code: 'MY-123');

      await repository.addAlias('p1', 'v1', alias);
      await repository.removeAlias('p1', 'v1', alias);

      expect(
        [for (final r in adapter.requests) (r.method, r.path)],
        [
          ('POST', '/products/p1/variants/v1/aliases'),
          ('DELETE', '/products/p1/variants/v1/aliases'),
        ],
      );
      for (final request in adapter.requests) {
        expect(request.data, {'source': 'Myntra', 'code': 'MY-123'});
      }
    });

    test('a read brings each variant and its other shop codes', () async {
      final (repository, _) = _repository([
        json(200, {
          ..._product(),
          'variants': [
            {
              'id': 'v1',
              'gtin': '08901234500019',
              'sku': 'TT-TEE-01',
              'aliases': [
                {'source': 'Myntra', 'code': 'MY-1'},
              ],
            },
            {'id': 'v2', 'gtin': '08901234500057', 'sku': 'TT-TEE-02'},
          ],
        }),
      ]);

      final result = await repository.fetchProduct('p1');

      final editable = (result as Ok<EditableProduct>).value;
      expect(editable.product.variants, hasLength(2));
      expect(editable.aliases, {
        'v1': [const SkuAlias(source: 'Myntra', code: 'MY-1')],
        'v2': <SkuAlias>[],
      });
    });

    test('verified figures carry their certifier', () async {
      final (repository, adapter) = _repository([json(201, _product())]);

      await repository.createProduct(
        const ProductDraft(
          name: 'Hemp Cap',
          brandId: 'b1',
          variants: [VariantDraft(gtin: '8901234500057', sku: 'TT-CAP-01')],
          figures: FiguresDraft(
            carbonScoreGrams: 900,
            recyclabilityPercent: 70,
            isVerified: true,
            certifierName: 'OEKO-TEX',
          ),
        ),
      );

      final body = adapter.requests.single.data as Map<String, Object?>;
      expect((body['sustainabilityInfo']! as Map)['certifierName'], 'OEKO-TEX');
    });

    test('the stored photo address is kept apart from the shown one', () async {
      final (repository, _) = _repository([
        json(200, {
          ..._product(),
          'imageUrl': 'http://localhost:3000/catalog-images/tee.svg',
        }),
      ]);

      final result = await repository.fetchProduct('p1');

      final editable = (result as Ok<EditableProduct>).value;
      expect(
        editable.storedImageUrl,
        'http://localhost:3000/catalog-images/tee.svg',
      );
      expect(editable.product.imageUrl, endsWith('/catalog-images/tee.svg'));
    });

    test(
      'delete: DELETE, and a refusal with tags held is a conflict',
      () async {
        final (repository, adapter) = _repository([
          json(409, {
            'message':
                "1 user card(s) reference this product, so it can't be deleted",
            'statusCode': 409,
          }),
        ]);

        final result = await repository.deleteProduct('p1');

        expect(adapter.requests.single.method, 'DELETE');
        expect((result as Err<void>).failure, isA<ConflictFailure>());
      },
    );
  });
}
