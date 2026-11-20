import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/token_refresher.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

void main() {
  late InMemoryTokenStore store;
  late int rejections;

  TokenRefresher refresherWith(FakeHttpAdapter adapter) => TokenRefresher(
    dio: Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = adapter,
    store: store,
    onRejected: () => rejections++,
  );

  setUp(() {
    store = InMemoryTokenStore(
      const AuthTokens(accessToken: 'old', refreshToken: 'r1'),
    );
    rejections = 0;
  });

  test('saves the rotated pair and returns the new access token', () async {
    final adapter = FakeHttpAdapter([json(200, authJson(access: 'new'))]);

    expect(await refresherWith(adapter).refresh(), 'new');
    expect(
      store.tokens,
      const AuthTokens(accessToken: 'new', refreshToken: 'r2'),
    );
    expect(adapter.requests.single.data, {'refreshToken': 'r1'});
  });

  test(
    'concurrent callers share one refresh (tokens are single-use)',
    () async {
      final reply = Completer<void>();
      final adapter = FakeHttpAdapter([
        (options) async {
          await reply.future;
          return await json(200, authJson(access: 'new'))(options);
        },
      ]);
      final refresher = refresherWith(adapter);

      final first = refresher.refresh();
      final second = refresher.refresh();
      reply.complete();

      expect(await Future.wait([first, second]), ['new', 'new']);
      expect(adapter.requests, hasLength(1));
    },
  );

  test('a rejected refresh token clears tokens and signs out', () async {
    final adapter = FakeHttpAdapter([
      json(401, {'message': 'Invalid refresh token'}),
    ]);

    expect(await refresherWith(adapter).refresh(), isNull);
    expect(store.tokens, isNull);
    expect(rejections, 1);
  });

  test('a network error keeps the session for a later retry', () async {
    final adapter = FakeHttpAdapter([connectionError()]);

    expect(await refresherWith(adapter).refresh(), isNull);
    expect(store.tokens, isNotNull);
    expect(rejections, 0);
  });

  test('does nothing when signed out', () async {
    store.tokens = null;
    final adapter = FakeHttpAdapter([]);

    expect(await refresherWith(adapter).refresh(), isNull);
    expect(adapter.requests, isEmpty);
  });
}
