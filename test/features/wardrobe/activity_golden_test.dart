@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/features/tags/domain/models/card_stats.dart';
import 'package:staka/features/tags/presentation/widgets/tag_stats_section.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';
import 'package:staka/features/wardrobe/presentation/screens/activity_screen.dart';
import 'package:staka/features/wardrobe/presentation/state/impact_controllers.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

final _items = [
  ActivityItem(
    type: ActivityType.tagViewed,
    at: DateTime.utc(2026, 11, 22),
    cardId: 'c1',
    productName: 'Organic Cotton Tee',
    channel: ShareChannel.whatsapp,
  ),
  ActivityItem(
    type: ActivityType.ownershipVerified,
    at: DateTime.utc(2026, 11, 20),
    cardId: 'c1',
    productName: 'Organic Cotton Tee',
    points: 50,
  ),
  ActivityItem(
    type: ActivityType.wardrobeViewed,
    at: DateTime.utc(2026, 11, 19),
    channel: ShareChannel.qr,
  ),
  ActivityItem(type: ActivityType.shareCreated, at: DateTime.utc(2026, 11, 18)),
  ActivityItem(
    type: ActivityType.cardAdded,
    at: DateTime.utc(2026, 11, 15),
    cardId: 'c2',
    productName: 'Recycled Denim Jeans',
  ),
  ActivityItem(type: ActivityType.scanUnknown, at: DateTime.utc(2026, 11, 14)),
];

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('activity, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 760);
      await pumpThemed(
        tester,
        Padding(
          padding: AppSpacing.screenH,
          child: ActivityScrollView(
            state: ActivityLoaded(
              items: _items,
              total: _items.length,
              loadedPages: 1,
            ),
            onRefresh: () async {},
            onRetry: () {},
            onLoadMore: () {},
            onTagPressed: (_) {},
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/activity_${brightness.name}.png'),
      );
    });

    testWidgets('tag stats, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 520);
      await pumpThemed(
        tester,
        const SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Card(
            child: Padding(
              padding: AppSpacing.card,
              child: Column(
                spacing: AppSpacing.lg,
                children: [
                  TagStatsSection(
                    stats: CardStats(
                      views: 30,
                      viewsByChannel: {
                        ShareChannel.whatsapp: 18,
                        ShareChannel.instagram: 7,
                        ShareChannel.qr: 3,
                        ShareChannel.other: 2,
                      },
                      clicks: 5,
                    ),
                  ),
                  TagStatsSection(
                    stats: CardStats(views: 0, viewsByChannel: {}, clicks: 0),
                  ),
                ],
              ),
            ),
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/tag_stats_${brightness.name}.png'),
      );
    });
  }
}
