import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/product_variant.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/wardrobe_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

Future<void> _openWardrobe(WidgetTester tester, List<DigitalCard> cards) async {
  usePhoneScreen(tester, height: 3000);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson())],
    wardrobe: FakeWardrobeRepository(cards: [Ok(cards)]),
  );
}

Finder _chip(String label) => find.widgetWithText(ChoiceChip, label);

void main() {
  final tee = cardFor(
    id: '1',
    name: 'Organic Cotton Tee',
    status: OwnershipStatus.verified,
    category: ProductCategory.tops,
    variant: navyM,
  );
  final jeans = cardFor(
    id: '2',
    name: 'Recycled Denim Jeans',
    status: OwnershipStatus.pending,
    category: ProductCategory.bottoms,
  );
  final shirt = cardFor(
    id: '3',
    name: 'Linen Overshirt',
    category: ProductCategory.tops,
  );

  testWidgets('the scanned size and colour show under the tag', (tester) async {
    await _openWardrobe(tester, [tee, jeans]);

    expect(find.text('Size M · Navy'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Organic Cotton Tee.*Size M · Navy')),
      findsOneWidget,
    );
  });

  testWidgets('chips filter by kind; only the kinds the shopper has', (
    tester,
  ) async {
    await _openWardrobe(tester, [tee, jeans, shirt]);

    expect(_chip('All'), findsOneWidget);
    expect(_chip('Tops'), findsOneWidget);
    expect(_chip('Bottoms'), findsOneWidget);
    expect(_chip('Dresses'), findsNothing);
    expect(tester.widget<ChoiceChip>(_chip('All')).selected, isTrue);

    await tester.tap(_chip('Tops'));
    await tester.pumpAndSettle();

    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(find.text('Linen Overshirt'), findsOneWidget);
    expect(find.text('Recycled Denim Jeans'), findsNothing);
    expect(find.text('Verified (1)'), findsOneWidget);
    expect(find.text('Waiting for proof (1)'), findsOneWidget);
    // The header still counts the whole wardrobe.
    expect(find.text('3 pieces, 1 verified.'), findsOneWidget);

    await tester.tap(_chip('Bottoms'));
    await tester.pumpAndSettle();
    expect(find.text('Recycled Denim Jeans'), findsOneWidget);
    expect(find.text('Verified (1)'), findsNothing);

    await tester.tap(_chip('All'));
    await tester.pumpAndSettle();
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(find.text('Recycled Denim Jeans'), findsOneWidget);
  });

  testWidgets('one kind of piece, or none set: no chips', (tester) async {
    await _openWardrobe(tester, [
      tee,
      cardFor(id: '4', name: 'Linen Overshirt', category: ProductCategory.tops),
    ]);
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('pieces without a kind are grouped under Other', (tester) async {
    await _openWardrobe(tester, [tee, cardFor(id: '5', name: 'Wool Scarf')]);

    await tester.tap(_chip('Other'));
    await tester.pumpAndSettle();
    expect(find.text('Wool Scarf'), findsOneWidget);
    expect(find.text('Organic Cotton Tee'), findsNothing);
  });
}
