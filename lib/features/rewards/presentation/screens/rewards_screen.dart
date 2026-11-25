import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/rewards/domain/points.dart';
import 'package:staka/features/rewards/domain/reward.dart';
import 'package:staka/features/rewards/presentation/state/points_controllers.dart';
import 'package:staka/features/rewards/presentation/state/rewards_controllers.dart';
import 'package:staka/features/rewards/presentation/widgets/points_widgets.dart';
import 'package:staka/features/rewards/presentation/widgets/reward_widgets.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Rewards tab: the points balance, what expires next, the history
/// (V2-6), the vouchers to swap them for (V2-7), and how to earn more.
class RewardsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(pointsOverviewProvider);
    return AppScaffold(
      isScrollable: false,
      body: RewardsScrollView(
        overview: switch (overview) {
          AsyncData(:final value) => value,
          _ => null,
        },
        catalog: switch (ref.watch(rewardsCatalogProvider)) {
          AsyncData(:final value) => value,
          _ => null,
        },
        rules: ref.watch(earnRulesProvider).value,
        onRefresh: () async {
          ref
            ..invalidate(earnRulesProvider)
            ..invalidate(rewardsCatalogProvider)
            ..invalidate(pointsOverviewProvider);
          await ref.read(pointsOverviewProvider.future);
        },
        onRetry: () => ref.invalidate(pointsOverviewProvider),
        onCatalogRetry: () => ref.invalidate(rewardsCatalogProvider),
        onHistoryPressed: () => context.goNamed(AppRoute.rewardsHistory.name),
        onRewardPressed: (reward) => context.goNamed(
          AppRoute.rewardDetail.name,
          pathParameters: {'id': reward.id},
        ),
      ),
    );
  }
}

class RewardsScrollView extends StatelessWidget {
  const new({
    required this.overview,
    required this.onRefresh,
    required this.onRetry,
    required this.onHistoryPressed,
    required this.onCatalogRetry,
    required this.onRewardPressed,
    this.catalog,
    this.rules,
    super.key,
  });

  /// Null while loading.
  final Result<PointsPage>? overview;

  /// "How to earn"; null hides it.
  final List<EarnRule>? rules;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onHistoryPressed;

  /// The vouchers; null while loading.
  final Result<List<Reward>>? catalog;
  final VoidCallback onCatalogRetry;
  final ValueChanged<Reward> onRewardPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.rewardsTitle, style: context.text.headingLarge),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.rewardsBody,
            style: context.text.bodyLarge.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          switch (overview) {
            null => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: AppLoader(),
            ),
            Err(:final Failure failure) => AppErrorState(
              failure: failure,
              onRetryPressed: onRetry,
            ),
            Ok(:final value) => PointsBalanceCard(
              page: value,
              onHistoryPressed: onHistoryPressed,
            ),
          },
          const SizedBox(height: AppSpacing.lg),
          Semantics(
            header: true,
            child: Text(
              l10n.rewardsCatalogTitle,
              style: context.text.headingMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          switch (catalog) {
            null => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: AppLoader(),
            ),
            Err(:final Failure failure) => AppErrorState(
              failure: failure,
              onRetryPressed: onCatalogRetry,
            ),
            Ok(value: []) => AppEmptyState(
              icon: Icons.redeem_outlined,
              title: l10n.rewardsCatalogEmptyTitle,
              message: l10n.rewardsCatalogEmptyBody,
            ),
            Ok(:final value) => RewardsGrid(
              rewards: value,
              balance: switch (overview) {
                Ok(:final value) => value.balance,
                _ => null,
              },
              onRewardPressed: onRewardPressed,
            ),
          },
          if (rules case final rules? when rules.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            EarnRulesCard(rules: rules),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
