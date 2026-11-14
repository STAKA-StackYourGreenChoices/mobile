import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
const _productStub = '/scan/product/:gtin';

Future<void> _openScan(WidgetTester tester) async {
  usePhoneScreen(tester, height: 1400);
  await pumpApp(tester, tokens: _tokens, replies: [json(200, userJson())]);
  await tester.tap(find.text('Scan'));
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String code) async {
  await tester.enterText(find.byType(EditableText), code);
  await tester.tap(find.text('Look up product'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets("the website's heading and both ways in", (tester) async {
    await _openScan(tester);

    expect(find.text('Scan a product'), findsOneWidget);
    expect(find.text('Type the number instead'), findsOneWidget);
    expect(find.text('The digits printed under the bars.'), findsOneWidget);
  });

  testWidgets('a camera read opens that product', (tester) async {
    await _openScan(tester);

    await tester.tap(find.text('Simulate scan'));
    await tester.pumpAndSettle();

    expect(find.text(_productStub), findsOneWidget);
  });

  testWidgets('typed numbers: the same rules and messages as the website', (
    tester,
  ) async {
    await _openScan(tester);

    await _type(tester, '');
    expect(find.text('Enter the number under the barcode.'), findsOneWidget);

    await _type(tester, '12345');
    expect(
      find.text("That's 5 digits. Barcode numbers have 8, 12, 13 or 14."),
      findsOneWidget,
    );

    await _type(tester, 'https://staka.example');
    expect(
      find.text('This QR code links to a website, not a product STAKA knows.'),
      findsOneWidget,
    );

    await _type(tester, '890 1234 500019');
    expect(find.text(_productStub), findsOneWidget);
  });

  testWidgets('back from the product returns to Scan, bottom bar kept', (
    tester,
  ) async {
    await _openScan(tester);
    await _type(tester, '8901234500019');

    expect(find.byType(NavigationBar), findsOneWidget);
    // The phone's back button / gesture.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Scan a product'), findsOneWidget);
  });
}
