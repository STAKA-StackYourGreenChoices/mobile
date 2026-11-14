import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/token_refresher.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

void main() {
  final now = DateTime.utc(2026, 11, 14, 12);
  final validToken = fakeJwt(exp: now.add(const Duration(minutes: 10)));
  final freshToken = fakeJwt(
    exp: now.add(const Duration(minutes: 15)),
    marker: 'fresh',
  );
  late InMemoryTokenStore store;
  late FakeHttpAdapter refreshAdapter;
  late int rejections;

  Dio clientWith(FakeHttpAdapter api) {
    final refresher = TokenRefresher(
      dio: Dio(BaseOptions(baseUrl: 'http://api.test'))
        ..httpClientAdapter = refreshAdapter,
      store: store,
      onRejected: () => rejections++,
    );
    return buildDio(
      baseUrl: 'http://api.test',
      auth: (dio) => AuthInterceptor(
        dio: dio,
        store: store,
        refresher: refresher,
        now: () => now,
      ),
    )..httpClientAdapter = api;
  }

  String? bearerOf(RequestOptions r) => r.headers['Authorization'] as String?;

  setUp(() {
    store = InMemoryTokenStore(
      AuthTokens(accessToken: validToken, refreshToken: 'r1'),
    );
    refreshAdapter = FakeHttpAdapter([]);
    rejections = 0;
  });

  test('adds the bearer token, but not on public requests', () async {
    final api = FakeHttpAdapter([json(200, {}), json(200, {})]);
    final dio = clientWith(api);

    await dio.get<Object?>('/auth/me');
    await dio.post<Object?>('/auth/login', options: publicRequest());

    expect(bearerOf(api.requests[0]), 'Bearer $validToken');
    expect(bearerOf(api.requests[1]), isNull);
  });

  test('refreshes first when the token expires within 30 s', () async {
    store.tokens = AuthTokens(
      accessToken: fakeJwt(exp: now.add(const Duration(seconds: 10))),
      refreshToken: 'r1',
    );
    refreshAdapter = FakeHttpAdapter([json(200, authJson(access: freshToken))]);
    final api = FakeHttpAdapter([json(200, {})]);

    await clientWith(api).get<Object?>('/digital-cards/mine');

    expect(bearerOf(api.requests.single), 'Bearer $freshToken');
  });

  test('an undecodable token is sent as is, not refreshed first', () async {
    store.tokens = const AuthTokens(accessToken: 'opaque', refreshToken: 'r1');
    final api = FakeHttpAdapter([json(200, {})]);

    await clientWith(api).get<Object?>('/auth/me');

    expect(bearerOf(api.requests.single), 'Bearer opaque');
    expect(refreshAdapter.requests, isEmpty);
  });

  test(
    'after a 401 it refreshes once and retries with the new token',
    () async {
      refreshAdapter = FakeHttpAdapter([
        json(200, authJson(access: freshToken)),
      ]);
      final api = FakeHttpAdapter([
        json(401, {'message': 'Unauthorized'}),
        json(200, {'ok': true}),
      ]);

      final response = await clientWith(api).get<Object?>('/auth/me');

      expect(response.data, {'ok': true});
      expect(bearerOf(api.requests.last), 'Bearer $freshToken');
      expect(refreshAdapter.requests, hasLength(1));
    },
  );

  test('two requests failing together trigger a single refresh', () async {
    final gate = Completer<void>();
    refreshAdapter = FakeHttpAdapter([
      (options) async {
        await gate.future;
        return await json(200, authJson(access: freshToken))(options);
      },
    ]);
    final api = FakeHttpAdapter([
      json(401, {}),
      json(401, {}),
      json(200, {}),
      json(200, {}),
    ]);
    final dio = clientWith(api);

    final both = Future.wait([
      dio.get<Object?>('/auth/me'),
      dio.get<Object?>('/digital-cards/mine'),
    ]);
    await pumpEventQueue();
    gate.complete();
    await both;

    expect(refreshAdapter.requests, hasLength(1));
    expect(bearerOf(api.requests[2]), 'Bearer $freshToken');
    expect(bearerOf(api.requests[3]), 'Bearer $freshToken');
  });

  test(
    'when the refresh is rejected, the 401 surfaces and the session ends',
    () async {
      refreshAdapter = FakeHttpAdapter([json(401, {})]);
      final api = FakeHttpAdapter([json(401, {})]);

      await expectLater(
        clientWith(api).get<Object?>('/auth/me'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            401,
          ),
        ),
      );
      expect(rejections, 1);
      expect(store.tokens, isNull);
    },
  );

  test('a 401 on a public request never refreshes (wrong password)', () async {
    final api = FakeHttpAdapter([
      json(401, {'message': 'Invalid credentials'}),
    ]);

    await expectLater(
      clientWith(api).post<Object?>('/auth/login', options: publicRequest()),
      throwsA(isA<DioException>()),
    );
    expect(refreshAdapter.requests, isEmpty);
  });
  test('a wrong-password 401 is returned as is, no refresh spent', () async {
    final api = FakeHttpAdapter([
      json(401, {'message': 'Current password is invalid'}),
    ]);

    await expectLater(
      clientWith(
        api,
      ).post<Object?>('/auth/change-password', options: passwordCheckRequest()),
      throwsA(isA<DioException>()),
    );
    expect(bearerOf(api.requests.single), 'Bearer $validToken');
    expect(refreshAdapter.requests, isEmpty);
  });
}
