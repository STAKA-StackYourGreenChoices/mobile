import 'package:material_ui/material_ui.dart';

/// The text at the end of a list row (a points amount, a date): as wide as
/// it needs, but never more than a third of the screen, so 200% text wraps
/// it instead of pushing the row past the edge. At normal sizes it looks
/// like a plain [Text].
class RowTrailing extends StatelessWidget {
  const new(this.text, {required this.style, super.key});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width / 3,
      ),
      // Wrapped lines line up on the end. One line can sit a fraction of a
      // pixel off where a plain Text would (invisible; goldens re-baselined).
      child: Text(text, style: style, textAlign: TextAlign.end),
    );
  }
}
