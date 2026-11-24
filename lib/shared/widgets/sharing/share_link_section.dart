import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/sharing/share_actions.dart';
import 'package:staka/core/sharing/share_channels_controller.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/sharing/qr_code_sheet.dart';
import 'package:staka/shared/widgets/sharing/share_link_actions.dart';

/// Connects [ShareLinkActions] to the phone and to the share-click events,
/// for a tag or the whole wardrobe (V2-4). The owner stops sharing through
/// [onStop].
class ShareLinkSection extends ConsumerWidget {
  const new({
    required this.target,
    required this.shareText,
    required this.shareSubject,
    required this.stopTitle,
    required this.stopBody,
    required this.onStop,
    this.isStopping = false,
    super.key,
  });

  final ShareTarget target;

  /// Sent with the link ("I own this …").
  final String shareText;
  final String shareSubject;
  final String stopTitle;
  final String stopBody;
  final VoidCallback onStop;
  final bool isStopping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = shareChannelsControllerProvider(target);
    final channels = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    ref.listen(provider, (previous, next) {
      final failure = next.failure;
      if (failure == null || identical(failure, previous?.failure)) return;
      AppSnackbar.show(
        context,
        message: messageForFailure(failure, l10n),
        tone: AlertTone.error,
      );
    });

    void cantOpen() => AppSnackbar.show(
      context,
      message: l10n.couldNotOpenLink,
      tone: AlertTone.error,
    );

    return ShareLinkActions(
      url: target.url,
      preparing: channels.preparing,
      isStopping: isStopping,
      stopTitle: stopTitle,
      stopBody: stopBody,
      callbacks: ShareLinkCallbacks(
        onChannel: (button, origin) async {
          switch (button) {
            case ShareRowButton.whatsapp:
              final opened = await controller.whatsApp(shareText);
              if (!opened && context.mounted) cantOpen();
            case ShareRowButton.instagram:
              await controller.instagram(text: shareText, origin: origin);
            case ShareRowButton.copy:
              await controller.copy();
              if (context.mounted) {
                AppSnackbar.show(context, message: l10n.linkCopied);
              }
            case ShareRowButton.qr:
              controller.qrShown();
              await showQrCodeSheet(context, target);
            case ShareRowButton.more:
              await controller.more(
                text: shareText,
                subject: shareSubject,
                origin: origin,
              );
          }
        },
        onImage: (format, origin) => unawaited(
          controller.image(format, text: shareText, origin: origin),
        ),
        onOpen: () async {
          final opened = await ref.read(shareActionsProvider).open(target.url);
          if (!opened && context.mounted) cantOpen();
        },
        onStop: onStop,
      ),
    );
  }
}
