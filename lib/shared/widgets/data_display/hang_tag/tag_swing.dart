import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';

/// The tag's one moment of motion (web DESIGN.md principle 4): it swings
/// once from its string when it first appears, like card stock on a rail.
/// Same keyframes as the website's `tag-swing`. Under reduce-motion it
/// cross-fades in instead (guide §6.3: never "nothing").
class TagSwing extends StatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  /// The website's 1.4 s: longer than the motion tokens on purpose, because
  /// this is the app's signature moment (guide §6.3, "one orchestrated
  /// moment").
  static const duration = Duration(milliseconds: 1400);

  @override
  State<TagSwing> createState() => _TagSwingState();
}

class _TagSwingState extends State<TagSwing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;

  static double _deg(double degrees) => degrees * math.pi / 180;

  /// -7° → 4° → -2° → 0°, at 0 %, 35 %, 65 %, 100 %.
  static final _angle = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: _deg(-7), end: _deg(4)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: _deg(4), end: _deg(-2)),
      weight: 30,
    ),
    TweenSequenceItem(tween: Tween(begin: _deg(-2), end: 0), weight: 35),
  ]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _curved = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.3, 0.8, 0.3, 1),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isAnimating || _controller.isCompleted) return;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    _controller
      ..duration = reduceMotion ? AppDurations.base : TagSwing.duration
      ..forward();
  }

  @override
  void dispose() {
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return FadeTransition(opacity: _controller, child: widget.child);
    }
    return AnimatedBuilder(
      animation: _curved,
      builder: (_, child) => Transform.rotate(
        angle: _angle.evaluate(_curved),
        alignment: Alignment.topCenter,
        child: child,
      ),
      child: widget.child,
    );
  }
}
