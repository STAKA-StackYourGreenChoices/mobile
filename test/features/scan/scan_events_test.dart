import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/sharing_fakes.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
const _unknown = '4006381333931';
const _mistyped = '4006381333932';
const _offline = '5012345678900';

Future<FakeEventTracker> _openScan(WidgetTester tester) async {
  final tracker = FakeEventTracker();
  usePhoneScreen(tester, height: 1400);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson())],
    eventTracker: tracker,
    products: FakeProductRepository(
      lookups: {
        // What the camera fake reads.
        '08901234500019': Ok(ProductFound(productNamed('Organic Cotton Tee'))),
        _mistyped: const Ok(InvalidBarcode('The check digit is wrong.')),
        _offline: const Err(NetworkFailure()),
      },
    ),
  );
  await tester.tap(find.text('Scan'));
  await tester.pumpAndSettle();
  return tracker;
}

Future<void> _type(WidgetTester tester, String code) async {
  await tester.enterText(find.byType(EditableText), code);
  await tester.tap(find.text('Look up product'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a product found by the camera is a scan', (tester) async {
    final tracker = await _openScan(tester);

    await tester.tap(find.text('Simulate scan'));
    await tester.pumpAndSettle();

    expect(find.text('Add to my wardrobe'), findsOneWidget);
    expect(tracker.scans, [(gtin: '08901234500019', known: true)]);
  });

  testWidgets('a typed code no brand has is an unknown scan', (tester) async {
    final tracker = await _openScan(tester);

    await _type(tester, _unknown);

    expect(tracker.scans, [(gtin: _unknown, known: false)]);
  });

  testWidgets('a mistyped code or a failed lookup is not a scan', (
    tester,
  ) async {
    final tracker = await _openScan(tester);

    await _type(tester, _mistyped);
    expect(find.textContaining('The check digit is wrong.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await _type(tester, _offline);

    expect(find.text('Try again'), findsOneWidget);
    expect(tracker.scans, isEmpty);
  });

  testWidgets("a tag's Product details link is not a scan", (tester) async {
    final tracker = FakeEventTracker();
    final card = cardFor(id: '1', name: 'Organic Cotton Tee');
    usePhoneScreen(tester, height: 3000);
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [json(200, userJson())],
      eventTracker: tracker,
      wardrobe: FakeWardrobeRepository(
        cards: [
          Ok([card]),
        ],
      ),
      tags: FakeTagRepository(cards: [card]),
      products: FakeProductRepository(
        lookups: {
          card.product.gtin: Ok(
            ProductFound(productNamed('Organic Cotton Tee')),
          ),
        },
      ),
    );
    await tester.tap(find.text('Organic Cotton Tee').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Product details'));
    await tester.pumpAndSettle();

    expect(find.text('Add to my wardrobe'), findsOneWidget);
    expect(tracker.scans, isEmpty);
  });
}
