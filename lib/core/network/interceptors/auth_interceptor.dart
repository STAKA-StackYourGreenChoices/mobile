import 'package:dio/dio.dart';

import 'package:staka/core/auth/jwt_claims.dart';
import 'package:staka/core/auth/token_refresher.dart';
import 'package:staka/core/auth/token_store.dart';

/// Options for endpoints that need no session (login, register, logout,
/// password reset, public tags). They get no token and never trigger a
/// refresh, so a wrong password stays a plain 401. A fresh object each call,
/// because interceptors write per-request state into `extra`.
Options publicRequest() => Options(extra: {AuthInterceptor.publicKey: true});

/// Adds `Authorization: Bearer` to every non-public request, refreshing
/// first when the token is about to expire, and retries once after a 401.
class AuthInterceptor extends Interceptor {
  new({
    required this._dio,
    required this._store,
    required this._refresher,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  static const publicKey = 'auth.public';
  static const _retriedKey = 'auth.retried';

  final Dio _dio;
  final TokenStore _store;
  final TokenRefresher _refresher;
  final DateTime Function() _now;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[publicKey] == true) return handler.next(options);

    var token = (await _store.read())?.accessToken;
    if (token != null && isExpiringSoon(token, now: _now().toUtc())) {
      token = await _refresher.refresh() ?? token;
    }
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final sentToken = _bearer(options);
    if (err.response?.statusCode != 401 ||
        options.extra[publicKey] == true ||
        options.extra[_retriedKey] == true ||
        sentToken == null) {
      return handler.next(err);
    }

    // Another request may already have refreshed while this one was in
    // flight; then just retry with the newer token instead of rotating again.
    final stored = (await _store.read())?.accessToken;
    final token = stored != null && stored != sentToken
        ? stored
        : await _refresher.refresh();
    if (token == null) return handler.next(err);

    options
      ..extra[_retriedKey] = true
      ..headers['Authorization'] = 'Bearer $token';
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  String? _bearer(RequestOptions options) {
    final header = options.headers['Authorization'];
    return header is String && header.startsWith('Bearer ')
        ? header.substring(7)
        : null;
  }
}
