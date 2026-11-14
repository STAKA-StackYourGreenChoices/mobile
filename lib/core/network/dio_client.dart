import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/config/env.dart';
import 'package:staka/core/network/interceptors/log_interceptor.dart';
import 'package:staka/core/network/interceptors/request_id_interceptor.dart';
import 'package:staka/core/network/interceptors/retry_interceptor.dart';

part 'dio_client.g.dart';

/// The single HTTP client for the STAKA API. The auth interceptor is added
/// by the session slice.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = buildDio(baseUrl: Env.apiBaseUrl);
  ref.onDispose(dio.close);
  return dio;
}

/// Plain factory so tests can build the same client against a fake adapter.
Dio buildDio({required String baseUrl}) {
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
    AppLogInterceptor(),
    RetryInterceptor(dio),
  ]);
  return dio;
}
