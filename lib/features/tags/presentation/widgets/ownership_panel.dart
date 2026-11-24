import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/features/tags/presentation/widgets/look_again_section.dart';
import 'package:staka/features/tags/presentation/widgets/status_panel.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Where the shopper stands on proving they own the piece — the website's
/// `OwnershipPanel`. Verified, under review and blocked are settled panels;
/// otherwise [proveOptions] (order match and receipt) are offered. Names
/// who decided the receipt when the API says (the brand or STAKA), and
/// after a brand's rejection offers [onAskToLookAgainPressed].
class OwnershipPanel extends StatelessWidget {
  const new({
    required this.ownership,
    required this.proveOptions,
    this.onAskToLookAgainPressed,
    super.key,
  });

  final Ownership ownership;
  final List<Widget> proveOptions;
  final VoidCallback? onAskToLookAgainPressed;

  /// Who decided, as a name to start a sentence with; null when unknown
  /// (the API before V2-12), and the older wording is used.
  String? _decider(AppLocalizations l10n) => switch (ownership.decidedBy) {
    ClaimDecider.brand => ownership.brandName,
    ClaimDecider.admin => l10n.appName,
    null => null,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final left = l10n.uploadsLeft(ownership.receiptAttemptsLeft);
    final decider = _decider(l10n);
    final brand = ownership.brandName;
    final lookAgain =
        LookAgainSection.showsFor(
          ownership,
          canAsk: onAskToLookAgainPressed != null,
        )
        ? LookAgainSection(
            ownership: ownership,
            onAskPressed: onAskToLookAgainPressed,
          )
        : null;
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
        body: switch ((ownership.pendingSince, brand)) {
          (final since?, final brand?) => l10n.pendingForBrand(
            formatDate(since),
            brand,
            left,
          ),
          (null, final brand?) => l10n.pendingForBrandUndated(brand, left),
          (final since?, null) => l10n.pendingBody(formatDate(since), left),
          (null, null) => l10n.pendingBodyUndated(left),
        },
      ),
      OwnershipStatus.blocked => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          StatusPanel(
            tone: PanelTone.muted,
            icon: Icons.gpp_bad_outlined,
            title: l10n.blockedTitle,
            body: switch ((ownership.lastRejectionReason, decider)) {
              (final reason?, final who?) => l10n.blockedBodyBy(who, reason),
              (final reason?, null) => l10n.blockedBodyWithReason(reason),
              (null, _) => l10n.blockedBody,
            },
          ),
          ?lookAgain,
        ],
      ),
      OwnershipStatus.unverified || OwnershipStatus.rejected => _ProveOwnership(
        rejection: ownership.status == OwnershipStatus.rejected
            ? _rejection(l10n, decider, left)
            : null,
        lookAgain: lookAgain,
        options: proveOptions,
      ),
    };
  }

  String _rejection(AppLocalizations l10n, String? decider, String left) {
    final reason = ownership.lastRejectionReason ?? l10n.noReasonGiven;
    return switch (decider) {
      final who? => l10n.receiptRejectedBy(who, reason, left),
      null => l10n.lastReceiptRejected(reason, left),
    };
  }

  String _verifiedBody(AppLocalizations l10n) {
    final date = switch (ownership.verifiedAt) {
      final at? => formatDate(at),
      null => null,
    };
    if (ownership.method == ClaimMethod.orderMatch) {
      return switch (date) {
        final on? => l10n.verifiedByOrderOn(on),
        null => l10n.verifiedByOrder,
      };
    }
    if (ownership.dispute?.status == DisputeStatus.overturned) {
      return l10n.verifiedAfterLookAgain;
    }
    return switch ((_decider(l10n), date)) {
      (final who?, final on?) => l10n.verifiedByDeciderOn(who, on),
      (final who?, null) => l10n.verifiedByDecider(who),
      (null, final on?) => l10n.verifiedByReceiptOn(on),
      (null, null) => l10n.verifiedByReceipt,
    };
  }
}

/// "Prove you own it", with both ways to do it.
class _ProveOwnership extends StatelessWidget {
  const new({required this.options, this.rejection, this.lookAgain});

  final List<Widget> options;
  final String? rejection;

  /// "Ask STAKA to look again", or where that stands, under [rejection].
  final Widget? lookAgain;

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
            ?lookAgain,
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
