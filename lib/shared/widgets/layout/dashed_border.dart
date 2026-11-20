import 'dart:ui' show PathMetric;

import 'package:material_ui/material_ui.dart';

/// Dash pattern shared by every dashed line: the hang tag's stitching and
/// the website's dashed panels.
const _dash = 4.0;
const _gap = 3.0;

/// A dashed rounded-rectangle outline, painted around its child's box.
class DashedBorder extends StatelessWidget {
  const new({required this.color, this.radius = 0, this.child, super.key});

  final Color color;
  final double radius;
  final Widget? child;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _DashedRRectPainter(color: color, radius: radius),
    child: child,
  );
}

/// A full-width horizontal dashed rule, like the web's `border-dashed`.
class DashedDivider extends StatelessWidget {
  const new({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 1,
    width: double.infinity,
    child: CustomPaint(painter: _DashedRRectPainter(color: color, line: true)),
  );
}

class _DashedRRectPainter extends CustomPainter {
  const new({required this.color, this.radius = 0, this.line = false});

  final Color color;
  final double radius;
  final bool line;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = line
        ? (Path()
            ..moveTo(0, 0.5)
            ..lineTo(size.width, 0.5))
        : (Path()..addRRect(
            RRect.fromRectAndRadius(
              Offset.zero & size,
              Radius.circular(radius),
            ).deflate(0.5),
          ));
    for (final metric in path.computeMetrics()) {
      _drawDashes(canvas, metric, paint);
    }
  }

  void _drawDashes(Canvas canvas, PathMetric metric, Paint paint) {
    for (var d = 0.0; d < metric.length; d += _dash + _gap) {
      canvas.drawPath(metric.extractPath(d, d + _dash), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color || old.radius != radius || old.line != line;
}
