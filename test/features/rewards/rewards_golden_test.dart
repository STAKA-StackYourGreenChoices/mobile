@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/rewards/presentation/screens/points_history_screen.dart';
import 'package:staka/features/rewards/presentation/screens/reward_detail_screen.dart';
import 'package:staka/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:staka/features/rewards/presentation/state/points_controllers.dart';
import 'package:staka/features/rewards/presentation/state/rewards_controllers.dart';

import '../../helpers/golden.dart';
import '../../helpers/points_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/rewards_fakes.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets(
      'rewards, ${brightness.name}',
      (tester) => withRealShadows(() async {
        usePhoneScreen(tester, height: 1500);
        await pumpThemed(
          tester,
          Padding(
            padding: AppSpacing.screenH,
            child: RewardsScrollView(
              overview: Ok(samplePoints()),
              catalog: Ok(sampleRewards),
              rules: sampleRules,
              onRefresh: () async {},
              onRetry: () {},
              onCatalogRetry: () {},
              onHistoryPressed: () {},
              onRewardPressed: (_) {},
            ),
          ),
          brightness: brightness,
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/rewards_${brightness.name}.png'),
        );
      }),
    );

    testWidgets('points history, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 640);
      await pumpThemed(
        tester,
        Padding(
          padding: AppSpacing.screenH,
          child: PointsHistoryScrollView(
            state: PointsHistoryLoaded(
              entries: sampleEntries,
              total: sampleEntries.length,
              loadedPages: 1,
            ),
            onRefresh: () async {},
            onRetry: () {},
            onLoadMore: () {},
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/points_history_${brightness.name}.png'),
      );
    });

    for (final (name, redeem) in [
      ('reward_detail', const RedeemIdle() as RedeemState),
      ('reward_redeemed', RedeemDone(sampleVoucher)),
    ]) {
      testWidgets('$name, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: 900);
        await pumpThemed(
          tester,
          SingleChildScrollView(
            padding: AppSpacing.screenH,
            child: RewardDetailView(
              reward: sampleRewards.first,
              balance: 1240,
              redeem: redeem,
              onRedeemPressed: () {},
              onCopyPressed: (_) {},
            ),
          ),
          brightness: brightness,
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
        );
      });
    }

    testWidgets('my vouchers, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 400);
      await pumpThemed(
        tester,
        Padding(
          padding: AppSpacing.screenH,
          child: VouchersScrollView(
            state: VouchersLoaded(
              items: sampleVouchers,
              total: sampleVouchers.length,
              loadedPages: 1,
            ),
            onRefresh: () async {},
            onRetry: () {},
            onLoadMore: () {},
            onCopyPressed: (_) {},
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/my_vouchers_${brightness.name}.png'),
      );
    });
  }
}
