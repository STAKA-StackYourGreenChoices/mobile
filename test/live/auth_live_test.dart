@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

import 'live_client.dart';

/// Runs the app's real network, auth and refresh code against a running
/// API. Skipped unless given its address:
///
///   flutter test test/live --dart-define=LIVE_API_URL=http://localhost:7070
///
/// Each run registers throwaway `mobile-live-*@example.com` accounts.
void main() {
  test('register, sign in, refresh, sign out against the real API', () async {
    final client = LiveClient();
    final email = throwawayEmail();
    final password = randomPassword();

    // Register: signed in at once, shopper, email not confirmed yet.
    final registered = await client.auth.register(
      name: 'Mobile Live Test',
      email: email,
      password: password,
    );
    final newUser = (registered as Ok<AuthSession>).value.user;
    expect(newUser.role, Role.user);
    expect(newUser.emailVerified, isFalse);

    // The same email again is a conflict, which the form shows on the field.
    final again = await client.auth.register(
      name: 'Mobile Live Test',
      email: email,
      password: password,
    );
    expect((again as Err<AuthSession>).failure, isA<ConflictFailure>());

    // A wrong password is a 401 the form turns into the website's alert.
    final wrong = await client.auth.login(
      email: email,
      password: '${password}x',
    );
    expect((wrong as Err<AuthSession>).failure, isA<UnauthorizedFailure>());

    // Sign in and store tokens the way SessionController does.
    final signedIn = await client.auth.login(
      email: ' $email ',
      password: password,
    );
    await client.session.saveTokens((signedIn as Ok<AuthSession>).value.tokens);

    // GET /auth/me goes out with the Bearer token.
    final me = await client.session.currentUser();
    expect((me as Ok<User>).value.email, email);

    // Refresh rotates the pair, and the old refresh token stops working:
    // the single-use behaviour the single-flight refresher exists for.
    final before = (await client.store.read())!;
    expect(await client.refresher.refresh(), isNotNull);
    final after = (await client.store.read())!;
    expect(after.refreshToken, isNot(before.refreshToken));
    expect(await client.refreshStatus(before.refreshToken), 401);

    // Still signed in with the new pair.
    expect(await client.session.currentUser(), isA<Ok<User>>());

    // Sign out revokes the refresh token on the server.
    await client.session.signOut();
    expect(await client.store.read(), isNull);
    expect(await client.refreshStatus(after.refreshToken), 401);
    expect(client.rejections, 0);
  }, skip: liveSkip);
}
