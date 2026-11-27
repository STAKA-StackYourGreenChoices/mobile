import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/data_display/points_entry_row.dart';
import 'package:staka/shared/widgets/layout/row_trailing.dart';

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
                    RowTrailing(
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
