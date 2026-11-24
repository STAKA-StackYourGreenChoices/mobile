import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/sharing/share_channels_controller.dart';
import 'package:staka/core/sharing/share_target.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// The link's QR code (with `?ch=qr`) to show someone, and to save as an
/// image from the share sheet (V2-4).
Future<void> showQrCodeSheet(BuildContext context, ShareTarget target) {
  final container = ProviderScope.containerOf(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: QrCodeSheet(target: target),
    ),
  );
}

class QrCodeSheet extends ConsumerWidget {
  const new({required this.target, super.key});

  final ShareTarget target;

  static const _size = 220.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = shareChannelsControllerProvider(target);
    // Watched, so the controller lives while the sheet is open.
    final channels = ref.watch(provider);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.channelQr, style: context.text.headingSmall),
            ),
            // Black on white in both themes: phone cameras read that best.
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.allMd,
                border: Border.all(color: context.colors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: QrImageView(
                  data: target.linkFor(ShareChannel.qr),
                  size: _size,
                  padding: EdgeInsets.zero,
                  semanticsLabel: l10n.qrCodeLabel,
                ),
              ),
            ),
            Text(
              l10n.qrCodeHint,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
            Builder(
              builder: (context) => AppButton(
                label: l10n.saveQrImage,
                loadingLabel: l10n.preparingImage,
                icon: Icons.download_rounded,
                isLoading: channels.preparing == SharePreparing.qr,
                onPressed: () {
                  final box = context.findRenderObject();
                  unawaited(
                    ref
                        .read(provider.notifier)
                        .saveQr(
                          origin: box is RenderBox && box.hasSize
                              ? box.localToGlobal(Offset.zero) & box.size
                              : null,
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
