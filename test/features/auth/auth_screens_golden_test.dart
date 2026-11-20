@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/features/auth/presentation/screens/change_password_screen.dart';
import 'package:staka/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:staka/features/auth/presentation/screens/login_screen.dart';
import 'package:staka/features/auth/presentation/screens/register_screen.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

Widget _signedOut(Widget screen) => ProviderScope(
  overrides: [
    sessionRepositoryProvider.overrideWithValue(
      SessionRepository(Dio(), InMemoryTokenStore()),
    ),
  ],
  child: screen,
);

void main() {
  setUpAll(loadAppFonts);

  final screens = {
    'login': const LoginScreen(),
    'register': const RegisterScreen(),
    'forgot_password': const ForgotPasswordScreen(),
    'change_password': const ChangePasswordScreen(),
  };

  for (final MapEntry(key: name, value: screen) in screens.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('$name screen, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: 760);
        await pumpThemed(tester, _signedOut(screen), brightness: brightness);
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
        );
      });
    }
  }
}
