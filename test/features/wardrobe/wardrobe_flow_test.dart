import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/wardrobe_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

void main() {
  testWidgets('empty: the invitation, and its action opens Scan', (
    tester,
  ) async {
    await pumpApp(tester, tokens: _tokens, replies: [json(200, userJson())]);

    expect(find.text('My wardrobe'), findsOneWidget);
    expect(find.text('Your wardrobe is empty'), findsOneWidget);
    expect(
      find.text(
        "Scan the barcode on a garment's label to keep its footprint on a "
        'digital tag.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Scan your first piece'));
    await tester.pumpAndSettle();
    expect(find.text('/scan'), findsOneWidget);
  });

  testWidgets('tags split into verified and waiting, like the website', (
    tester,
  ) async {
    usePhoneScreen(tester, height: 3000);
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [json(200, userJson())],
      wardrobe: FakeWardrobeRepository(
        cards: [
          Ok([
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
            cardFor(id: '3', name: 'Linen Overshirt', hasFigures: false),
          ]),
        ],
      ),
    );

    expect(find.text('3 pieces, 1 verified.'), findsOneWidget);
    expect(find.text('Verified (1)'), findsOneWidget);
    expect(find.text('Waiting for proof (2)'), findsOneWidget);
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(find.text('Receipt under review'), findsOneWidget);
    expect(find.text('Not verified yet'), findsOneWidget);
    expect(
      find.text('Verified owner'),
      findsNothing,
    ); // shown on the tag itself
    expect(find.text('Scan a product'), findsOneWidget);
  });

  testWidgets('unconfirmed email: banner, and "Send a new link" works', (
    tester,
  ) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [json(200, userJson(emailVerified: false))],
      wardrobe: FakeWardrobeRepository(resends: [const Ok(ResendOutcome.sent)]),
    );

    expect(
      find.text(
        'We sent a confirmation link to ada@example.com. '
        'Open it to confirm your email.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Send a new link'));
    await tester.pumpAndSettle();
    expect(find.text("We've sent a new confirmation link."), findsOneWidget);
  });

  testWidgets('confirmed on the website meanwhile: the banner goes away', (
    tester,
  ) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [
        json(200, userJson(emailVerified: false)),
        json(200, userJson()),
      ],
      wardrobe: FakeWardrobeRepository(
        resends: [const Ok(ResendOutcome.alreadyConfirmed)],
      ),
    );

    await tester.tap(find.text('Send a new link'));
    await tester.pumpAndSettle();

    expect(find.text('Send a new link'), findsNothing);
  });

  testWidgets('first load fails: the error, then retry shows the tags', (
    tester,
  ) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [json(200, userJson())],
      wardrobe: FakeWardrobeRepository(
        cards: [
          const Err(NetworkFailure()),
          Ok([cardFor(id: '1', name: 'Organic Cotton Tee')]),
        ],
      ),
    );

    expect(find.text('No connection'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
  });

  testWidgets('a failed pull-to-refresh keeps the tags and says why', (
    tester,
  ) async {
    await pumpApp(
      tester,
      tokens: _tokens,
      replies: [json(200, userJson()), json(200, userJson())],
      wardrobe: FakeWardrobeRepository(
        cards: [
          Ok([cardFor(id: '1', name: 'Organic Cotton Tee')]),
          const Err(NetworkFailure()),
        ],
      ),
    );

    await tester.fling(find.text('My wardrobe'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(find.text('Organic Cotton Tee'), findsOneWidget);
    expect(
      find.textContaining("STAKA's server isn't reachable"),
      findsOneWidget,
    );
  });
}
