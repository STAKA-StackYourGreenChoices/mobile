import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_share_repository_impl.dart';

import '../../helpers/fake_http_adapter.dart';

const _link = {'slug': 'w4rdr0be', 'createdAt': '2026-11-15T10:00:00.000Z'};

ProviderContainer _container(FakeHttpAdapter adapter) {
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ),
      webDioProvider.overrideWithValue(
        Dio()..httpClientAdapter = FakeHttpAdapter([]),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('reads the wardrobe link; null or nothing means not shared', () async {
    final adapter = FakeHttpAdapter([
      json(200, _link),
      json(200, null),
      json(200, ''),
    ]);
    final repository = _container(adapter)
        .read(wardrobeShareRepositoryProvider);

    final shared = await repository.fetchShare();
    final notShared = await repository.fetchShare();
    final empty = await repository.fetchShare();

    expect(
      (shared as Ok<ShareLink?>).value,
      ShareLink(slug: 'w4rdr0be', createdAt: DateTime.utc(2026, 11, 15, 10)),
    );
    expect((notShared as Ok<ShareLink?>).value, isNull);
    expect((empty as Ok<ShareLink?>).value, isNull);
    expect(adapter.requests.map((r) => '${r.method} ${r.uri.path}'), [
      'GET /me/wardrobe-share',
      'GET /me/wardrobe-share',
      'GET /me/wardrobe-share',
    ]);
  });

  test('creates and stops the link', () async {
    final adapter = FakeHttpAdapter([json(201, _link), json(204, null)]);
    final repository = _container(adapter)
        .read(wardrobeShareRepositoryProvider);

    final created = await repository.share();
    final stopped = await repository.stopSharing();

    expect((created as Ok<ShareLink>).value.slug, 'w4rdr0be');
    expect(stopped, isA<Ok<void>>());
    expect(adapter.requests.map((r) => '${r.method} ${r.uri.path}'), [
      'POST /me/wardrobe-share',
      'DELETE /me/wardrobe-share',
    ]);
  });

  test('a refused link keeps the API reason', () async {
    final adapter = FakeHttpAdapter([
      json(403, {
        'statusCode': 403,
        'message': 'Verify a piece before sharing your wardrobe.',
      }),
    ]);
    final repository = _container(adapter)
        .read(wardrobeShareRepositoryProvider);

    final result = await repository.share();

    final failure = (result as Err).failure;
    expect(failure, isA<ForbiddenFailure>());
    expect(
      (failure as ForbiddenFailure).message,
      'Verify a piece before sharing your wardrobe.',
    );
  });

  test('hiding a piece patches its card and reads the answer', () async {
    final adapter = FakeHttpAdapter([
      json(200, {
        'id': 'c1',
        'createdAt': '2026-11-09T12:00:00.000Z',
        'user': {'id': 'u1', 'name': 'Ada Lovelace'},
        'product': {
          'id': 'p1',
          'gtin': '08901234500019',
          'sku': 'TT-TEE-01',
          'name': 'Organic Cotton Tee',
          'brand': {'id': 'b1', 'name': 'Terra Threads'},
          'createdAt': '2026-11-01T00:00:00.000Z',
          'updatedAt': '2026-11-01T00:00:00.000Z',
        },
        'ownership': {
          'status': 'VERIFIED',
          'receiptAttemptsUsed': 0,
          'receiptAttemptsLeft': 5,
        },
        'showInWardrobe': false,
      }),
    ]);
    final repository = _container(adapter).read(tagRepositoryProvider);

    final result = await repository.setShowInWardrobe('c1', show: false);

    expect((result as Ok<DigitalCard>).value.showInWardrobe, isFalse);
    final request = adapter.requests.single;
    expect(request.method, 'PATCH');
    expect(request.uri.path, '/digital-cards/c1');
    expect(request.data, {'showInWardrobe': false});
  });
}
