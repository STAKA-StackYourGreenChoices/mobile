import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/network/interceptors/log_interceptor.dart';
import 'package:staka/core/network/interceptors/request_id_interceptor.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  group('buildDio + guardApi', () {
    test('a 2xx response becomes Ok with the body', () async {
      final adapter = FakeHttpAdapter([
        json(200, {'id': 'u1'}),
      ]);
      final dio = buildDio(baseUrl: 'http://api.test')
        ..httpClientAdapter = adapter;

      final result = await guardApi(() => dio.get<Object?>('/auth/me'));

      expect(result, isA<Ok<Object?>>());
      expect(adapter.requests.single.uri.toString(), 'http://api.test/auth/me');
    });

    test('an API error becomes Err with the typed failure', () async {
      final adapter = FakeHttpAdapter([
        json(404, {'message': 'No product found for this GTIN'}),
      ]);
      final dio = buildDio(baseUrl: 'http://api.test')
        ..httpClientAdapter = adapter;

      final result = await guardApi(
        () => dio.get<Object?>('/products/gtin/09506000134352'),
      );

      final failure = (result as Err<Object?>).failure;
      expect(failure, isA<NotFoundFailure>());
      expect((failure as ApiFailure).message, 'No product found for this GTIN');
    });

    test('a non-Dio exception becomes UnknownFailure', () async {
      final result = await guardApi<int>(
        () async => throw const FormatException(),
      );

      expect((result as Err<int>).failure, isA<UnknownFailure>());
    });

    test('every request carries a unique correlation id', () async {
      final adapter = FakeHttpAdapter([json(200, {}), json(200, {})]);
      final dio = buildDio(baseUrl: 'http://api.test')
        ..httpClientAdapter = adapter;

      await dio.get<Object?>('/a');
      await dio.get<Object?>('/b');

      final ids = [
        for (final r in adapter.requests)
          r.headers[RequestIdInterceptor.header],
      ];
      expect(ids.every((id) => id is String && id.length == 32), isTrue);
      expect(ids.toSet(), hasLength(2));
    });
  });

  test('redactPath hides identifiers but keeps the route shape', () {
    expect(
      redactPath('/digital-cards/3f2b8c1e-0000-4000-8000-000000000001/share'),
      '/digital-cards/:param/share',
    );
    expect(
      redactPath('/products/gtin/09506000134352'),
      '/products/gtin/:param',
    );
    expect(redactPath('/auth/me'), '/auth/me');
  });
}
