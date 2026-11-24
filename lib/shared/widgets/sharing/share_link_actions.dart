import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/sharing/share_channels_controller.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// The buttons in the channel row (V2-4), in order.
enum ShareRowButton { whatsapp, instagram, copy, qr, more }

/// Callbacks for a live share link. The share ones get where the share
/// sheet should point from on iPad.
class ShareLinkCallbacks {
  const new({
    required this.onChannel,
    required this.onImage,
    required this.onOpen,
    required this.onStop,
  });

  final void Function(ShareRowButton button, Rect? origin) onChannel;
  final void Function(ShareImageFormat format, Rect? origin) onImage;
  final VoidCallback onOpen;

  /// Called after the shopper confirms.
  final VoidCallback onStop;
}

/// The link and everything that can be done with it, for a tag's link and
/// the whole wardrobe's: the channel row, the image formats, the public
/// page and stopping (V2-3, V2-4).
class ShareLinkActions extends StatelessWidget {
  const new({
    required this.url,
    required this.callbacks,
    required this.stopTitle,
    required this.stopBody,
    this.preparing = SharePreparing.none,
    this.isStopping = false,
    super.key,
  });

  final String url;
  final ShareLinkCallbacks callbacks;
  final SharePreparing preparing;
  final bool isStopping;

  /// The stop-sharing confirmation.
  final String stopTitle;
  final String stopBody;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        _LinkBox(url: url),
        _ChannelRow(
          isPreparingInstagram: preparing == SharePreparing.instagram,
          onPressed: callbacks.onChannel,
        ),
        const Divider(),
        Text(l10n.shareImagesTitle, style: context.text.label),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (format, label, icon, busy) in [
              (
                ShareImageFormat.story,
                l10n.storyImageFormat,
                Icons.crop_portrait_rounded,
                SharePreparing.story,
              ),
              (
                ShareImageFormat.square,
                l10n.postImageFormat,
                Icons.crop_square_rounded,
                SharePreparing.square,
              ),
            ])
              _WithOrigin(
                builder: (origin) => AppButton(
                  label: label,
                  loadingLabel: l10n.preparingImage,
                  icon: icon,
                  variant: AppButtonVariant.secondary,
                  isLoading: preparing == busy,
                  onPressed: () => callbacks.onImage(format, origin()),
                ),
              ),
          ],
        ),
        const Divider(),
        AppButton(
          label: l10n.seeWhatOthersSee,
          icon: Icons.open_in_new_rounded,
          variant: AppButtonVariant.ghost,
          onPressed: callbacks.onOpen,
        ),
        AppButton(
          label: l10n.stopSharing,
          loadingLabel: l10n.stoppingSharing,
          variant: AppButtonVariant.quietDestructive,
          isLoading: isStopping,
          onPressed: () => _confirmStop(context),
        ),
      ],
    );
  }

  Future<void> _confirmStop(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stopTitle),
        content: Text(stopBody),
        actions: [
          AppButton(
            label: l10n.keepSharing,
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton(
            label: l10n.stopSharing,
            variant: AppButtonVariant.destructive,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirmed ?? false) callbacks.onStop();
  }
}

/// WhatsApp, Instagram story, Copy link, QR code, More: one round button
/// each, label underneath.
class _ChannelRow extends StatelessWidget {
  const new({required this.isPreparingInstagram, required this.onPressed});

  final bool isPreparingInstagram;
  final void Function(ShareRowButton button, Rect? origin) onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (button, label, spoken, icon) in [
          (
            ShareRowButton.whatsapp,
            l10n.channelWhatsApp,
            l10n.channelWhatsApp,
            Icons.chat_rounded,
          ),
          (
            ShareRowButton.instagram,
            l10n.channelInstagram,
            l10n.channelInstagramStory,
            Icons.camera_alt_outlined,
          ),
          (
            ShareRowButton.copy,
            l10n.copyLink,
            l10n.copyLink,
            Icons.copy_rounded,
          ),
          (
            ShareRowButton.qr,
            l10n.channelQr,
            l10n.channelQr,
            Icons.qr_code_2_rounded,
          ),
          (
            ShareRowButton.more,
            l10n.channelMore,
            l10n.channelMore,
            Icons.more_horiz_rounded,
          ),
        ])
          Expanded(
            child: _WithOrigin(
              builder: (origin) => _ChannelButton(
                label: label,
                semanticLabel: spoken,
                icon: icon,
                isLoading:
                    button == ShareRowButton.instagram && isPreparingInstagram,
                onPressed: () => onPressed(button, origin()),
              ),
            ),
          ),
      ],
    );
  }
}

class _ChannelButton extends StatelessWidget {
  const new({
    required this.label,
    required this.semanticLabel,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;

  /// What screen readers say, when [label] is shortened to fit.
  final String semanticLabel;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onPressed;

  static const _circle = 48.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: AppRadius.allSm,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxs / 2,
            vertical: AppSpacing.xxs,
          ),
          child: Column(
            spacing: AppSpacing.xxs,
            children: [
              SizedBox.square(
                dimension: _circle,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox.square(
                            dimension: AppSizes.iconInline,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.brandPrimary,
                            ),
                          )
                        : Icon(
                            icon,
                            size: AppSizes.iconDefault,
                            color: colors.brandPrimary,
                          ),
                  ),
                ),
              ),
              // One line, shrunk rather than broken mid-word in a narrow
              // card.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label, maxLines: 1, style: context.text.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The public link, selectable so it can also be copied by hand.
class _LinkBox extends StatelessWidget {
  const new({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.shareLinkLabel,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceSunken,
        borderRadius: AppRadius.allSm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: SelectableText(url, style: context.text.bodyMedium),
      ),
    ),
  );
}

/// Gives a button the on-screen rectangle it occupies, for the iPad share
/// popover to point at.
class _WithOrigin extends StatelessWidget {
  const new({required this.builder});

  final Widget Function(Rect? Function() origin) builder;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) => builder(() {
      final box = context.findRenderObject();
      return box is RenderBox && box.hasSize
          ? box.localToGlobal(Offset.zero) & box.size
          : null;
    }),
  );
}
