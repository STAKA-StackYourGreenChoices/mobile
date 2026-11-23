import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// "Resend code in 0:24", ticking each second, then "Resend code".
class ResendCodeButton extends StatefulWidget {
  const new({
    required this.availableAt,
    required this.now,
    required this.isSending,
    required this.onPressed,
    super.key,
  });

  final DateTime availableAt;

  /// The app clock (`clockProvider`), so tests control the countdown.
  final DateTime Function() now;
  final bool isSending;
  final VoidCallback onPressed;

  @override
  State<ResendCodeButton> createState() => _ResendCodeButtonState();
}

class _ResendCodeButtonState extends State<ResendCodeButton> {
  Timer? _ticker;

  Duration get _left => widget.availableAt.difference(widget.now());

  @override
  void initState() {
    super.initState();
    _startTicking();
  }

  @override
  void didUpdateWidget(ResendCodeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableAt != widget.availableAt) _startTicking();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicking() {
    _ticker?.cancel();
    if (_left <= Duration.zero) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_left <= Duration.zero) timer.cancel();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final left = _left;
    final isWaiting = left > Duration.zero;
    return AppButton(
      label: isWaiting
          ? l10n.resendCodeIn(_minutesSeconds(left))
          : l10n.resendCode,
      loadingLabel: l10n.resendingCode,
      variant: AppButtonVariant.ghost,
      isLoading: widget.isSending,
      onPressed: isWaiting ? null : widget.onPressed,
    );
  }

  /// "0:24". Rounded up, so it never shows "0:00" while still waiting.
  static String _minutesSeconds(Duration left) {
    final seconds = (left.inMilliseconds / 1000).ceil();
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }
}
