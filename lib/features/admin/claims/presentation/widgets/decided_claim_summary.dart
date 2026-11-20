import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// "Approved 14 Nov 2026 by Sam", and the reason given for a rejection.
class DecidedClaimSummary extends StatelessWidget {
  const new({required this.claim, super.key});

  final Claim claim;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isApproved = claim.status == ClaimStatus.approved;
    final color = isApproved
        ? context.colors.success
        : context.colors.dangerText;
    final date = switch (claim.reviewedAt) {
      final at? => formatDate(at),
      null => '',
    };
    final by = switch (claim.reviewedByName) {
      final name? => l10n.reviewedBy(name),
      null => '',
    };
    final outcome = isApproved
        ? l10n.claimDecidedApproved(date)
        : l10n.claimDecidedRejected(date);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: AppRadius.allMd,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg - AppSpacing.xxs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xs,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Icon(
                  isApproved ? Icons.verified_rounded : Icons.cancel_outlined,
                  size: AppSizes.iconInline,
                  color: color,
                ),
                Expanded(child: Text('$outcome$by', style: context.text.label)),
              ],
            ),
            if (claim.rejectionReason case final reason?)
              Text(l10n.reasonGiven(reason), style: context.text.bodyMedium),
          ],
        ),
      ),
    );
  }
}
