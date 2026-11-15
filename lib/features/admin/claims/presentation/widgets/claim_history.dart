import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';
import 'package:staka/shared/formatters/date_format.dart';

/// "All claims for this piece": each earlier and later claim, its outcome,
/// and the reason given, with the one under review marked.
class ClaimHistory extends StatelessWidget {
  const new({required this.history, required this.currentId, super.key});

  final List<Claim> history;
  final String currentId;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.sm,
    children: [
      Semantics(
        header: true,
        child: Text(context.l10n.allClaimsForPiece, style: context.text.label),
      ),
      for (final item in history)
        _HistoryItem(item: item, isCurrent: item.id == currentId),
    ],
  );
}

class _HistoryItem extends StatelessWidget {
  const new({required this.item, required this.isCurrent});

  final Claim item;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (icon, color) = switch (item.status) {
      ClaimStatus.approved => (Icons.verified_rounded, colors.success),
      ClaimStatus.rejected => (Icons.cancel_outlined, colors.dangerText),
      ClaimStatus.pending => (Icons.schedule_rounded, colors.brandPrimary),
    };
    final method = item.method == ClaimMethod.orderMatch
        ? l10n.methodOrderMatch
        : l10n.historyReceipt(item.receiptAttempt?.toString() ?? '');
    final title = '$method${isCurrent ? l10n.thisOne : ''}';
    final reviewed = switch (item.reviewedAt) {
      final at? => formatDate(at),
      null => '',
    };
    final by = switch (item.reviewedByName) {
      final name? => l10n.reviewedBy(name),
      null => '',
    };
    final outcome = switch (item.status) {
      ClaimStatus.pending => l10n.waitingSince(formatDate(item.createdAt)),
      ClaimStatus.approved => '${l10n.claimDecidedApproved(reviewed)}$by',
      ClaimStatus.rejected => '${l10n.claimDecidedRejected(reviewed)}$by',
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCurrent
            ? colors.brandPrimary.withValues(alpha: 0.08)
            : colors.surfaceRaised,
        border: Border.all(
          color: isCurrent
              ? colors.brandPrimary.withValues(alpha: 0.3)
              : colors.border,
        ),
        borderRadius: AppRadius.allSm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm - 2,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: AppSpacing.md, color: color),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.label),
                  Text(
                    outcome,
                    style: context.text.bodyMedium.copyWith(
                      color: colors.inkMuted,
                    ),
                  ),
                  if (item.rejectionReason case final reason?)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxs),
                      child: Text(
                        l10n.quotedText(reason),
                        style: context.text.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
