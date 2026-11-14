import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/features/tags/presentation/widgets/status_panel.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Where the shopper stands on proving they own the piece — the website's
/// `OwnershipPanel`. Verified, under review and blocked are settled panels;
/// otherwise [proveOptions] (order match and receipt) are offered.
class OwnershipPanel extends StatelessWidget {
  const new({required this.ownership, required this.proveOptions, super.key});

  final Ownership ownership;
  final List<Widget> proveOptions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final left = l10n.uploadsLeft(ownership.receiptAttemptsLeft);
    return switch (ownership.status) {
      OwnershipStatus.verified => StatusPanel(
        tone: PanelTone.success,
        icon: Icons.verified_rounded,
        title: l10n.ownershipVerifiedTitle,
        body: _verifiedBody(l10n),
      ),
      OwnershipStatus.pending => StatusPanel(
        tone: PanelTone.info,
        icon: Icons.schedule_rounded,
        title: l10n.ownershipPending,
        body: switch (ownership.pendingSince) {
          final since? => l10n.pendingBody(formatDate(since), left),
          null => l10n.pendingBodyUndated(left),
        },
      ),
      OwnershipStatus.blocked => StatusPanel(
        tone: PanelTone.muted,
        icon: Icons.gpp_bad_outlined,
        title: l10n.blockedTitle,
        body: switch (ownership.lastRejectionReason) {
          final reason? => l10n.blockedBodyWithReason(reason),
          null => l10n.blockedBody,
        },
      ),
      OwnershipStatus.unverified || OwnershipStatus.rejected => _ProveOwnership(
        rejection: ownership.status == OwnershipStatus.rejected
            ? l10n.lastReceiptRejected(
                ownership.lastRejectionReason ?? l10n.noReasonGiven,
                left,
              )
            : null,
        options: proveOptions,
      ),
    };
  }

  String _verifiedBody(AppLocalizations l10n) {
    final date = switch (ownership.verifiedAt) {
      final at? => formatDate(at),
      null => null,
    };
    final byOrder = ownership.method == ClaimMethod.orderMatch;
    return switch ((byOrder, date)) {
      (true, final on?) => l10n.verifiedByOrderOn(on),
      (true, null) => l10n.verifiedByOrder,
      (false, final on?) => l10n.verifiedByReceiptOn(on),
      (false, null) => l10n.verifiedByReceipt,
    };
  }
}

/// "Prove you own it", with both ways to do it.
class _ProveOwnership extends StatelessWidget {
  const new({required this.options, this.rejection});

  final List<Widget> options;
  final String? rejection;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  Icons.policy_outlined,
                  size: AppSizes.iconInline,
                  color: colors.inkMuted,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xxs,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          l10n.proveTitle,
                          style: context.text.headingSmall,
                        ),
                      ),
                      Text(
                        l10n.proveLede,
                        style: context.text.bodySmall.copyWith(
                          color: colors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (rejection case final message?)
              AppFormAlert(message: message, tone: AlertTone.error),
            for (final option in options) ...[
              Divider(color: colors.border),
              option,
            ],
          ],
        ),
      ),
    );
  }
}
