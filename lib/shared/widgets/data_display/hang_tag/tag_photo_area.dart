import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The 4:3 photo window on the tag. `AspectRatio` keeps the tag from
/// jumping when a photo loads (guide §6.4). Without a photo it says so
/// instead of showing an empty box.
class TagPhotoArea extends StatelessWidget {
  const new({this.image, super.key});

  final Widget? image;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 4 / 3,
    child: ClipRRect(
      borderRadius: AppRadius.allSm,
      child: ColoredBox(
        color: context.colors.surfaceSunken,
        child: image ?? const _NoPhoto(),
      ),
    ),
  );
}

class _NoPhoto extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) =>
      PhotoPlaceholder(message: context.l10n.noPhotoYet);
}

/// A garment icon and a short line, centred in a photo frame: "No photo
/// yet", or "Image unavailable" when a photo fails to load. Scales down
/// rather than overflow the 4:3 frame at large text sizes (guide §6.2).
class PhotoPlaceholder extends StatelessWidget {
  const new({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.inkMuted;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xxs,
            children: [
              Icon(
                Icons.checkroom_rounded,
                size: AppSizes.iconFeature,
                color: muted,
              ),
              Text(
                message,
                style: context.text.bodySmall.copyWith(color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
