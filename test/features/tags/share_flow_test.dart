import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/core/utils/public_tag_url.dart';
import 'package:staka/shared/widgets/sharing/qr_code_sheet.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/sharing_fakes.dart';
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
  FakeEventTracker? tracker,
  FakeShareImageApi? images,
  FakeQrPng? qrPng,
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
    eventTracker: tracker,
    shareImages: images,
    qrPng: qrPng,
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

  testWidgets('every channel adds ?ch= and reports the click', (tester) async {
    final actions = FakeShareActions();
    final tracker = FakeEventTracker();
    await _openTag(
      tester,
      _verified(share: _link),
      actions: actions,
      tracker: tracker,
    );

    await tester.tap(find.text('WhatsApp'));
    await tester.tap(find.text('Copy link'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('More'));
    await tester.tap(find.text('See what others see'));
    await tester.pumpAndSettle();

    const text = 'I own this $_name, verified on STAKA.';
    expect(actions.opened, [
      'https://wa.me/?text=${Uri.encodeComponent('$text $_url?ch=whatsapp')}',
      // Opening the public page is not a share.
      _url,
    ]);
    expect(actions.copied, ['$_url?ch=copy']);
    expect(find.text('Link copied'), findsOneWidget);
    expect(actions.sharedTexts, ['$text $_url?ch=other']);
    expect(tracker.shareClicks, [
      (channel: ShareChannel.whatsapp, cardId: 'c1'),
      (channel: ShareChannel.copy, cardId: 'c1'),
      (channel: ShareChannel.other, cardId: 'c1'),
    ]);
  });

  testWidgets('Instagram story, Story and Post: downloaded, then shared', (
    tester,
  ) async {
    final actions = FakeShareActions();
    final tracker = FakeEventTracker();
    final images = FakeShareImageApi();
    await _openTag(
      tester,
      _verified(share: _link),
      actions: actions,
      tracker: tracker,
      images: images,
    );

    await tester.tap(find.text('Instagram'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Story (9:16)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Post (1:1)'));
    await tester.pumpAndSettle();

    expect(images.fetched, ['$_url/story', '$_url/story', '$_url/square']);
    expect(actions.sharedImages, [
      'staka-abc123-story.png',
      'staka-abc123-story.png',
      'staka-abc123-square.png',
    ]);
    expect(actions.sharedImageTexts.map((t) => t.split('?').last), [
      'ch=instagram',
      'ch=other',
      'ch=other',
    ]);
    expect(tracker.shareClicks.map((c) => c.channel), [
      ShareChannel.instagram,
      ShareChannel.other,
      ShareChannel.other,
    ]);
  });

  testWidgets('an image that cannot be fetched says why', (tester) async {
    final actions = FakeShareActions();
    final tracker = FakeEventTracker();
    await _openTag(
      tester,
      _verified(share: _link),
      actions: actions,
      tracker: tracker,
      images: FakeShareImageApi([const Err(NetworkFailure())]),
    );

    await tester.tap(find.text('Instagram'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining("STAKA's server isn't reachable"),
      findsOneWidget,
    );
    expect(actions.sharedImages, isEmpty);
    expect(tracker.shareClicks, isEmpty);
  });

  testWidgets('QR code: shown in a sheet, saved as an image', (tester) async {
    final actions = FakeShareActions();
    final tracker = FakeEventTracker();
    final qrPng = FakeQrPng();
    await _openTag(
      tester,
      _verified(share: _link),
      actions: actions,
      tracker: tracker,
      qrPng: qrPng,
    );

    await tester.tap(find.text('QR code'));
    await tester.pumpAndSettle();

    expect(find.byType(QrCodeSheet), findsOneWidget);
    expect(find.bySemanticsLabel('QR code for this link'), findsOneWidget);
    expect(tracker.shareClicks.map((c) => c.channel), [ShareChannel.qr]);

    await tester.tap(find.text('Save or send image'));
    await tester.pumpAndSettle();

    expect(qrPng.rendered, ['$_url?ch=qr']);
    expect(actions.sharedImages, ['staka-abc123-qr.png']);
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
