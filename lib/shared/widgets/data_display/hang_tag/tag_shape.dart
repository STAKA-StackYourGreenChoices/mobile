import 'package:material_ui/material_ui.dart';

/// Geometry of the hang tag, from the website's `HangTag` (clip-path and
/// mask). Shape constants, not spacing tokens.
abstract final class TagGeometry {
  /// Chamfered top corners: the top edge runs from 16 % to 84 % of the
  /// width and the sides start 8 % of the height down.
  static const chamferX = 0.16;
  static const chamferY = 0.08;

  /// The punched hole: centre 26 dp from the top, radius 7.
  static const holeCenterY = 26.0;
  static const holeRadius = 7.0;

  /// The reinforcement ring around the hole.
  static const ringTop = 14.0;
  static const ringSize = 24.0;
  static const ringWidth = 3.0;

  /// The dashed stitch line, inset from the edges.
  static const stitchInset = EdgeInsets.fromLTRB(10, 48, 10, 10);
  static const stitchRadius = 6.0;

  /// Content starts below the hole and the stitch's top edge.
  static const contentTop = 56.0;
}

/// The tag's silhouette with the hole punched through (even-odd fill), used
/// both to clip and to cast the shadow, so the shadow follows the cut.
class TagClipper extends CustomClipper<Path> {
  const new();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(w * TagGeometry.chamferX, 0)
      ..lineTo(w * (1 - TagGeometry.chamferX), 0)
      ..lineTo(w, h * TagGeometry.chamferY)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..lineTo(0, h * TagGeometry.chamferY)
      ..close()
      ..addOval(
        Rect.fromCircle(
          center: Offset(w / 2, TagGeometry.holeCenterY),
          radius: TagGeometry.holeRadius,
        ),
      );
  }

  @override
  bool shouldReclip(TagClipper oldClipper) => false;
}

/// The string the tag hangs from, drawn above it (web: a cubic curve in a
/// 40 × 96 box that overlaps the tag by 30).
class TagString extends StatelessWidget {
  const new({required this.color, super.key});

  static const size = Size(40, 96);
  static const overlap = 30.0;

  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(size: size, painter: _StringPainter(color)),
  );
}

class _StringPainter extends CustomPainter {
  const new(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / TagString.size.width;
    final sy = size.height / TagString.size.height;
    final path = Path()
      ..moveTo(20 * sx, 0)
      ..cubicTo(6 * sx, 30 * sy, 34 * sx, 52 * sy, 20 * sx, 92 * sy);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_StringPainter old) => old.color != color;
}
