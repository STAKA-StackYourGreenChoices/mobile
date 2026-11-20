import 'package:dio/dio.dart';

import 'package:staka/core/logging/app_logger.dart';
import 'package:staka/core/network/interceptors/request_id_interceptor.dart';

/// Logs method, redacted path, status and timing. Never headers or bodies,
/// so tokens, emails and receipts can't leak into logs (guide §15).
class AppLogInterceptor extends Interceptor {
  static const _startedAt = 'log.startedAt';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAt] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _log(response.requestOptions, '${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(err.requestOptions, '${err.response?.statusCode ?? err.type.name}');
    handler.next(err);
  }

  void _log(RequestOptions options, String outcome) {
    final started = options.extra[_startedAt];
    final ms = started is DateTime
        ? DateTime.now().difference(started).inMilliseconds
        : null;
    final id = options.headers[RequestIdInterceptor.header];
    AppLogger.debug(
      '${options.method} ${redactPath(options.uri.path)} → $outcome'
      '${ms == null ? '' : ' (${ms}ms)'} [$id]',
      name: 'http',
    );
  }
}

/// Replaces any path segment containing a digit (UUIDs, GTINs, share slugs)
/// with `:param`, so identifiers never reach the log.
String redactPath(String path) => path
    .split('/')
    .map((segment) => segment.contains(RegExp('[0-9]')) ? ':param' : segment)
    .join('/');
