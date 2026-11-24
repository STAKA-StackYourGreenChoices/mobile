import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/rewards/domain/points.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// The balance at the top of the Rewards tab, what expires next, and the
/// way to the history.
class PointsBalanceCard extends StatelessWidget {
  const new({required this.page, required this.onHistoryPressed, super.key});

  final PointsPage page;
  final VoidCallback onHistoryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppSpacing.card,
            child: MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(
                    l10n.pointsBalanceLabel,
                    style: context.text.label.copyWith(color: colors.inkMuted),
                  ),
                  // One text, so "points" wraps under a long balance.
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.decimalPattern().format(
                            page.balance,
                          ),
                          style: context.text.numericLarge,
                        ),
                        TextSpan(
                          text: ' ${l10n.pointsUnit(page.balance)}',
                          style: context.text.bodyLarge.copyWith(
                            color: colors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if ((page.expiringPoints, page.expiringOn)
                      case (final points, final on?) when points > 0)
                    Row(
                      spacing: AppSpacing.xxs,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: AppSizes.iconInline,
                          color: colors.warning,
                        ),
                        Expanded(
                          child: Text(
                            l10n.pointsExpireOn(points, formatDate(on)),
                            style: context.text.bodySmall.copyWith(
                              color: colors.inkMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          InkWell(
            onTap: onHistoryPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.pointsSeeHistory,
                      style: context.text.label.copyWith(
                        color: colors.brandPrimary,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colors.brandPrimary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "How to earn": each active rule with its points.
class EarnRulesCard extends StatelessWidget {
  const new({required this.rules, super.key});

  final List<EarnRule> rules;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.howToEarn, style: context.text.headingSmall),
            ),
            for (final rule in rules)
              MergeSemantics(
                child: Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Icon(
                      pointsIcon(rule.reason),
                      size: AppSizes.iconDefault,
                      color: colors.inkMuted,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earnRuleText(rule.reason, l10n),
                            style: context.text.bodyMedium,
                          ),
                          if (rule.dailyCap case final cap?)
                            Text(
                              l10n.earnDailyCap(cap),
                              style: context.text.bodySmall.copyWith(
                                color: colors.inkMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '+${l10n.pointsCount(rule.points)}',
                      style: context.text.label.copyWith(color: colors.success),
                    ),
                  ],
                ),
              ),
            Text(
              l10n.pointsSmallPrint,
              style: context.text.bodySmall.copyWith(color: colors.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// One line of the history: what happened, when, and the points.
class PointsEntryRow extends StatelessWidget {
  const new({required this.entry, super.key});

  final PointsEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final details = [
      formatDate(entry.at),
      if (entry.expiresAt case final expires? when entry.delta > 0)
        l10n.pointsExpiresOn(formatDate(expires)),
    ].join(' · ');
    final delta = entry.delta;
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(
                pointsIcon(entry.reason),
                size: AppSizes.iconDefault,
                color: colors.inkMuted,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pointsEntryText(entry, l10n),
                      style: context.text.bodyLarge,
                    ),
                    if (entry.note case final note? when note.isNotEmpty)
                      Text(
                        note,
                        style: context.text.bodySmall.copyWith(
                          color: colors.inkMuted,
                        ),
                      ),
                    Text(
                      details,
                      style: context.text.bodySmall.copyWith(
                        color: colors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${delta >= 0 ? '+' : '−'}${l10n.pointsCount(delta.abs())}',
                style: context.text.label.copyWith(
                  color: delta > 0 ? colors.success : colors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String earnRuleText(PointsReason reason, AppLocalizations l10n) =>
    switch (reason) {
      PointsReason.pieceVerified => l10n.earnPieceVerified,
      PointsReason.firstShare => l10n.earnFirstShare,
      PointsReason.wardrobeShared => l10n.earnWardrobeShared,
      PointsReason.views => l10n.earnViews,
      PointsReason.phoneVerified => l10n.earnPhoneVerified,
      _ => l10n.pointsOther,
    };

String pointsEntryText(PointsEntry entry, AppLocalizations l10n) {
  final product = entry.productName ?? l10n.aPiece;
  return switch (entry.reason) {
    PointsReason.pieceVerified => l10n.pointsForVerified(product),
    PointsReason.firstShare => l10n.pointsForShare(product),
    PointsReason.wardrobeShared => l10n.pointsForWardrobeShare,
    PointsReason.views => l10n.pointsForViews(product),
    PointsReason.phoneVerified => l10n.pointsForPhone,
    PointsReason.redeemed => switch (entry.rewardTitle) {
      final title? => l10n.pointsUsedFor(title),
      null => l10n.pointsUsedForReward,
    },
    PointsReason.reversed => l10n.pointsTakenBack(product),
    PointsReason.expired => l10n.pointsExpired,
    PointsReason.adjusted => l10n.pointsAdjusted,
    PointsReason.other => l10n.pointsOther,
  };
}

IconData pointsIcon(PointsReason reason) => switch (reason) {
  PointsReason.pieceVerified => Icons.verified_outlined,
  PointsReason.firstShare ||
  PointsReason.wardrobeShared => Icons.share_outlined,
  PointsReason.views => Icons.visibility_outlined,
  PointsReason.phoneVerified => Icons.phone_iphone_rounded,
  PointsReason.redeemed => Icons.redeem_rounded,
  PointsReason.reversed => Icons.undo_rounded,
  PointsReason.expired => Icons.schedule_rounded,
  PointsReason.adjusted => Icons.tune_rounded,
  PointsReason.other => Icons.stars_outlined,
};
