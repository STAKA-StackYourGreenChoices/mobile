import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// One dispute in the list: the piece and brand (when the API sends the
/// claim), who asked and when, and the start of their message.
class DisputeRow extends StatelessWidget {
  const new({required this.dispute, required this.onPressed, super.key});

  final AdminDispute dispute;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final claim = dispute.claim;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    final title = switch (claim) {
      final claim? => l10n.disputeRowTitle(
        claim.product.name,
        claim.product.brandName,
      ),
      null => l10n.disputeRowUntitled,
    };
    final asked = l10n.disputeAsked(
      claim?.user.name ?? l10n.aShopper,
      formatDate(dispute.createdAt),
    );
    return MergeSemantics(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Text(title, style: context.text.label),
                    Text(asked, style: muted),
                    Text(
                      dispute.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: muted,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.colors.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}
