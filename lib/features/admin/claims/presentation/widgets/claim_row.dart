import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';
import 'package:staka/features/admin/claims/presentation/widgets/claim_labels.dart';
import 'package:staka/features/admin/products/presentation/widgets/product_thumbnail.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// One claim in the list: the piece, who claims it, how, and when (sent
/// while waiting, decided otherwise). Opens the review page.
class ClaimRow extends StatelessWidget {
  const new({required this.claim, required this.onPressed, super.key});

  final Claim claim;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    final date = claim.status == ClaimStatus.pending
        ? claim.createdAt
        : claim.reviewedAt;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductThumbnail(imageUrl: claim.product.imageUrl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs - 2,
                  children: [
                    Text(
                      claim.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.label,
                    ),
                    Text(
                      switch (claim.user.email) {
                        final email? => l10n.claimUserLine(
                          claim.user.name,
                          email,
                        ),
                        null => claim.user.name,
                      },
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: muted,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.claimMethodLabel(claim),
                            style: muted,
                          ),
                        ),
                        if (date != null) Text(formatDate(date), style: muted),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
