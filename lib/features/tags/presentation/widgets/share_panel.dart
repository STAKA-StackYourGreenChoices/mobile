import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/tags/presentation/state/share_controller.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/sharing/share_link_actions.dart';

/// "Share this tag": create the public link, then copy or share it, share
/// the story image, see the public page, or stop sharing — the website's
/// `SharePanel` for a verified piece.
class SharePanel extends StatelessWidget {
  const new({
    required this.onCreatePressed,
    required this.linkActions,
    this.url,
    this.busy = ShareBusy.none,
    this.errorMessage,
    this.footer,
    super.key,
  });

  /// The public link while the tag is shared; null when it isn't.
  final String? url;
  final ShareBusy busy;
  final String? errorMessage;
  final VoidCallback onCreatePressed;

  /// What to do with the link once it exists.
  final ShareLinkCallbacks linkActions;

  /// Below the link, e.g. "Show in my public wardrobe" (V2-3).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            const _ShareHeading(),
            if (errorMessage case final message?)
              AppFormAlert(message: message, tone: AlertTone.error),
            switch (url) {
              final link? => ShareLinkActions(
                url: link,
                callbacks: linkActions,
                stopTitle: l10n.stopSharingTitle,
                stopBody: l10n.stopSharingBody,
                isPreparingImage: busy == ShareBusy.preparingImage,
                isStopping: busy == ShareBusy.stopping,
              ),
              null => AppButton(
                label: l10n.createShareLink,
                loadingLabel: l10n.creatingLink,
                icon: Icons.link_rounded,
                isLoading: busy == ShareBusy.creating,
                onPressed: onCreatePressed,
              ),
            },
            ?footer,
          ],
        ),
      ),
    );
  }
}

class _ShareHeading extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Icon(
          Icons.share_outlined,
          size: AppSizes.iconInline,
          color: colors.success,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxs,
            children: [
              Semantics(
                header: true,
                child: Text(l10n.shareTitle, style: context.text.headingSmall),
              ),
              Text(
                l10n.shareBody,
                style: context.text.bodySmall.copyWith(color: colors.inkMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
