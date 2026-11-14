import 'dart:math';

import 'package:dio/dio.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/auth/token_refresher.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';

import '../helpers/auth_fakes.dart';

/// The API address for live tests; empty means "skip".
const liveApiUrl = String.fromEnvironment('LIVE_API_URL');
final String? liveSkip = liveApiUrl.isEmpty ? 'Set LIVE_API_URL to run' : null;

/// The app's real network stack (auth interceptor, single-flight refresh,
/// repositories) pointed at a running API, with in-memory token storage.
class LiveClient {
  new() {
    refresher = TokenRefresher(
      dio: buildDio(baseUrl: liveApiUrl),
      store: store,
      onRejected: () => rejections++,
    );
    final dio = buildDio(
      baseUrl: liveApiUrl,
      auth: (dio) =>
          AuthInterceptor(dio: dio, store: store, refresher: refresher),
    );
    auth = AuthRepositoryImpl(AuthRemoteDataSource(dio));
    session = SessionRepository(dio, store);
  }

  final store = InMemoryTokenStore();
  late final TokenRefresher refresher;
  late final AuthRepositoryImpl auth;
  late final SessionRepository session;
  int rejections = 0;

  /// What the API answers when [refreshToken] is presented again.
  Future<int?> refreshStatus(String refreshToken) =>
      buildDio(baseUrl: liveApiUrl)
          .post<Object?>(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: publicRequest(),
          )
          .then(
            (response) => response.statusCode,
            onError: (Object e) => (e as DioException).response?.statusCode,
          );
}

/// A fresh address per run: `mobile-live-<ms>@example.com`.
String throwawayEmail() =>
    'mobile-live-${DateTime.now().microsecondsSinceEpoch}@example.com';

String randomPassword() {
  final random = Random.secure();
  return List.generate(
    20,
    (_) => 'abcdefghijkmnpqrstuvwxyz23456789'[random.nextInt(32)],
  ).join();
}
