import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/cards/cards_api.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/products/data/datasources/product_remote_data_source.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';

import '../../helpers/fake_http_adapter.dart';

/// Answers each request by its path, whatever order they arrive in.
FakeReply _byPath(Map<String, FakeReply> routes) =>
    (options) => routes[options.path]!(options);

Map<String, Object?> _product({String id = 'p1'}) => {
  'id': id,
  'gtin': '08901234500019',
  'sku': 'TT-TEE-01',
  'name': 'Organic Cotton Tee',
  'brand': {'id': 'b1', 'name': 'Terra Threads'},
  'createdAt': '2026-11-01T00:00:00.000Z',
  'updatedAt': '2026-11-01T00:00:00.000Z',
};

Map<String, Object?> _card({required String productId}) => {
  'id': 'c1',
  'createdAt': '2026-11-09T12:00:00.000Z',
  'user': {'id': 'u1', 'name': 'Ada Lovelace'},
  'product': _product(id: productId),
  'ownership': {
    'status': 'UNVERIFIED',
    'receiptAttemptsUsed': 0,
    'receiptAttemptsLeft': 5,
  },
};

const _gtinPath = '/products/gtin/08901234500019';

Future<Result<ProductLookup>> _lookUp(Map<String, FakeReply> routes) {
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = FakeHttpAdapter([_byPath(routes), _byPath(routes)]);
  return ProductRepositoryImpl(
    ProductRemoteDataSource(dio),
    CardsApi(dio),
  ).lookUp('08901234500019');
}

void main() {
  test('found, and owned when one of my tags is for this product', () async {
    final result = await _lookUp({
      _gtinPath: json(200, _product()),
      '/digital-cards/mine': json(200, [_card(productId: 'p1')]),
    });

    final found = (result as Ok<ProductLookup>).value as ProductFound;
    expect(found.product.name, 'Organic Cotton Tee');
    expect(found.ownedCardId, 'c1');
  });

  test('found, not owned when my tags are for other products', () async {
    final result = await _lookUp({
      _gtinPath: json(200, _product()),
      '/digital-cards/mine': json(200, [_card(productId: 'other')]),
    });

    final found = (result as Ok<ProductLookup>).value as ProductFound;
    expect(found.ownedCardId, isNull);
  });

  test("400 is a misread barcode, with the API's reason", () async {
    final result = await _lookUp({
      _gtinPath: json(400, {'message': 'Invalid GTIN check digit'}),
      '/digital-cards/mine': json(200, []),
    });

    final invalid = (result as Ok<ProductLookup>).value as InvalidBarcode;
    expect(invalid.message, 'Invalid GTIN check digit');
  });

  test('404 is a product not on STAKA yet', () async {
    final result = await _lookUp({
      _gtinPath: json(404, {'message': 'not found'}),
      '/digital-cards/mine': json(200, []),
    });

    expect((result as Ok<ProductLookup>).value, isA<UnknownProduct>());
  });

  test('anything else is a failure the screen can retry', () async {
    final result = await _lookUp({
      _gtinPath: json(200, _product()),
      '/digital-cards/mine': connectionError(),
    });

    expect((result as Err<ProductLookup>).failure, isA<NetworkFailure>());
  });
}
