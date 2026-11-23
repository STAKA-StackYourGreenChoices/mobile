@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/brand_apply/data/repositories/brand_application_repository_impl.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/presentation/screens/brand_application_form_screen.dart';
import 'package:staka/features/brand_apply/presentation/screens/brand_applications_screen.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_apply_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

/// [screen], signed in as Ada, with [applications] as hers.
Widget _signedIn(Widget screen, List<BrandApplication> applications) =>
    ProviderScope(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(
          SessionRepository(
            Dio(BaseOptions(baseUrl: 'http://api.test'))
              ..httpClientAdapter = FakeHttpAdapter([json(200, userJson())]),
            InMemoryTokenStore(
              const AuthTokens(accessToken: 'a', refreshToken: 'r'),
            ),
          ),
        ),
        brandApplicationRepositoryProvider.overrideWithValue(
          FakeBrandApplicationRepository(mine: [Ok(applications)]),
        ),
      ],
      child: screen,
    );

void main() {
  setUpAll(loadAppFonts);

  final screens = {
    // No application yet: what brands get and what to have ready.
    'brand_apply_intro': (
      const BrandApplicationsScreen(),
      <BrandApplication>[],
    ),
    'brand_applications': (
      const BrandApplicationsScreen(),
      [
        brandApplication(
          id: 'ba2',
          name: 'Loom & Leaf',
          legalName: 'Loom and Leaf LLP',
          status: BrandApplicationStatus.rejected,
          statusReason: 'The GST certificate is unreadable',
        ),
        brandApplication(appliedAt: DateTime.utc(2026, 11, 14, 9)),
      ],
    ),
    'brand_apply_form': (
      const BrandApplicationFormScreen(),
      <BrandApplication>[],
    ),
  };

  for (final MapEntry(key: name, value: (screen, applications))
      in screens.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('$name screen, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: 760);
        await pumpThemed(
          tester,
          _signedIn(screen, applications),
          brightness: brightness,
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
        );
      });
    }
  }
}
