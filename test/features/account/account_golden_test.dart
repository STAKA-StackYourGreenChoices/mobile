@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/features/account/presentation/screens/account_screen.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('account screen, ${brightness.name}', (tester) async {
      final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
        ..httpClientAdapter = FakeHttpAdapter([json(200, userJson())]);
      usePhoneScreen(tester, height: 480);
      await pumpThemed(
        tester,
        ProviderScope(
          overrides: [
            sessionRepositoryProvider.overrideWithValue(
              SessionRepository(
                dio,
                InMemoryTokenStore(
                  const AuthTokens(accessToken: 'a', refreshToken: 'r'),
                ),
              ),
            ),
          ],
          child: const AccountScreen(),
        ),
        brightness: brightness,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/account_${brightness.name}.png'),
      );
    });
  }
}
