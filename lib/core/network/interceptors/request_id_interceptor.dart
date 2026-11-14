import 'dart:math';

import 'package:dio/dio.dart';

/// Gives every request a correlation id for support triage (guide §10.3).
/// A retried request keeps its original id.
class RequestIdInterceptor extends Interceptor {
  new({Random? random}) : _random = random ?? Random.secure();

  static const header = 'X-Request-Id';

  final Random _random;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent(header, _newId);
    handler.next(options);
  }

  String _newId() =>
      [for (var i = 0; i < 16; i++) _random.nextInt(256).toRadixString(16)]
          .map((byte) => byte.padLeft(2, '0'))
          .join();
}
