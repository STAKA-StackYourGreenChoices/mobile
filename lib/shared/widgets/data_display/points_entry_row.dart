import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/layout/row_trailing.dart';

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
              RowTrailing(
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
