import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/token_refresher.dart';
import 'package:staka/core/auth/token_store.dart';
import 'package:staka/core/config/env.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/core/network/interceptors/log_interceptor.dart';
import 'package:staka/core/network/interceptors/request_id_interceptor.dart';
import 'package:staka/core/network/interceptors/retry_interceptor.dart';

part 'dio_client.g.dart';

/// The single HTTP client for the STAKA API, with the session attached.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final store = ref.watch(tokenStoreProvider);
  final refresher = ref.watch(tokenRefresherProvider);
  final dio = buildDio(
    baseUrl: Env.apiBaseUrl,
    auth: (dio) =>
        AuthInterceptor(dio: dio, store: store, refresher: refresher),
  );
  ref.onDispose(dio.close);
  return dio;
}

/// Refreshes over its own client: no auth interceptor, so a failed refresh
/// can never trigger another refresh. A rejected refresh token signs out.
@Riverpod(keepAlive: true)
TokenRefresher tokenRefresher(Ref ref) {
  final dio = buildDio(baseUrl: Env.apiBaseUrl);
  ref.onDispose(dio.close);
  return TokenRefresher(
    dio: dio,
    store: ref.watch(tokenStoreProvider),
    // Read lazily: the session itself depends on this client.
    onRejected: () =>
        ref.read(sessionControllerProvider.notifier).onSessionExpired(),
  );
}

/// Plain factory so tests can build the same client against a fake adapter.
/// Order matters: the auth header is set before logging, and retries pass
/// back through auth so they carry the current token.
Dio buildDio({required String baseUrl, Interceptor Function(Dio dio)? auth}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {Headers.acceptHeader: Headers.jsonContentType},
    ),
  );
  dio.interceptors.addAll([
    RequestIdInterceptor(),
    ?auth?.call(dio),
    AppLogInterceptor(),
    RetryInterceptor(dio),
  ]);
  return dio;
}
