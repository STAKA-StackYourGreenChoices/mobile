@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

import 'live_client.dart';

/// The API's sign-in limit, through the app's real network stack: ten wrong
/// passwords lock this run's throwaway account for 15 minutes. Only that
/// account is affected (the limit is per email and address).
void main() {
  test(
    'too many wrong passwords: 429 with how long to wait',
    () async {
      final client = LiveClient();
      final email = throwawayEmail();
      final password = randomPassword();
      await client.auth.register(
        name: 'Mobile Live Test',
        email: email,
        password: password,
      );

      for (var attempt = 0; attempt < 10; attempt++) {
        final wrong = await client.auth.login(
          email: email,
          password: 'not-the-password',
        );
        expect((wrong as Err<AuthSession>).failure, isA<UnauthorizedFailure>());
      }

      // Now even the right password waits.
      final refused = await client.auth.login(email: email, password: password);
      final failure = (refused as Err<AuthSession>).failure;
      expect(failure, isA<TooManyRequestsFailure>());
      final retryAfter = (failure as TooManyRequestsFailure).retryAfter!;
      expect(retryAfter.inMinutes, inInclusiveRange(14, 15));
    },
    skip: liveSkip,
  );
}
