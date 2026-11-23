import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/features/manage/claims/data/datasources/admin_claim_remote_data_source.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/import/data/datasources/import_remote_data_source.dart';
import 'package:staka/features/manage/import/data/repositories/import_repository_impl.dart';
import 'package:staka/features/manage/products/data/datasources/admin_product_remote_data_source.dart';
import 'package:staka/features/manage/products/data/datasources/product_editor_remote_data_source.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/import_fakes.dart';

const _brand = BrandScope('b1');

/// Every call fails: only the paths it asked for matter here.
(Dio, FakeHttpAdapter) _api(int calls) {
  final adapter = FakeHttpAdapter([
    for (var i = 0; i < calls; i++) json(500, {'message': 'not checked'}),
  ]);
  return (
    Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = adapter,
    adapter,
  );
}

List<(String, String)> _calls(FakeHttpAdapter adapter) => [
  for (final request in adapter.requests) (request.method, request.path),
];

void main() {
  test('admin paths stay at the root; a brand prefixes its own', () {
    expect(const AdminScope().path('/claims/c1'), '/claims/c1');
    expect(_brand.path('/claims/c1'), '/brand/b1/claims/c1');
  });

  test('scopes are equal by brand, so providers keyed by them match', () {
    expect(const BrandScope('b1'), const BrandScope('b1'));
    expect(const BrandScope('b1'), isNot(const BrandScope('b2')));
    expect(const AdminScope(), isNot(const BrandScope('b1')));
  });

  test("a brand's catalog calls are under /brand/:brandId", () async {
    final (dio, adapter) = _api(5);
    final repository = AdminProductRepositoryImpl(
      AdminProductRemoteDataSource(dio, _brand),
      BrandsApi(dio),
      ProductEditorRemoteDataSource(dio, _brand),
    );

    await repository.fetchProducts(const ProductFilter(), 1);
    await repository.fetchProduct('p1');
    await repository.deleteProduct('p1');

    expect(_calls(adapter), [
      ('GET', '/brand/b1/products'),
      ('GET', '/brand/b1/products/p1'),
      ('DELETE', '/brand/b1/products/p1'),
    ]);
  });

  test("a brand's claim calls are under /brand/:brandId", () async {
    final (dio, adapter) = _api(5);
    final repository = AdminClaimRepositoryImpl(
      AdminClaimRemoteDataSource(dio, _brand),
    );

    await repository.fetchClaims(ClaimStatus.pending, 1);
    await repository.fetchClaim('c1');
    await repository.fetchReceipt('c1');
    await repository.approve('c1');
    await repository.reject('c1', 'Not our product');

    expect(_calls(adapter), [
      ('GET', '/brand/b1/claims'),
      ('GET', '/brand/b1/claims/c1'),
      ('GET', '/brand/b1/claims/c1/receipt'),
      ('POST', '/brand/b1/claims/c1/approve'),
      ('POST', '/brand/b1/claims/c1/reject'),
    ]);
  });

  test("a brand's import calls are under /brand/:brandId", () async {
    final (dio, adapter) = _api(2);
    final repository = ImportRepositoryImpl(
      ImportRemoteDataSource(dio, _brand),
    );

    await repository.check(csvFile('catalog.csv'));
    await repository.fetchTemplate();

    expect(_calls(adapter), [
      ('POST', '/brand/b1/products/import'),
      ('GET', '/brand/b1/products/import/template'),
    ]);
  });
}
