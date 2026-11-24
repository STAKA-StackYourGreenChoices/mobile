@Tags(['golden'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'package:staka/features/wardrobe/presentation/screens/wardrobe_screen.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/wardrobe_fakes.dart';

Widget _wardrobe(List<DigitalCard> cards, {required bool emailVerified}) =>
    ProviderScope(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(
          SessionRepository(
            Dio(BaseOptions(baseUrl: 'http://api.test'))
              ..httpClientAdapter = FakeHttpAdapter([
                json(200, userJson(emailVerified: emailVerified)),
              ]),
            InMemoryTokenStore(
              const AuthTokens(accessToken: 'a', refreshToken: 'r'),
            ),
          ),
        ),
        wardrobeRepositoryProvider.overrideWithValue(
          FakeWardrobeRepository(cards: [Ok(cards)]),
        ),
      ],
      child: const WardrobeScreen(),
    );

void main() {
  setUpAll(loadAppFonts);

  final cases = {
    'tags': (
      [
        cardFor(
          id: '1',
          name: 'Organic Cotton Tee',
          status: OwnershipStatus.verified,
        ),
        cardFor(
          id: '2',
          name: 'Recycled Denim Jeans',
          status: OwnershipStatus.pending,
        ),
      ],
      false,
    ),
    'filter': (
      [
        cardFor(
          id: '1',
          name: 'Organic Cotton Tee',
          status: OwnershipStatus.verified,
          category: ProductCategory.tops,
          variant: navyM,
        ),
        cardFor(
          id: '2',
          name: 'Recycled Denim Jeans',
          status: OwnershipStatus.pending,
          category: ProductCategory.bottoms,
        ),
      ],
      true,
    ),
    'empty': (<DigitalCard>[], true),
  };

  for (final MapEntry(key: name, value: (cards, verified)) in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'wardrobe $name, ${brightness.name}',
        (tester) => withRealShadows(() async {
          usePhoneScreen(tester, height: name == 'empty' ? 760 : 1700);
          await pumpThemed(
            tester,
            _wardrobe(cards, emailVerified: verified),
            brightness: brightness,
          );
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              'goldens/wardrobe_${name}_${brightness.name}.png',
            ),
          );
        }),
      );
    }
  }
}
