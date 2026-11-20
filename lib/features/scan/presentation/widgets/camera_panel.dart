import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/scan/presentation/widgets/camera_message.dart';
import 'package:staka/features/scan/presentation/widgets/camera_phase.dart';
import 'package:staka/features/scan/presentation/widgets/scan_frame_overlay.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';

/// How the camera looks in each [phase]: the 3:4 viewfinder with its aiming
/// frame, a message instead of a picture when there is none, and a status
/// line under it that screen readers hear as it changes.
class CameraPanel extends StatelessWidget {
  const new({
    required this.phase,
    required this.preview,
    required this.onTurnOn,
    required this.onTurnOff,
    required this.onRetry,
    super.key,
  });

  final CameraPhase phase;

  /// The live camera picture.
  final Widget preview;
  final VoidCallback onTurnOn;
  final VoidCallback onTurnOff;
  final VoidCallback onRetry;

  bool get _isLive => switch (phase) {
    CameraStarting() || CameraScanning() || CameraFound() => true,
    _ => false,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = switch (phase) {
      CameraFound(:final gtin) => l10n.cameraFound(gtin),
      CameraScanning(:final notice) => notice ?? l10n.cameraLooking,
      CameraStarting() => l10n.cameraStarting,
      _ => null,
    };
    return Semantics(
      container: true,
      label: l10n.cameraRegion,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: AppRadius.allMd,
              child: ColoredBox(
                color: context.colors.mediaBackdrop,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_isLive) ExcludeSemantics(child: preview),
                    if (_isLive)
                      ScanFrameOverlay(isLooking: phase is CameraScanning),
                    if (phase is CameraStarting)
                      const AppLoader(size: AppLoaderSize.sm),
                    ?_messageFor(l10n),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              status ?? '',
              style: context.text.bodyMedium.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          ),
          if (phase is CameraScanning)
            AppButton(
              label: l10n.turnCameraOff,
              variant: AppButtonVariant.ghost,
              onPressed: onTurnOff,
            ),
        ],
      ),
    );
  }

  Widget? _messageFor(AppLocalizations l10n) => switch (phase) {
    CameraBlocked() => CameraMessage(
      message: l10n.cameraBlocked,
      actionLabel: l10n.tryAgain,
      onActionPressed: onRetry,
    ),
    CameraUnavailable(:final reason) => CameraMessage(
      message: l10n.cameraUnavailable(reason),
    ),
    CameraStopped() => CameraMessage(
      message: l10n.cameraOff,
      actionLabel: l10n.turnCameraOn,
      onActionPressed: onTurnOn,
    ),
    _ => null,
  };
}
