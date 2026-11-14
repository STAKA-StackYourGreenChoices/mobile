import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// The aiming frame over the camera: a wide box (suits 1D barcodes and still
/// fits a QR code), the rest dimmed, four corner marks and, while looking,
/// a line across the middle — the website's scanner overlay.
class ScanFrameOverlay extends StatelessWidget {
  const new({required this.isLooking, super.key});

  final bool isLooking;

  /// Web: 78 % wide (at most 440), 38 % tall.
  static const _widthFactor = 0.78;
  static const _heightFactor = 0.38;
  static const _maxWidth = 440.0;
  static const _corner = 28.0;
  static const _stroke = 3.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, box) {
          final width = (box.maxWidth * _widthFactor).clamp(0.0, _maxWidth);
          final height = box.maxHeight * _heightFactor;
          final frame = Rect.fromCenter(
            center: box.biggest.center(Offset.zero),
            width: width,
            height: height,
          );
          return CustomPaint(
            size: box.biggest,
            painter: _FramePainter(
              frame: frame,
              dim: colors.mediaBackdrop.withValues(alpha: 0.45),
              cornerColor: colors.onMediaBackdrop,
              lineColor: isLooking ? colors.accent : null,
            ),
          );
        },
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  const new({
    required this.frame,
    required this.dim,
    required this.cornerColor,
    this.lineColor,
  });

  final Rect frame;
  final Color dim;
  final Color cornerColor;
  final Color? lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(frame, AppRadius.sm);
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Offset.zero & size)
        ..addRRect(rrect),
      Paint()..color = dim,
    );

    final corner = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ScanFrameOverlay._stroke
      ..strokeCap = StrokeCap.round;
    const c = ScanFrameOverlay._corner;
    for (final (origin, dx, dy) in [
      (frame.topLeft, 1.0, 1.0),
      (frame.topRight, -1.0, 1.0),
      (frame.bottomLeft, 1.0, -1.0),
      (frame.bottomRight, -1.0, -1.0),
    ]) {
      canvas
        ..drawLine(origin, origin.translate(c * dx, 0), corner)
        ..drawLine(origin, origin.translate(0, c * dy), corner);
    }

    if (lineColor case final color?) {
      final y = frame.center.dy;
      canvas.drawLine(
        Offset(frame.left + AppSpacing.sm, y),
        Offset(frame.right - AppSpacing.sm, y),
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_FramePainter old) =>
      old.frame != frame ||
      old.dim != dim ||
      old.cornerColor != cornerColor ||
      old.lineColor != lineColor;
}
