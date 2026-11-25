@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/manage/rewards/data/brand_rewards_repository.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';
import 'package:staka/features/manage/rewards/presentation/screens/brand_reward_form_screen.dart';
import 'package:staka/features/manage/rewards/presentation/screens/brand_reward_screen.dart';
import 'package:staka/features/manage/rewards/presentation/screens/brand_rewards_screen.dart';
import 'package:staka/features/manage/rewards/presentation/state/brand_rewards_controllers.dart';

import '../../helpers/brand_rewards_fakes.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('brand rewards, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 640);
      await pumpThemed(
        tester,
        Padding(
          padding: AppSpacing.screenH,
          child: BrandRewardsView(
            rewards: Ok(sampleBrandRewards),
            now: rewardsNow,
            tab: BrandRewardsTab.active,
            onTabSelected: (_) {},
            onRefresh: () async {},
            onRetry: () {},
            onNewPressed: () {},
            onRewardPressed: (_) {},
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/brand_rewards_${brightness.name}.png'),
      );
    });

    testWidgets(
      'brand reward, ${brightness.name}',
      (tester) => withRealShadows(() async {
        usePhoneScreen(tester, height: 960);
        await pumpThemed(
          tester,
          SingleChildScrollView(
            padding: AppSpacing.screenH,
            child: BrandRewardView(
              reward: sampleBrandRewards.first,
              now: rewardsNow,
              stats: sampleStats,
              upload: const CodesUploadDone(
                'codes.csv',
                CodesUploadReport(added: 120, duplicates: 3),
              ),
              onUploadPressed: () {},
            ),
          ),
          brightness: brightness,
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/brand_reward_${brightness.name}.png'),
        );
      }),
    );

    testWidgets('brand reward form, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 1300);
      await pumpThemed(
        tester,
        ProviderScope(
          overrides: [
            clockProvider.overrideWithValue(() => rewardsNow),
            brandRewardsRepositoryProvider.overrideWithValue(
              FakeBrandRewardsRepository(),
            ),
          ],
          child: SingleChildScrollView(
            padding: AppSpacing.screenH,
            child: BrandRewardForm(
              brandId: 'b1',
              reward: sampleBrandRewards.first,
            ),
          ),
        ),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/brand_reward_form_${brightness.name}.png'),
      );
    });
  }
}
