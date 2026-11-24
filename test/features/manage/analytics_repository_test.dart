import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/manage/analytics/data/analytics_repository.dart';
import 'package:staka/features/manage/analytics/domain/analytics_report.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/fake_http_adapter.dart';

AnalyticsRepository _repository(FakeHttpAdapter adapter, ManageScope scope) {
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ),
    ],
  );
  addTearDown(container.dispose);
  return container.read(analyticsRepositoryProvider(scope));
}

final _from = DateTime(2026, 10, 27);
final _to = DateTime(2026, 11, 25);

void main() {
  test('admin: reads funnel, channels and top products for a brand', () async {
    final adapter = FakeHttpAdapter([
      json(200, {'scans': 100, 'added': 50, 'verified': 20, 'shared': 10}),
      json(200, {
        'shares': {'whatsapp': 6, 'qr': 4, 'telegram': 1},
        'views': {'whatsapp': 9, 'pinterest': 2, 'tiktok': 3},
      }),
      json(200, {
        'items': [
          {
            'product': {
              'id': 'p1',
              'name': 'Organic Cotton Tee',
              'brand': {'name': 'Terra Threads'},
            },
            'scans': 40,
            'verified': 12,
            'shared': 5,
          },
          {'name': 'no id, skipped'},
        ],
      }),
    ]);

    final report = (await _repository(adapter, const AdminScope()).fetchReport(
      from: _from,
      to: _to,
      brandId: 'b1',
    ) as Ok<AnalyticsReport>).value;

    expect(adapter.requests.map((r) => r.uri.path), [
      '/admin/analytics/funnel',
      '/admin/analytics/channels',
      '/admin/analytics/top-products',
    ]);
    expect(adapter.requests.first.uri.queryParameters, {
      'from': '2026-10-27',
      'to': '2026-11-25',
      'brandId': 'b1',
    });
    expect(adapter.requests.last.uri.queryParameters['limit'], '5');
    expect(report.count(FunnelStep.scans), 100);
    expect(report.count(FunnelStep.viewed), 0);
    expect(report.sharesByChannel, {
      ShareChannel.whatsapp: 6,
      ShareChannel.qr: 4,
      ShareChannel.other: 1,
    });
    expect(report.viewsByChannel[ShareChannel.other], 5);
    final top = report.topProducts.single;
    expect(top.name, 'Organic Cotton Tee');
    expect(top.brandName, 'Terra Threads');
    expect(top.scans, 40);
  });

  test('brand: its own paths; top products may be a plain list', () async {
    final adapter = FakeHttpAdapter([
      json(200, <String, Object?>{}),
      json(200, <String, Object?>{}),
      json(200, [
        {'id': 'p2', 'name': 'Hemp Overshirt', 'scans': 3},
      ]),
    ]);

    final report = (await _repository(
      adapter,
      const BrandScope('b 1'),
    ).fetchReport(from: _from, to: _to) as Ok<AnalyticsReport>).value;

    expect(adapter.requests.first.uri.path, '/brand/b%201/analytics/funnel');
    expect(
      adapter.requests.first.uri.queryParameters.containsKey('brandId'),
      isFalse,
    );
    expect(report.topProducts.single.name, 'Hemp Overshirt');
    expect(report.sharesByChannel, isEmpty);
  });
}
