import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';

import '../helpers/auth_fakes.dart';
import '../helpers/fake_http_adapter.dart';
import '../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

void main() {
  testWidgets('first launch: the welcome screen, in the website words', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(
      find.text('Your clothes, with their footprint attached.'),
      findsOneWidget,
    );
    expect(find.text('Continue with phone number'), findsOneWidget);
    expect(find.text('Use email instead'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('welcome actions open phone sign-in, email sign-in, register', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Continue with phone number'));
    await tester.pumpAndSettle();
    expect(find.text('Your phone number'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use email instead'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();
    expect(find.text('Create your STAKA account'), findsOneWidget);
  });

  testWidgets('a saved shopper session opens the wardrobe tab, no Admin', (
    tester,
  ) async {
    await pumpApp(tester, tokens: _tokens, replies: [json(200, userJson())]);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('My wardrobe'), findsOneWidget);
    expect(find.text('Admin'), findsNothing);

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Change password'), findsOneWidget);
  });

  testWidgets('admins also get the Admin tab', (tester) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [json(200, userJson(role: 'ADMIN'))],
    );

    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();
    // The hub (V2-12): brands, disputes, then read-only claims and
    // products. Catalog editing and Import moved to the Brand tab.
    for (final area in ['Brands', 'Disputes', 'Claims', 'Products']) {
      expect(find.text(area), findsOneWidget);
    }
    expect(find.text('Import'), findsNothing);
    expect(find.text('No applications waiting.'), findsOneWidget);
    expect(find.text('No disputes waiting.'), findsOneWidget);
  });

  testWidgets('API down at launch: retry, then into the app', (tester) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [connectionError(), json(200, userJson())],
    );

    expect(find.text('No connection'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('My wardrobe'), findsOneWidget);
  });

  testWidgets('API down at launch: sign out gets you unstuck', (tester) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [connectionError(), connectionError()],
    );

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Continue with phone number'), findsOneWidget);
  });
}
