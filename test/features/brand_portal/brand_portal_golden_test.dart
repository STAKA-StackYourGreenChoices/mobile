@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/data/repositories/brand_portal_repository_impl.dart';
import 'package:staka/features/brand_portal/presentation/screens/brand_home_screen.dart';
import 'package:staka/features/brand_portal/presentation/screens/brand_settings_screen.dart';
import 'package:staka/features/brand_portal/presentation/screens/brand_team_screen.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

const _owner = BrandMembership(
  id: 'b1',
  name: 'Terra Threads',
  role: BrandRole.owner,
  status: BrandStatus.active,
);

/// [screen], signed in as Ada with [brands].
Widget _signedIn(Widget screen, List<Map<String, Object?>> brands) =>
    ProviderScope(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(
          SessionRepository(
            Dio(BaseOptions(baseUrl: 'http://api.test'))
              ..httpClientAdapter = FakeHttpAdapter([
                json(200, memberUserJson(brands)),
              ]),
            InMemoryTokenStore(
              const AuthTokens(accessToken: 'a', refreshToken: 'r'),
            ),
          ),
        ),
        adminClaimRepositoryProvider.overrideWith(
          (_, _) => FakeAdminClaimRepository(
            pages: (_) => const Ok(ClaimPage(items: [], total: 3)),
          ),
        ),
        brandPortalRepositoryProvider.overrideWithValue(
          FakeBrandPortalRepository(
            members: [
              const Ok([adaOwner, ravi]),
            ],
          ),
        ),
      ],
      child: screen,
    );

void main() {
  setUpAll(loadAppFonts);

  final twoBrands = [
    membershipJson(),
    membershipJson(id: 'b2', name: 'Loom & Leaf', role: 'STAFF'),
  ];
  final screens = {
    // Owner of two brands: Switch brand and Settings.
    'brand_home': (const BrandHomeScreen(), twoBrands),
    'brand_home_suspended': (
      const BrandHomeScreen(),
      [membershipJson(status: 'SUSPENDED')],
    ),
    'brand_team': (const BrandTeamScreen(brand: _owner), twoBrands),
    'brand_settings': (const BrandSettingsScreen(brand: _owner), twoBrands),
  };

  for (final MapEntry(key: name, value: (screen, brands)) in screens.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('$name screen, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: 760);
        await pumpThemed(
          tester,
          _signedIn(screen, brands),
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
