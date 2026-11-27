import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/formatters/share_labels.dart';
import 'package:staka/shared/widgets/layout/row_trailing.dart';

/// One activity entry: an icon, what happened, when and how, and points
/// if any. Opens the tag when it's about one.
class ActivityRow extends StatelessWidget {
  const new({required this.item, this.onPressed, super.key});

  final ActivityItem item;

  /// Null when the entry is about no tag.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final details = [
      formatDate(item.at),
      if (item.channel case final channel?)
        l10n.activityVia(channelName(channel, l10n)),
    ].join(' · ');
    return MergeSemantics(
      child: InkWell(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  activityIcon(item.type),
                  size: AppSizes.iconDefault,
                  color: colors.inkMuted,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activitySentence(item, l10n),
                        style: context.text.bodyLarge,
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
                if (item.points case final points? when points != 0)
                  RowTrailing(
                    '${points > 0 ? '+' : '−'}'
                    '${l10n.pointsCount(points.abs())}',
                    style: context.text.label.copyWith(
                      color: points > 0 ? colors.success : colors.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// What happened, in a sentence. Share entries without a tag are about
/// the whole wardrobe.
String activitySentence(ActivityItem item, AppLocalizations l10n) {
  final product = item.productName ?? l10n.aPiece;
  final isWardrobe = item.cardId == null;
  return switch (item.type) {
    ActivityType.scan => l10n.activityScan(product),
    ActivityType.scanUnknown => l10n.activityScanUnknown,
    ActivityType.cardAdded => l10n.activityCardAdded(product),
    ActivityType.ownershipVerified => l10n.activityVerified(product),
    ActivityType.ownershipRejected => l10n.activityRejected(product),
    ActivityType.shareCreated =>
      isWardrobe ? l10n.activityWardrobeShared : l10n.activityShared(product),
    ActivityType.shareStopped =>
      isWardrobe
          ? l10n.activityWardrobeShareStopped
          : l10n.activityShareStopped(product),
    ActivityType.shareClicked =>
      isWardrobe
          ? l10n.activityWardrobeLinkSent
          : l10n.activityLinkSent(product),
    ActivityType.tagViewed => l10n.activityTagViewed(product),
    ActivityType.wardrobeViewed => l10n.activityWardrobeViewed,
    ActivityType.embedViewed => l10n.activityEmbedViewed(product),
    ActivityType.brandLinkClicked => l10n.activityBrandLinkClicked(product),
    ActivityType.pointsEarned => l10n.activityPointsEarned,
    ActivityType.voucherRedeemed => l10n.activityVoucherRedeemed,
    ActivityType.other => l10n.activityOther,
  };
}

IconData activityIcon(ActivityType type) => switch (type) {
  ActivityType.scan ||
  ActivityType.scanUnknown => Icons.qr_code_scanner_rounded,
  ActivityType.cardAdded => Icons.add_circle_outline_rounded,
  ActivityType.ownershipVerified => Icons.verified_outlined,
  ActivityType.ownershipRejected => Icons.error_outline_rounded,
  ActivityType.shareCreated ||
  ActivityType.shareStopped ||
  ActivityType.shareClicked => Icons.share_outlined,
  ActivityType.tagViewed ||
  ActivityType.wardrobeViewed ||
  ActivityType.embedViewed => Icons.visibility_outlined,
  ActivityType.brandLinkClicked => Icons.storefront_outlined,
  ActivityType.pointsEarned => Icons.stars_outlined,
  ActivityType.voucherRedeemed => Icons.redeem_rounded,
  ActivityType.other => Icons.history_rounded,
};
