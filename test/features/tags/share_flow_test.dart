import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/utils/public_tag_url.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _name = 'Organic Cotton Tee';
final _link = ShareLink(slug: 'abc123', createdAt: DateTime.utc(2026, 11, 15));
final String _url = publicTagUrl('abc123');

DigitalCard _verified({ShareLink? share}) => cardFor(
  id: 'c1',
  name: _name,
  status: OwnershipStatus.verified,
).copyWith(share: share);

/// Opens the tag from the wardrobe.
Future<void> _openTag(
  WidgetTester tester,
  DigitalCard card, {
  FakeTagRepository? tags,
  FakeShareActions? actions,
}) async {
  usePhoneScreen(tester, height: 3000);
  await pumpApp(
    tester,
    tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    replies: [json(200, userJson())],
    wardrobe: FakeWardrobeRepository(
      cards: [
        Ok([card]),
      ],
    ),
    tags: tags ?? FakeTagRepository(cards: [card]),
    shareActions: actions,
  );
  await tester.tap(find.text(_name).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('not verified yet: sharing is locked', (tester) async {
    await _openTag(tester, cardFor(id: 'c1', name: _name));

    expect(find.text("Sharing unlocks once you're verified"), findsOneWidget);
    expect(find.text('Create share link'), findsNothing);
  });

  testWidgets('create the link: shown, ready to share', (tester) async {
    final card = _verified();
    await _openTag(
      tester,
      card,
      tags: FakeTagRepository(cards: [card], shares: [Ok(_link)]),
    );

    await tester.tap(find.text('Create share link'));
    await tester.pumpAndSettle();

    expect(find.text(_url), findsOneWidget);
    expect(find.text('Share link ready'), findsOneWidget);
  });

  testWidgets('copy, share and open hand the link to the phone', (
    tester,
  ) async {
    final actions = FakeShareActions();
    await _openTag(tester, _verified(share: _link), actions: actions);

    await tester.tap(find.text('Copy link'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share…'));
    await tester.tap(find.text('See what others see'));
    await tester.pumpAndSettle();

    expect(actions.copied, [_url]);
    expect(find.text('Link copied'), findsOneWidget);
    expect(actions.sharedTexts, [
      'I own this $_name, verified on STAKA. $_url',
    ]);
    expect(actions.opened, [_url]);
  });

  testWidgets('story image: fetched, then given to the share sheet', (
    tester,
  ) async {
    final card = _verified(share: _link);
    final actions = FakeShareActions();
    await _openTag(
      tester,
      card,
      actions: actions,
      tags: FakeTagRepository(cards: [card], images: [Ok(Uint8List(8))]),
    );

    await tester.tap(find.text('Image for Instagram stories'));
    await tester.pumpAndSettle();

    expect(actions.sharedImages, ['staka-abc123.png']);
  });

  testWidgets('story image unavailable: says why', (tester) async {
    final card = _verified(share: _link);
    await _openTag(
      tester,
      card,
      tags: FakeTagRepository(
        cards: [card],
        images: [const Err(NetworkFailure())],
      ),
    );

    await tester.tap(find.text('Image for Instagram stories'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining("STAKA's server isn't reachable"),
      findsOneWidget,
    );
  });

  testWidgets('no app can open the link: says so', (tester) async {
    await _openTag(
      tester,
      _verified(share: _link),
      actions: FakeShareActions(canOpen: false),
    );

    await tester.tap(find.text('See what others see'));
    await tester.pumpAndSettle();

    expect(find.text("The link couldn't be opened."), findsOneWidget);
  });

  testWidgets('stop sharing asks first; confirming turns the link off', (
    tester,
  ) async {
    final card = _verified(share: _link);
    await _openTag(
      tester,
      card,
      tags: FakeTagRepository(cards: [card], stops: [const Ok(null)]),
    );

    await tester.tap(find.text('Stop sharing'));
    await tester.pumpAndSettle();
    expect(find.text('Stop sharing this tag?'), findsOneWidget);
    await tester.tap(find.text('Keep sharing'));
    await tester.pumpAndSettle();
    expect(find.text(_url), findsOneWidget);

    await tester.tap(find.text('Stop sharing'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Stop sharing'));
    await tester.pumpAndSettle();

    expect(find.text(_url), findsNothing);
    expect(find.text('Create share link'), findsOneWidget);
    expect(
      find.text('Sharing turned off. The old link no longer works.'),
      findsOneWidget,
    );
  });

  testWidgets('the API refuses: its reason above the button', (tester) async {
    final card = _verified();
    await _openTag(
      tester,
      card,
      tags: FakeTagRepository(
        cards: [card],
        shares: [
          const Err(
            ConflictFailure(['Prove you own this piece before sharing it']),
          ),
        ],
      ),
    );

    await tester.tap(find.text('Create share link'));
    await tester.pumpAndSettle();

    expect(
      find.text('Prove you own this piece before sharing it'),
      findsOneWidget,
    );
  });
}
