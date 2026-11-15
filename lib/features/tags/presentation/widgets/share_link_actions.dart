import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/tags/presentation/state/share_controller.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// Callbacks for a live share link. The share ones get where the share
/// sheet should point from on iPad.
class ShareLinkCallbacks {
  const new({
    required this.onCopy,
    required this.onShare,
    required this.onStoryImage,
    required this.onOpen,
    required this.onStop,
  });

  final VoidCallback onCopy;
  final ValueChanged<Rect?> onShare;
  final ValueChanged<Rect?> onStoryImage;
  final VoidCallback onOpen;

  /// Called after the shopper confirms.
  final VoidCallback onStop;
}

/// The link and everything that can be done with it.
class ShareLinkActions extends StatelessWidget {
  const new({
    required this.url,
    required this.busy,
    required this.callbacks,
    super.key,
  });

  final String url;
  final ShareBusy busy;
  final ShareLinkCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        _LinkBox(url: url),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _WithOrigin(
              builder: (origin) => AppButton(
                label: l10n.shareEllipsis,
                icon: Icons.ios_share_rounded,
                onPressed: () => callbacks.onShare(origin()),
              ),
            ),
            AppButton(
              label: l10n.copyLink,
              icon: Icons.copy_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: callbacks.onCopy,
            ),
          ],
        ),
        const Divider(),
        _WithOrigin(
          builder: (origin) => AppButton(
            label: l10n.storyImage,
            loadingLabel: l10n.preparingImage,
            icon: Icons.photo_outlined,
            variant: AppButtonVariant.ghost,
            isLoading: busy == ShareBusy.preparingImage,
            onPressed: () => callbacks.onStoryImage(origin()),
          ),
        ),
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
          isLoading: busy == ShareBusy.stopping,
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
        title: Text(l10n.stopSharingTitle),
        content: Text(l10n.stopSharingBody),
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
