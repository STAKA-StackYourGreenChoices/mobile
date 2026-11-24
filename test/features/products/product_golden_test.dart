@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';
import 'package:staka/features/products/presentation/screens/product_screen.dart';

import '../../helpers/golden.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/wardrobe_fakes.dart';

Widget _product(ProductLookup lookup) => ProviderScope(
  overrides: [
    productRepositoryProvider.overrideWithValue(
      FakeProductRepository(lookups: {'8901234500019': Ok(lookup)}),
    ),
  ],
  child: const ProductScreen(gtin: '8901234500019'),
);

void main() {
  setUpAll(loadAppFonts);

  final cases = {
    'found': (
      ProductFound(
        productNamed(
          'Organic Cotton Tee',
          brandDescription:
              'Slow-made basics from organic and recycled fibres.',
        ),
      ),
      1900.0,
    ),
    'variant': (
      ProductFound(
        productNamed('Organic Cotton Tee').copyWith(
          category: ProductCategory.tops,
          variants: [navyM],
          matchedVariant: navyM,
        ),
      ),
      1300.0,
    ),
    'unknown': (const UnknownProduct(), 700.0),
  };

  for (final MapEntry(key: name, value: (lookup, height)) in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'product $name, ${brightness.name}',
        (tester) => withRealShadows(() async {
          usePhoneScreen(tester, height: height);
          await pumpThemed(tester, _product(lookup), brightness: brightness);
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/product_${name}_${brightness.name}.png'),
          );
        }),
      );
    }
  }
}
