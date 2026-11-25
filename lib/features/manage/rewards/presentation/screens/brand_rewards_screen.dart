import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';
import 'package:staka/features/manage/rewards/presentation/state/brand_rewards_controllers.dart';
import 'package:staka/features/manage/rewards/presentation/widgets/brand_reward_widgets.dart';
import 'package:staka/features/manage/shared/widgets/status_tabs.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

enum BrandRewardsTab { active, ended }

/// Brand → Rewards (V2-7): the brand's rewards, Active or Ended / off, and
/// New reward.
class BrandRewardsScreen extends ConsumerStatefulWidget {
  const new({required this.brandId, super.key});

  final String brandId;

  @override
  ConsumerState<BrandRewardsScreen> createState() => _BrandRewardsState();
}

class _BrandRewardsState extends ConsumerState<BrandRewardsScreen> {
  BrandRewardsTab _tab = BrandRewardsTab.active;

  @override
  Widget build(BuildContext context) {
    final provider = brandRewardsProvider(widget.brandId);
    return AppScaffold(
      title: context.l10n.brandRewardsTitle,
      isScrollable: false,
      body: BrandRewardsView(
        rewards: ref.watch(provider).value,
        now: ref.watch(clockProvider)(),
        tab: _tab,
        onTabSelected: (tab) => setState(() => _tab = tab),
        onRefresh: () async {
          ref.invalidate(provider);
          await ref.read(provider.future);
        },
        onRetry: () => ref.invalidate(provider),
        onNewPressed: () => context.goNamed(AppRoute.brandRewardNew.name),
        onRewardPressed: (reward) => context.goNamed(
          AppRoute.brandReward.name,
          pathParameters: {'id': reward.id},
        ),
      ),
    );
  }
}

class BrandRewardsView extends StatelessWidget {
  const new({
    required this.rewards,
    required this.now,
    required this.tab,
    required this.onTabSelected,
    required this.onRefresh,
    required this.onRetry,
    required this.onNewPressed,
    required this.onRewardPressed,
    super.key,
  });

  /// Null while loading.
  final Result<List<BrandReward>>? rewards;
  final DateTime now;
  final BrandRewardsTab tab;
  final ValueChanged<BrandRewardsTab> onTabSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onNewPressed;
  final ValueChanged<BrandReward> onRewardPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shown = switch (rewards) {
      Ok(:final value) => [
        for (final reward in value)
          if (reward.isRunning(now) == (tab == BrandRewardsTab.active)) reward,
      ],
      _ => const <BrandReward>[],
    };
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          AppButton(
            label: l10n.newReward,
            icon: Icons.add_rounded,
            isExpanded: true,
            onPressed: onNewPressed,
          ),
          const SizedBox(height: AppSpacing.md),
          StatusTabs<BrandRewardsTab>(
            values: BrandRewardsTab.values,
            labelOf: (tab) => switch (tab) {
              BrandRewardsTab.active => l10n.brandRewardsActive,
              BrandRewardsTab.ended => l10n.brandRewardsEnded,
            },
            selected: tab,
            onSelected: onTabSelected,
            semanticsLabel: l10n.brandRewardsTabs,
            count: rewards is Ok ? shown.length : null,
          ),
          switch (rewards) {
            null => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: AppLoader(),
            ),
            Err(:final failure) => AppErrorState(
              failure: failure,
              onRetryPressed: onRetry,
            ),
            Ok() when shown.isEmpty => switch (tab) {
              BrandRewardsTab.active => AppEmptyState(
                icon: Icons.redeem_outlined,
                title: l10n.noActiveRewardsTitle,
                message: l10n.noActiveRewardsBody,
              ),
              BrandRewardsTab.ended => AppEmptyState(
                icon: Icons.event_busy_outlined,
                title: l10n.noEndedRewardsTitle,
                message: l10n.noEndedRewardsBody,
              ),
            },
            Ok() => Column(
              children: [
                for (final (index, reward) in shown.indexed) ...[
                  if (index > 0) const Divider(height: 1),
                  BrandRewardRow(
                    reward: reward,
                    now: now,
                    onPressed: () => onRewardPressed(reward),
                  ),
                ],
              ],
            ),
          },
        ],
      ),
    );
  }
}
