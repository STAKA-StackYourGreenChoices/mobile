import 'dart:math';

import 'package:dio/dio.dart';

typedef Wait = Future<void> Function(Duration delay);

/// Retries idempotent GETs on network errors and 502/503/504, with
/// exponential backoff and jitter, three attempts in total (guide §10.3).
/// Writes (POST, PATCH, DELETE) are never retried.
class RetryInterceptor extends Interceptor {
  new(
    this._dio, {
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 400),
    Wait? wait,
    Random? random,
  }) : _wait = wait ?? Future<void>.delayed,
       _random = random ?? Random();

  static const _attemptKey = 'retry.attempt';
  static const _retryableStatuses = {502, 503, 504};

  final Dio _dio;
  final int maxAttempts;
  final Duration baseDelay;
  final Wait _wait;
  final Random _random;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 1;
    if (attempt >= maxAttempts || !_isRetryable(err)) {
      return handler.next(err);
    }

    await _wait(_delayBefore(attempt + 1));
    options.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      // The retried request already ran through this interceptor itself.
      handler.next(retryError);
    }
  }

  bool _isRetryable(DioException err) {
    if (err.requestOptions.method.toUpperCase() != 'GET') return false;
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => _retryableStatuses.contains(
        err.response?.statusCode,
      ),
      _ => false,
    };
  }

  /// 400 ms, 800 ms, ... plus up to the same again at random.
  Duration _delayBefore(int attempt) {
    final backoff = baseDelay * pow(2, attempt - 2).toInt();
    final jitter = backoff * _random.nextDouble();
    return backoff + jitter;
  }
}
