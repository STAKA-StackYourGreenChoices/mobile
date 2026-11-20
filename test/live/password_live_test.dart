@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

import 'live_client.dart';

/// Forgot and change password against a running API (see auth_live_test).
void main() {
  test('reset link answers the same for known and unknown emails', () async {
    final client = LiveClient();
    final email = throwawayEmail();
    await client.auth.register(
      name: 'Mobile Live Test',
      email: email,
      password: randomPassword(),
    );

    expect(
      await client.auth.requestPasswordReset(email: email),
      isA<Ok<void>>(),
    );
    expect(
      await client.auth.requestPasswordReset(email: throwawayEmail()),
      isA<Ok<void>>(),
    );
  }, skip: liveSkip);

  test('change password: wrong current costs no refresh; success revokes '
      'every session; the new password signs in', () async {
    final client = LiveClient();
    final email = throwawayEmail();
    final oldPassword = randomPassword();
    final newPassword = randomPassword();
    final registered = await client.auth.register(
      name: 'Mobile Live Test',
      email: email,
      password: oldPassword,
    );
    await client.session.saveTokens(
      (registered as Ok<AuthSession>).value.tokens,
    );
    final tokens = (await client.store.read())!;

    // Wrong current password: a 401 that must not trigger a token refresh.
    final wrong = await client.auth.changePassword(
      currentPassword: '${oldPassword}x',
      newPassword: newPassword,
    );
    expect((wrong as Err<void>).failure, isA<UnauthorizedFailure>());
    expect(await client.store.read(), tokens);

    // Right current password: changed, and the API revokes every session.
    final changed = await client.auth.changePassword(
      currentPassword: oldPassword,
      newPassword: newPassword,
    );
    expect(changed, isA<Ok<void>>());
    expect(await client.refreshStatus(tokens.refreshToken), 401);

    // Which is why the app signs straight back in with the new password.
    expect(
      await client.auth.login(email: email, password: newPassword),
      isA<Ok<AuthSession>>(),
    );
    final old = await client.auth.login(email: email, password: oldPassword);
    expect((old as Err<AuthSession>).failure, isA<UnauthorizedFailure>());
  }, skip: liveSkip);
}
