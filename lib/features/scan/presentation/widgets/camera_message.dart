import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// Shown inside the camera frame when there is no picture: blocked,
/// unavailable or turned off, with the action that fixes it if any.
class CameraMessage extends StatelessWidget {
  const new({
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final onBackdrop = context.colors.onMediaBackdrop;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: [
            Icon(
              Icons.no_photography_outlined,
              size: AppSizes.iconFeature,
              color: onBackdrop,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium.copyWith(color: onBackdrop),
            ),
            if ((actionLabel, onActionPressed) case (
              final label?,
              final onPressed?,
            ))
              AppButton(
                label: label,
                icon: Icons.photo_camera_outlined,
                onPressed: onPressed,
              ),
          ],
        ),
      ),
    );
  }
}
