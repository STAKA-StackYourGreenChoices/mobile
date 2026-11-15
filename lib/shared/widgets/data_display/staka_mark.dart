import 'package:material_ui/material_ui.dart';

/// STAKA's mark: the hang-tag glyph from the website's wordmark (viewBox
/// 16 x 22), the same shape as the app icon. [height] sets its size.
class StakaMark extends StatelessWidget {
  const new({required this.color, this.height = 72, super.key});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: height * 16 / 22,
    height: height,
    child: CustomPaint(painter: _MarkPainter(color)),
  );
}

class _MarkPainter extends CustomPainter {
  const new(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.height / 22;
    final tag = Path()
      ..moveTo(3 * s, 0)
      ..lineTo(13 * s, 0)
      ..lineTo(16 * s, 3 * s)
      ..lineTo(16 * s, 20 * s)
      ..arcToPoint(Offset(14 * s, 22 * s), radius: Radius.circular(2 * s))
      ..lineTo(2 * s, 22 * s)
      ..arcToPoint(Offset(0, 20 * s), radius: Radius.circular(2 * s))
      ..lineTo(0, 3 * s)
      ..close()
      ..addOval(Rect.fromCircle(center: Offset(8 * s, 6 * s), radius: 1.8 * s))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(tag, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}
