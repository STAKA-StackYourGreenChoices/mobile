import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/rewards/domain/brand_reward.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';

/// Live, starts later, ended or switched off: icon, words and colour.
class BrandRewardStatusPill extends StatelessWidget {
  const new({required this.reward, required this.now, super.key});

  final BrandReward reward;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (icon, label, color) = switch (reward) {
      BrandReward(isActive: false) => (
        Icons.pause_circle_outline_rounded,
        l10n.rewardStatusOff,
        colors.inkMuted,
      ),
      _ when reward.hasEnded(now) => (
        Icons.event_busy_outlined,
        l10n.rewardStatusEnded,
        colors.inkMuted,
      ),
      _ when reward.startsLater(now) => (
        Icons.schedule_rounded,
        l10n.rewardStatusScheduled(formatDate(reward.startsAt)),
        colors.warning,
      ),
      _ => (
        Icons.check_circle_outline_rounded,
        l10n.rewardStatusLive,
        colors.success,
      ),
    };
    return StatusPill(icon: icon, label: label, color: color);
  }
}

/// "From 1 Dec 2026" or "1 Dec 2026 to 31 Mar 2027".
String rewardRunText(BrandReward reward, AppLocalizations l10n) =>
    switch (reward.endsAt) {
      final ends? => l10n.rewardRunsFromTo(
        formatDate(reward.startsAt),
        formatDate(ends),
      ),
      null => l10n.rewardRunsFrom(formatDate(reward.startsAt)),
    };

/// One reward in the Brand tab's list.
class BrandRewardRow extends StatelessWidget {
  const new({
    required this.reward,
    required this.now,
    required this.onPressed,
    super.key,
  });

  final BrandReward reward;
  final DateTime now;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return InkWell(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Text(reward.title, style: context.text.bodyLarge),
                    Text(
                      [
                        reward.valueText,
                        l10n.pointsCount(reward.pointsCost),
                        rewardRunText(reward, l10n),
                      ].join(' · '),
                      style: context.text.bodySmall.copyWith(
                        color: colors.inkMuted,
                      ),
                    ),
                    BrandRewardStatusPill(reward: reward, now: now),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Codes left, uploaded and redeemed.
class RewardStatsCard extends StatelessWidget {
  const new({required this.stats, super.key});

  final RewardStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    Widget figure(String label, int value) => Expanded(
      child: MergeSemantics(
        child: Column(
          children: [
            Text(
              NumberFormat.decimalPattern().format(value),
              style: context.text.headingMedium,
            ),
            Text(
              label,
              style: context.text.bodySmall.copyWith(color: colors.inkMuted),
            ),
          ],
        ),
      ),
    );
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.rewardStatsTitle,
                style: context.text.headingSmall,
              ),
            ),
            Row(
              children: [
                figure(l10n.rewardCodesLeft, stats.codesLeft),
                figure(l10n.rewardCodesTotal, stats.codesTotal),
                figure(l10n.rewardRedeemedCount, stats.redeemed),
              ],
            ),
            if (stats.codesLeft == 0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: AppSizes.iconInline,
                    color: colors.warning,
                  ),
                  Expanded(
                    child: Text(
                      l10n.noCodesLeft,
                      style: context.text.bodySmall,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
