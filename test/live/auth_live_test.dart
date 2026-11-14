@Tags(['live'])
library;

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/auth/token_refresher.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

import '../helpers/auth_fakes.dart';

/// Runs the app's real network, auth and refresh code against a running
/// API. Skipped unless given its address:
///
///   flutter test test/live --dart-define=LIVE_API_URL=http://localhost:7070
///
/// Each run registers a throwaway `mobile-live-*@example.com` account.
const _apiUrl = String.fromEnvironment('LIVE_API_URL');

void main() {
  final skip = _apiUrl.isEmpty ? 'Set LIVE_API_URL to run' : null;

  test('register, sign in, refresh, sign out against the real API', () async {
    final store = InMemoryTokenStore();
    var rejected = 0;
    final refresher = TokenRefresher(
      dio: buildDio(baseUrl: _apiUrl),
      store: store,
      onRejected: () => rejected++,
    );
    final dio = buildDio(
      baseUrl: _apiUrl,
      auth: (dio) =>
          AuthInterceptor(dio: dio, store: store, refresher: refresher),
    );
    final auth = AuthRepositoryImpl(AuthRemoteDataSource(dio));
    final session = SessionRepository(dio, store);
    final random = Random.secure();
    final email =
        'mobile-live-${DateTime.now().millisecondsSinceEpoch}@example.com';
    final password = List.generate(
      20,
      (_) => 'abcdefghijkmnpqrstuvwxyz23456789'[random.nextInt(32)],
    ).join();

    // Register: signed in at once, shopper, email not confirmed yet.
    final registered = await auth.register(
      name: 'Mobile Live Test',
      email: email,
      password: password,
    );
    final newUser = (registered as Ok<AuthSession>).value.user;
    expect(newUser.role, Role.user);
    expect(newUser.emailVerified, isFalse);

    // The same email again is a conflict, which the form shows on the field.
    final again = await auth.register(
      name: 'Mobile Live Test',
      email: email,
      password: password,
    );
    expect((again as Err<AuthSession>).failure, isA<ConflictFailure>());

    // A wrong password is a 401 the form turns into the website's alert.
    final wrong = await auth.login(email: email, password: '${password}x');
    expect((wrong as Err<AuthSession>).failure, isA<UnauthorizedFailure>());

    // Sign in and store tokens the way SessionController does.
    final signedIn = await auth.login(email: ' $email ', password: password);
    await session.saveTokens((signedIn as Ok<AuthSession>).value.tokens);

    // GET /auth/me goes out with the Bearer token.
    final me = await session.currentUser();
    expect((me as Ok<User>).value.email, email);

    // Refresh rotates the pair, and the old refresh token stops working:
    // the single-use behaviour the single-flight refresher exists for.
    final before = (await store.read())!;
    expect(await refresher.refresh(), isNotNull);
    final after = (await store.read())!;
    expect(after.refreshToken, isNot(before.refreshToken));
    final reuse = await buildDio(baseUrl: _apiUrl)
        .post<Object?>(
          '/auth/refresh',
          data: {'refreshToken': before.refreshToken},
          options: publicRequest(),
        )
        .then(
          (r) => r.statusCode,
          onError: (Object e) {
            return (e as DioException).response?.statusCode;
          },
        );
    expect(reuse, 401);

    // Still signed in with the new pair.
    expect(await session.currentUser(), isA<Ok<User>>());

    // Sign out revokes the refresh token on the server.
    await session.signOut();
    expect(await store.read(), isNull);
    final afterLogout = await buildDio(baseUrl: _apiUrl)
        .post<Object?>(
          '/auth/refresh',
          data: {'refreshToken': after.refreshToken},
          options: publicRequest(),
        )
        .then(
          (r) => r.statusCode,
          onError: (Object e) {
            return (e as DioException).response?.statusCode;
          },
        );
    expect(afterLogout, 401);
    expect(rejected, 0);
  }, skip: skip);
}
