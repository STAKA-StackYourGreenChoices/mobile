@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/features/account/presentation/screens/account_phone_screen.dart';
import 'package:staka/features/account/presentation/screens/account_screen.dart';
import 'package:staka/features/account/presentation/screens/add_email_screen.dart';
import 'package:staka/features/account/presentation/screens/set_password_screen.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

/// Signed up with a phone number: no email, no password.
Map<String, Object?> _phoneOnlyJson() => {
  ...userJson(),
  'email': null,
  'emailVerified': false,
  'phone': '+919876543210',
  'phoneVerified': true,
  'hasPassword': false,
};

/// [screen], signed in as a phone-only account.
Widget _signedIn(Widget screen) => ProviderScope(
  overrides: [
    sessionRepositoryProvider.overrideWithValue(
      SessionRepository(
        Dio(BaseOptions(baseUrl: 'http://api.test'))
          ..httpClientAdapter = FakeHttpAdapter([json(200, _phoneOnlyJson())]),
        InMemoryTokenStore(
          const AuthTokens(accessToken: 'a', refreshToken: 'r'),
        ),
      ),
    ),
  ],
  child: screen,
);

void main() {
  setUpAll(loadAppFonts);

  final screens = {
    'account_phone_only': const AccountScreen(),
    'account_phone': const AccountPhoneScreen(),
    'add_email': const AddEmailScreen(),
    'set_password': const SetPasswordScreen(),
  };

  for (final MapEntry(key: name, value: screen) in screens.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('$name screen, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: 640);
        await pumpThemed(tester, _signedIn(screen), brightness: brightness);
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
        );
      });
    }
  }
}
