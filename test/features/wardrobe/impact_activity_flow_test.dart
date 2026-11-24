import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/tags/domain/models/card_stats.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
final DigitalCard _tee = cardFor(
  id: 'c1',
  name: 'Organic Cotton Tee',
  status: OwnershipStatus.verified,
);

ActivityItem _entry(int n, {String? cardId}) => ActivityItem(
  type: ActivityType.tagViewed,
  at: DateTime.utc(2026, 11, 20),
  cardId: cardId,
  productName: 'Piece $n',
);

Future<void> _openWardrobe(
  WidgetTester tester, {
  required FakeImpactRepository impact,
  FakeTagRepository? tags,
  double height = 3000,
}) async {
  usePhoneScreen(tester, height: height);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson())],
    wardrobe: FakeWardrobeRepository(
      cards: [
        Ok([_tee]),
      ],
    ),
    impact: impact,
    tags: tags ?? FakeTagRepository(cards: [_tee]),
  );
}

void main() {
  testWidgets('the wardrobe shows the impact summary', (tester) async {
    await _openWardrobe(
      tester,
      impact: FakeImpactRepository(impact: const Ok(sampleImpact)),
    );

    expect(find.text('Your impact'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('Footprint owned'), findsOneWidget);
    expect(find.textContaining('8.4'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
  });

  testWidgets('no impact card when the API has none', (tester) async {
    await _openWardrobe(tester, impact: FakeImpactRepository());

    expect(find.text('Organic Cotton Tee'), findsWidgets);
    expect(find.text('Your impact'), findsNothing);
  });

  testWidgets('activity: entries, points, and a tap opens the tag', (
    tester,
  ) async {
    await _openWardrobe(
      tester,
      impact: FakeImpactRepository(
        impact: const Ok(sampleImpact),
        activity: {
          1: Ok(
            ActivityPage(
              items: [
                ActivityItem(
                  type: ActivityType.ownershipVerified,
                  at: DateTime.utc(2026, 11, 20),
                  cardId: 'c1',
                  productName: 'Organic Cotton Tee',
                  points: 50,
                ),
                ActivityItem(
                  type: ActivityType.wardrobeViewed,
                  at: DateTime.utc(2026, 11, 21),
                  channel: ShareChannel.qr,
                ),
              ],
              total: 2,
            ),
          ),
        },
      ),
    );

    await tester.tap(find.text('See your activity'));
    await tester.pumpAndSettle();

    expect(find.text('Organic Cotton Tee was verified as yours'), findsOne);
    expect(find.text('+50 points'), findsOneWidget);
    expect(find.text('Someone viewed your wardrobe'), findsOneWidget);
    expect(find.text('21 Nov 2026 · via QR code'), findsOneWidget);

    await tester.tap(find.text('Organic Cotton Tee was verified as yours'));
    await tester.pumpAndSettle();

    expect(find.text('Share this tag'), findsOneWidget);
  });

  testWidgets('activity loads more as you scroll', (tester) async {
    final impact = FakeImpactRepository(
      impact: const Ok(sampleImpact),
      activity: {
        1: Ok(
          ActivityPage(
            items: [for (var n = 1; n <= 20; n++) _entry(n)],
            total: 25,
          ),
        ),
        2: Ok(
          ActivityPage(
            items: [for (var n = 21; n <= 25; n++) _entry(n)],
            total: 25,
          ),
        ),
      },
    );
    await _openWardrobe(tester, impact: impact, height: 800);
    await tester.tap(find.text('See your activity'));
    await tester.pumpAndSettle();
    expect(impact.activityPages, [1]);

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -3000),
      3000,
    );
    await tester.pumpAndSettle();

    expect(impact.activityPages, [1, 2]);
    expect(find.text('Someone viewed Piece 25'), findsOneWidget);
  });

  testWidgets('activity: empty, and a failed load can be retried', (
    tester,
  ) async {
    final impact = FakeImpactRepository(
      impact: const Ok(sampleImpact),
      activity: {1: const Err(NetworkFailure())},
    );
    await _openWardrobe(tester, impact: impact);
    await tester.tap(find.text('See your activity'));
    await tester.pumpAndSettle();

    expect(find.text('Try again'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    // The fake answers the same failure again: still offered.
    expect(impact.activityPages, [1, 1]);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('a new account has no activity yet', (tester) async {
    await _openWardrobe(
      tester,
      impact: FakeImpactRepository(impact: const Ok(sampleImpact)),
    );
    await tester.tap(find.text('See your activity'));
    await tester.pumpAndSettle();

    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  group('tag stats', () {
    final shared = _tee.copyWith(
      share: ShareLink(slug: 'abc123', createdAt: DateTime.utc(2026, 11, 15)),
    );
    const stats = CardStats(
      views: 30,
      viewsByChannel: {ShareChannel.whatsapp: 12, ShareChannel.qr: 3},
      clicks: 5,
    );

    Future<void> openTag(
      WidgetTester tester,
      DigitalCard card,
      Result<CardStats> answer,
    ) async {
      usePhoneScreen(tester, height: 3000);
      await pumpApp(
        tester,
        tokens: _tokens,
        replies: [json(200, userJson())],
        wardrobe: FakeWardrobeRepository(
          cards: [
            Ok([card]),
          ],
        ),
        tags: FakeTagRepository(cards: [card], stats: answer),
      );
      await tester.tap(find.text('Organic Cotton Tee').first);
      await tester.pumpAndSettle();
    }

    testWidgets('a shared tag shows its views by channel and clicks', (
      tester,
    ) async {
      await openTag(tester, shared, const Ok(stats));

      expect(find.text('How your link is doing'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('Visits to the brand'), findsOneWidget);
      expect(find.text('WhatsApp'), findsWidgets);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('not shared, or no stats from the API: none shown', (
      tester,
    ) async {
      await openTag(tester, _tee, const Ok(stats));
      expect(find.text('How your link is doing'), findsNothing);
    });

    testWidgets('stats that fail to load are left out', (tester) async {
      await openTag(tester, shared, const Err(NetworkFailure()));

      expect(find.text('Share this tag'), findsOneWidget);
      expect(find.text('How your link is doing'), findsNothing);
    });
  });
}
