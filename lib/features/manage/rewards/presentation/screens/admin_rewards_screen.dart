import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/manage/rewards/data/admin_rewards_repository.dart';
import 'package:staka/features/manage/rewards/presentation/state/admin_rewards_controllers.dart';
import 'package:staka/features/manage/rewards/presentation/widgets/brand_reward_widgets.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Admin → Rewards (V2-7): every brand's rewards, read-only, with Switch
/// off for one that shouldn't be on the Rewards tab.
class AdminRewardsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.brandRewardsTitle,
      isScrollable: false,
      body: AdminRewardsView(
        rewards: ref.watch(adminRewardsProvider).value,
        now: ref.watch(clockProvider)(),
        onRefresh: () async {
          ref.invalidate(adminRewardsProvider);
          await ref.read(adminRewardsProvider.future);
        },
        onRetry: () => ref.invalidate(adminRewardsProvider),
        switchOffButton: (item) => _SwitchOffButton(item: item),
      ),
    );
  }
}

class AdminRewardsView extends StatelessWidget {
  const new({
    required this.rewards,
    required this.now,
    required this.onRefresh,
    required this.onRetry,
    required this.switchOffButton,
    super.key,
  });

  /// Null while loading.
  final Result<List<AdminReward>>? rewards;
  final DateTime now;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  /// Under each running reward.
  final Widget Function(AdminReward item) switchOffButton;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Text(
            l10n.adminRewardsDescription,
            style: context.text.bodyLarge.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          switch (rewards) {
            null => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: AppLoader(),
            ),
            Err(:final failure) => AppErrorState(
              failure: failure,
              onRetryPressed: onRetry,
            ),
            Ok(value: []) => AppEmptyState(
              icon: Icons.redeem_outlined,
              title: l10n.noRewardsYetTitle,
              message: l10n.noRewardsYetBody,
            ),
            Ok(:final value) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, item) in value.indexed) ...[
                  if (index > 0) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxs,
                      children: [
                        Text(
                          item.brandName,
                          style: context.text.bodySmall.copyWith(
                            color: colors.inkMuted,
                          ),
                        ),
                        Text(item.reward.title, style: context.text.bodyLarge),
                        Text(
                          [
                            item.reward.valueText,
                            l10n.pointsCount(item.reward.pointsCost),
                            rewardRunText(item.reward, l10n),
                          ].join(' · '),
                          style: context.text.bodySmall.copyWith(
                            color: colors.inkMuted,
                          ),
                        ),
                        // Wraps under large text instead of overflowing.
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: AppSpacing.sm,
                          children: [
                            BrandRewardStatusPill(
                              reward: item.reward,
                              now: now,
                            ),
                            if (item.reward.isRunning(now))
                              switchOffButton(item),
                          ],
                        ),
                      ],
                    ),
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

class _SwitchOffButton extends ConsumerWidget {
  const new({required this.item});

  final AdminReward item;

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.switchOffRewardTitle),
        content: Text(
          l10n.switchOffRewardBody(item.reward.title, item.brandName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.switchOff),
          ),
        ],
      ),
    );
    if (yes != true || !context.mounted) return;
    await ref
        .read(rewardSwitchOffControllerProvider(item.reward.id).notifier)
        .switchOff();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = rewardSwitchOffControllerProvider(item.reward.id);
    ref.listen(provider, (_, next) {
      switch (next) {
        case RequestDone():
          AppSnackbar.show(context, message: l10n.rewardSwitchedOff);
        case RequestFailed(:final failure):
          AppSnackbar.show(
            context,
            message: messageForFailure(failure, l10n),
            tone: AlertTone.error,
          );
        case RequestIdle() || RequestSending():
          break;
      }
    });
    final isSending = ref.watch(provider) is RequestSending;
    return TextButton.icon(
      onPressed: isSending ? null : () => unawaited(_confirm(context, ref)),
      icon: const Icon(Icons.pause_circle_outline_rounded),
      label: Text(l10n.switchOff),
      style: TextButton.styleFrom(foregroundColor: context.colors.dangerText),
    );
  }
}
