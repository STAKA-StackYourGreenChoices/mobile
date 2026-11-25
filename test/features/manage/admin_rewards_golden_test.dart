@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/rewards/presentation/screens/admin_rewards_screen.dart';
import 'package:staka/features/manage/rewards/presentation/screens/reward_rules_screen.dart';
import 'package:staka/features/manage/users/presentation/admin_user_screen.dart';

import '../../helpers/admin_rewards_fakes.dart';
import '../../helpers/brand_rewards_fakes.dart';
import '../../helpers/golden.dart';
import '../../helpers/points_fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  final cases = <String, (Widget, double)>{
    'admin_rewards': (
      AdminRewardsView(
        rewards: Ok(sampleAdminRewards),
        now: rewardsNow,
        onRefresh: () async {},
        onRetry: () {},
        switchOffButton: (_) => TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.pause_circle_outline_rounded),
          label: const Text('Switch off'),
        ),
      ),
      900,
    ),
    'reward_rules': (
      RewardRulesView(
        rules: const Ok(sampleRewardRules),
        onRetry: () {},
        onRulePressed: (_) {},
      ),
      640,
    ),
    'admin_user': (
      SingleChildScrollView(
        child: AdminUserView(
          user: sampleAdminUsers.first,
          points: Ok(samplePoints()),
          onAdjustPressed: () {},
        ),
      ),
      1000,
    ),
  };

  for (final MapEntry(key: name, value: (view, height)) in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '$name, ${brightness.name}',
        (tester) => withRealShadows(() async {
          usePhoneScreen(tester, height: height);
          await pumpThemed(
            tester,
            Padding(padding: AppSpacing.screenH, child: view),
            brightness: brightness,
          );
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
          );
        }),
      );
    }
  }
}
