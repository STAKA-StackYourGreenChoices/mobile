import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/core/notifications/notifications_repository.dart';

import '../../helpers/fake_http_adapter.dart';

NotificationsRepository _repository(FakeHttpAdapter adapter) {
  final container = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = adapter,
      ),
    ],
  );
  addTearDown(container.dispose);
  return container.read(notificationsRepositoryProvider);
}

void main() {
  test('reads a page with its target, unread count and total', () async {
    final adapter = FakeHttpAdapter([
      json(200, {
        'items': [
          {
            'id': 'n1',
            'type': 'CLAIM_APPROVED',
            'title': 'Your receipt was approved',
            'body': 'Organic Cotton Tee is now verified as yours.',
            'data': {'target': 'tag', 'id': 'c1'},
            'readAt': null,
            'createdAt': '2026-11-22T10:00:00.000Z',
          },
          {
            'id': 'n2',
            'type': 'BRAND_CLAIM_NEW',
            'title': 'A receipt to check',
            'body': '',
            'data': {'target': 'brandClaim', 'id': 'cl9', 'brandId': 'b1'},
            'readAt': '2026-11-23T08:00:00.000Z',
            'createdAt': '2026-11-21T10:00:00.000Z',
          },
          {
            'id': 'n3',
            'type': 'SOMETHING_NEW',
            'createdAt': '2026-11-20T10:00:00.000Z',
          },
        ],
        'total': 41,
        'unreadCount': 5,
      }),
    ]);

    final page =
        (await _repository(adapter).fetchPage(2) as Ok<NotificationPage>).value;

    final request = adapter.requests.single;
    expect(request.uri.path, '/me/notifications');
    expect(request.uri.queryParameters, {'page': '2', 'limit': '20'});
    expect(page.total, 41);
    expect(page.unreadCount, 5);
    final [first, second, third] = page.items;
    expect(first.target, NotificationTarget.tag);
    expect(first.targetId, 'c1');
    expect(first.isRead, isFalse);
    expect(second.target, NotificationTarget.brandClaim);
    expect(second.brandId, 'b1');
    expect(second.isRead, isTrue);
    expect(third.target, NotificationTarget.none);
    expect(third.title, '');
  });

  test('marks one or all as read', () async {
    final adapter = FakeHttpAdapter([json(201, null), json(201, null)]);
    final repository = _repository(adapter);

    expect(await repository.markRead('n 1'), isA<Ok<void>>());
    expect(await repository.markAllRead(), isA<Ok<void>>());

    expect(adapter.requests.map((r) => '${r.method} ${r.uri.path}'), [
      'POST /me/notifications/n%201/read',
      'POST /me/notifications/read-all',
    ]);
  });

  test('reads and saves the settings, sending only what changed', () async {
    final adapter = FakeHttpAdapter([
      json(200, {'push': true, 'email': false}),
      json(200, {'push': false, 'email': false}),
    ]);
    final repository = _repository(adapter);

    final settings =
        (await repository.fetchSettings() as Ok<NotificationSettings>).value;
    final saved = (await repository.updateSettings(
      push: false,
    ) as Ok<NotificationSettings>).value;

    expect(settings.push, isTrue);
    expect(settings.email, isFalse);
    expect(saved.push, isFalse);
    final [get, patch] = adapter.requests;
    expect(get.uri.path, '/me/notification-settings');
    expect(patch.method, 'PATCH');
    expect(patch.data, {'push': false});
  });
}
