import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/domain/models/card_stats.dart';
import 'package:staka/features/wardrobe/data/repositories/impact_repository_impl.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';

import '../../helpers/fake_http_adapter.dart';

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
  test('reads the impact summary; a missing figure is 0', () async {
    final adapter = FakeHttpAdapter([
      json(200, {
        'pieces': 4,
        'verifiedPieces': 3,
        'sharedPieces': 2,
        'totalViews': 128,
        'carbonGramsOwned': 8400,
      }),
    ]);
    final repository = _container(adapter).read(impactRepositoryProvider);

    final impact = (await repository.fetchImpact() as Ok<Impact>).value;

    expect(adapter.requests.single.uri.path, '/me/impact');
    expect(impact.pieces, 4);
    expect(impact.totalViews, 128);
    expect(impact.carbonGramsOwned, 8400);
    expect(impact.points, 0);
  });

  test('reads an activity page with its card, points and channel', () async {
    final adapter = FakeHttpAdapter([
      json(200, {
        'items': [
          {
            'type': 'OWNERSHIP_VERIFIED',
            'at': '2026-11-20T10:00:00.000Z',
            'card': {
              'id': 'c1',
              'product': {'name': 'Organic Cotton Tee'},
            },
            'points': 50,
          },
          {
            'type': 'TAG_VIEWED',
            'at': '2026-11-21T10:00:00.000Z',
            'card': {'id': 'c1'},
            'channel': 'whatsapp',
          },
          {
            'type': 'SOMETHING_NEW',
            'at': '2026-11-22T10:00:00.000Z',
            'channel': 'tiktok',
          },
        ],
        'total': 41,
      }),
    ]);
    final repository = _container(adapter).read(impactRepositoryProvider);

    final page = (await repository.fetchActivity(2) as Ok<ActivityPage>).value;

    final request = adapter.requests.single;
    expect(request.uri.path, '/me/activity');
    expect(request.uri.queryParameters, {'page': '2', 'limit': '20'});
    expect(page.total, 41);
    expect(page.items.map((i) => i.type), [
      ActivityType.ownershipVerified,
      ActivityType.tagViewed,
      ActivityType.other,
    ]);
    expect(page.items[0].productName, 'Organic Cotton Tee');
    expect(page.items[0].points, 50);
    expect(page.items[1].cardId, 'c1');
    expect(page.items[1].productName, isNull);
    expect(page.items[1].channel, ShareChannel.whatsapp);
    expect(page.items[2].channel, ShareChannel.other);
    expect(page.items[2].at, DateTime.utc(2026, 11, 22, 10));
  });

  test("reads a tag's stats; unknown channels count as other", () async {
    final adapter = FakeHttpAdapter([
      json(200, {
        'views': 30,
        'viewsByChannel': {'whatsapp': 12, 'qr': 3, 'tiktok': 4, 'other': 1},
        'clicks': 5,
      }),
    ]);
    final repository = _container(adapter).read(tagRepositoryProvider);

    final stats = (await repository.fetchStats('c1') as Ok<CardStats>).value;

    expect(adapter.requests.single.uri.path, '/me/cards/c1/stats');
    expect(stats.views, 30);
    expect(stats.clicks, 5);
    expect(stats.channelsByViews, [
      (ShareChannel.whatsapp, 12),
      (ShareChannel.other, 5),
      (ShareChannel.qr, 3),
    ]);
  });
}
