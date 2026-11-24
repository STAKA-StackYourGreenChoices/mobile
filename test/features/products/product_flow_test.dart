import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _gtin = '8901234500019';

/// Signs in, opens Scan and types [_gtin], landing on the product page.
Future<FakeWardrobeRepository> _openProduct(
  WidgetTester tester,
  FakeProductRepository products, {
  FakeTagRepository? tags,
}) async {
  usePhoneScreen(tester, height: 2200);
  final wardrobe = FakeWardrobeRepository();
  await pumpApp(
    tester,
    tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    replies: [json(200, userJson())],
    products: products,
    wardrobe: wardrobe,
    tags: tags,
  );
  await tester.tap(find.text('Scan'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(EditableText), _gtin);
  await tester.tap(find.text('Look up product'));
  await tester.pumpAndSettle();
  return wardrobe;
}

FakeProductRepository _with(ProductLookup lookup) =>
    FakeProductRepository(lookups: {_gtin: Ok(lookup)});

void main() {
  testWidgets('a product: its tag, words and what the figures mean', (
    tester,
  ) async {
    await _openProduct(
      tester,
      _with(
        ProductFound(
          productNamed(
            'Organic Cotton Tee',
            brandDescription: 'Made in Kerala.',
          ),
        ),
      ),
    );

    expect(
      find.text('Soft organic cotton, cut for everyday wear.'),
      findsOneWidget,
    );
    expect(find.text('Carbon footprint: 2.1 kg CO₂e'), findsOneWidget);
    expect(find.text('Recyclable: 80%'), findsOneWidget);
    expect(find.text('Independently verified'), findsOneWidget);
    expect(
      find.text('Global Organic Textile Standard has checked these figures.'),
      findsOneWidget,
    );
    expect(find.text('About Terra Threads'), findsOneWidget);
  });

  testWidgets('brand-stated and missing figures are said plainly', (
    tester,
  ) async {
    await _openProduct(
      tester,
      _with(
        ProductFound(
          productNamed(
            'Recycled Denim Jeans',
            info: const SustainabilityInfo(
              carbonScoreGrams: 9800,
              recyclabilityPercent: 70,
              isVerified: false,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Stated by the brand'), findsOneWidget);
    expect(
      find.text('No one outside the brand has checked these figures yet.'),
      findsOneWidget,
    );
  });

  testWidgets('no figures: the brand has not shared them', (tester) async {
    await _openProduct(
      tester,
      _with(ProductFound(productNamed('Linen Overshirt', info: null))),
    );
    expect(
      find.text("Terra Threads hasn't shared figures for this piece yet."),
      findsOneWidget,
    );
  });

  testWidgets('add to wardrobe: opens the new tag, wardrobe reloads', (
    tester,
  ) async {
    final products = FakeProductRepository(
      lookups: {_gtin: Ok(ProductFound(productNamed('Organic Cotton Tee')))},
      adds: [Ok(cardFor(id: '9', name: 'Organic Cotton Tee'))],
    );
    final newTag = cardFor(id: '9', name: 'Organic Cotton Tee');
    final wardrobe = await _openProduct(
      tester,
      products,
      tags: FakeTagRepository(cards: [newTag]),
    );
    final fetchesBefore = wardrobe.fetches;

    await tester.tap(find.text('Add to my wardrobe'));
    await tester.pumpAndSettle();

    expect(products.added, [_gtin]);
    expect(
      find.text('Organic Cotton Tee is in your wardrobe.'),
      findsOneWidget,
    );
    expect(wardrobe.fetches, greaterThan(fetchesBefore));
  });

  testWidgets('add fails: says why, stays on the product', (tester) async {
    await _openProduct(
      tester,
      FakeProductRepository(
        lookups: {_gtin: Ok(ProductFound(productNamed('Organic Cotton Tee')))},
        adds: [const Err(NetworkFailure())],
      ),
    );

    await tester.tap(find.text('Add to my wardrobe'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining("STAKA's server isn't reachable"),
      findsOneWidget,
    );
    expect(find.text('Add to my wardrobe'), findsOneWidget);
  });

  testWidgets('already in the wardrobe: View your tag opens it', (
    tester,
  ) async {
    await _openProduct(
      tester,
      _with(
        ProductFound(productNamed('Organic Cotton Tee'), ownedCardId: 'c1'),
      ),
      tags: FakeTagRepository(
        cards: [cardFor(id: 'c1', name: 'Organic Cotton Tee')],
      ),
    );

    expect(find.text('In your wardrobe'), findsOneWidget);
    expect(find.text('Add to my wardrobe'), findsNothing);
    await tester.tap(find.text('View your tag'));
    await tester.pumpAndSettle();
    expect(find.text('Prove you own it'), findsOneWidget);
    expect(find.textContaining('is in your wardrobe.'), findsNothing);
  });

  testWidgets("misread barcode: the API's reason, and Scan again", (
    tester,
  ) async {
    await _openProduct(
      tester,
      _with(const InvalidBarcode('Invalid GTIN check digit')),
    );

    expect(find.text("That barcode didn't read correctly"), findsOneWidget);
    expect(
      find.text(
        'Invalid GTIN check digit. Scan it again, or check the digits if '
        'you typed them.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Scan again'));
    await tester.pumpAndSettle();
    expect(find.text('Scan a product'), findsOneWidget);
  });

  testWidgets('not on STAKA yet: names the barcode', (tester) async {
    await _openProduct(tester, FakeProductRepository());

    expect(find.text("This product isn't on STAKA yet"), findsOneWidget);
    expect(
      find.text(
        'No brand has added barcode 8901234500019 yet. Only products from '
        'partner brands have tags for now.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a variant barcode: its size, colour, code and kind (V2-2)', (
    tester,
  ) async {
    await _openProduct(
      tester,
      _with(
        ProductFound(
          productNamed('Organic Cotton Tee').copyWith(
            category: ProductCategory.tops,
            variants: [navyM],
            matchedVariant: navyM,
          ),
        ),
      ),
    );

    expect(find.text('Size M · Navy'), findsOneWidget);
    expect(find.bySemanticsLabel('Type: Tops'), findsOneWidget);
    // The tag shows the scanned variant's barcode, not the primary one.
    expect(find.textContaining('8901234500057'), findsWidgets);
    expect(find.textContaining('8901234500019'), findsNothing);
  });

  testWidgets('no kind set: no chip, no size line', (tester) async {
    await _openProduct(tester, _with(ProductFound(productNamed('Tee'))));

    expect(find.text('Other'), findsNothing);
    expect(find.textContaining('Size'), findsNothing);
  });
}
