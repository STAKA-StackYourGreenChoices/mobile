import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/core/utils/public_wardrobe_url.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/sharing_fakes.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

final _link = ShareLink(
  slug: 'w4rdr0be',
  createdAt: DateTime.utc(2026, 11, 15),
);
final String _url = publicWardrobeUrl('w4rdr0be');

final DigitalCard _verified = cardFor(
  id: 'c1',
  name: 'Organic Cotton Tee',
  status: OwnershipStatus.verified,
);
final DigitalCard _waiting = cardFor(id: 'c2', name: 'Recycled Denim Jeans');

Future<void> _openWardrobe(
  WidgetTester tester, {
  List<DigitalCard>? cards,
  FakeWardrobeShareRepository? share,
  FakeShareActions? actions,
  FakeEventTracker? tracker,
  FakeShareImageApi? images,
}) async {
  usePhoneScreen(tester, height: 3000);
  await pumpApp(
    tester,
    tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
    replies: [json(200, userJson())],
    wardrobe: FakeWardrobeRepository(
      cards: [
        Ok(cards ?? [_verified]),
      ],
    ),
    wardrobeShare: share,
    shareActions: actions,
    eventTracker: tracker,
    shareImages: images,
  );
}

/// From the wardrobe to the share screen.
Future<void> _openShare(
  WidgetTester tester, {
  FakeWardrobeShareRepository? share,
  FakeShareActions? actions,
  FakeEventTracker? tracker,
  FakeShareImageApi? images,
}) async {
  await _openWardrobe(
    tester,
    share: share,
    actions: actions,
    tracker: tracker,
    images: images,
  );
  await tester.tap(find.text('Share your wardrobe'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the card waits for a verified piece', (tester) async {
    await _openWardrobe(tester, cards: [_waiting]);

    expect(find.text('Share your wardrobe'), findsNothing);
  });

  testWidgets('create the link: the date, the link and its channels', (
    tester,
  ) async {
    final share = FakeWardrobeShareRepository(shares: [Ok(_link)]);
    await _openShare(tester, share: share);

    await tester.tap(find.text('Create wardrobe link'));
    await tester.pumpAndSettle();

    expect(share.creates, 1);
    expect(find.text('Wardrobe link ready'), findsOneWidget);
    expect(find.text(_url), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('QR code'), findsOneWidget);
    expect(find.text('Shared since 15 Nov 2026'), findsOneWidget);
  });

  testWidgets('copy, share and open hand the link to the phone', (
    tester,
  ) async {
    final actions = FakeShareActions();
    final tracker = FakeEventTracker();
    final images = FakeShareImageApi();
    await _openShare(
      tester,
      share: FakeWardrobeShareRepository(current: _link),
      actions: actions,
      tracker: tracker,
      images: images,
    );

    await tester.tap(find.text('Copy link'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('More'));
    await tester.tap(find.text('Post (1:1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See what others see'));
    await tester.pumpAndSettle();

    expect(actions.copied, ['$_url?ch=copy']);
    expect(find.text('Link copied'), findsOneWidget);
    expect(actions.sharedTexts, [
      'My verified wardrobe on STAKA. $_url?ch=other',
    ]);
    expect(images.fetched, ['$_url/square']);
    expect(actions.sharedImages, ['staka-w4rdr0be-square.png']);
    expect(actions.opened, [_url]);
    // A wardrobe has no card id.
    expect(tracker.shareClicks, [
      (channel: ShareChannel.copy, cardId: null),
      (channel: ShareChannel.other, cardId: null),
      (channel: ShareChannel.other, cardId: null),
    ]);
  });

  testWidgets('stop sharing after confirming', (tester) async {
    final share = FakeWardrobeShareRepository(
      current: _link,
      stops: [const Ok(null)],
    );
    await _openShare(tester, share: share);

    await tester.tap(find.text('Stop sharing'));
    await tester.pumpAndSettle();
    expect(find.text('Stop sharing your wardrobe?'), findsOneWidget);
    await tester.tap(find.text('Keep sharing'));
    await tester.pumpAndSettle();
    expect(share.stopsSent, 0);

    await tester.tap(find.text('Stop sharing'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Stop sharing'));
    await tester.pumpAndSettle();

    expect(share.stopsSent, 1);
    expect(find.text(_url), findsNothing);
    expect(find.text('Create wardrobe link'), findsOneWidget);
    expect(
      find.text('Sharing turned off. The old link no longer works.'),
      findsOneWidget,
    );
  });

  testWidgets('a refused link shows the API reason', (tester) async {
    await _openShare(
      tester,
      share: FakeWardrobeShareRepository(
        shares: [
          const Err(
            ForbiddenFailure(['Verify a piece before sharing your wardrobe.']),
          ),
        ],
      ),
    );

    await tester.tap(find.text('Create wardrobe link'));
    await tester.pumpAndSettle();

    expect(
      find.text('Verify a piece before sharing your wardrobe.'),
      findsOneWidget,
    );
    expect(find.text('Create wardrobe link'), findsOneWidget);
  });

  testWidgets('a failed load can be retried', (tester) async {
    final share = FakeWardrobeShareRepository(
      current: _link,
      fetchFailures: [const NetworkFailure()],
    );
    await _openShare(tester, share: share);

    expect(find.text('Try again'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(share.fetches, 2);
    expect(find.text(_url), findsOneWidget);
  });
}
