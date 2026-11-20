import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/network/interceptors/retry_interceptor.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  late List<Duration> waits;

  Dio dioWith(FakeHttpAdapter adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(
      RetryInterceptor(
        dio,
        wait: (delay) async => waits.add(delay),
        random: Random(1),
      ),
    );
    return dio;
  }

  setUp(() => waits = []);

  test('retries a GET after a network error and returns the success', () async {
    final adapter = FakeHttpAdapter([
      connectionError(),
      json(200, {'ok': 1}),
    ]);

    final response = await dioWith(adapter).get<Object?>('/products');

    expect(response.data, {'ok': 1});
    expect(adapter.requests, hasLength(2));
    expect(waits, hasLength(1));
  });

  test('stops after three attempts in total', () async {
    final adapter = FakeHttpAdapter([
      json(503, {}),
      json(503, {}),
      json(503, {}),
    ]);

    await expectLater(
      dioWith(adapter).get<Object?>('/products'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.requests, hasLength(3));
  });

  test('backs off exponentially, with jitter up to the same again', () async {
    final adapter = FakeHttpAdapter([
      json(503, {}),
      json(503, {}),
      json(503, {}),
    ]);

    await expectLater(
      dioWith(adapter).get<Object?>('/products'),
      throwsA(isA<DioException>()),
    );
    expect(waits[0].inMilliseconds, inInclusiveRange(400, 800));
    expect(waits[1].inMilliseconds, inInclusiveRange(800, 1600));
  });

  test('never retries a POST', () async {
    final adapter = FakeHttpAdapter([connectionError()]);

    await expectLater(
      dioWith(adapter).post<Object?>('/digital-cards'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.requests, hasLength(1));
  });

  test('does not retry a client error such as 404', () async {
    final adapter = FakeHttpAdapter([
      json(404, {'message': 'Not found'}),
    ]);

    await expectLater(
      dioWith(adapter).get<Object?>('/products/gtin/1'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.requests, hasLength(1));
    expect(waits, isEmpty);
  });
}
