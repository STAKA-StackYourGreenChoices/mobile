import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// A one-time code typed into [length] boxes.
///
/// One real text field sits invisibly on top of the boxes, so typing,
/// pasting, the keyboard's "code from messages" suggestion
/// (`AutofillHints.oneTimeCode`) and screen readers all work as for any
/// field. [onCompleted] fires when the last digit is typed.
class AppOtpField extends StatefulWidget {
  const new({
    required this.label,
    required this.controller,
    required this.onCompleted,
    this.length = 6,
    this.hasError = false,
    this.isEnabled = true,
    super.key,
  });

  /// Read by screen readers, e.g. "6-digit code".
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final int length;
  final bool hasError;
  final bool isEnabled;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _focus.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(AppOtpField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  void _onChanged() {
    setState(() {});
    final code = widget.controller.text;
    if (code.length == widget.length) widget.onCompleted(code);
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.controller.text;
    // The box the next digit goes into (the last one once all are typed).
    final active = code.length.clamp(0, widget.length - 1);
    return Stack(
      children: [
        ExcludeSemantics(
          child: Row(
            spacing: AppSpacing.xs,
            children: [
              for (var i = 0; i < widget.length; i++)
                Expanded(
                  child: _DigitBox(
                    digit: i < code.length ? code[i] : '',
                    isActive: _focus.hasFocus && i == active,
                    hasError: widget.hasError,
                  ),
                ),
            ],
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            alwaysIncludeSemantics: true,
            child: Semantics(
              label: widget.label,
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                enabled: widget.isEnabled,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                showCursor: false,
                decoration: const InputDecoration.collapsed(hintText: null),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DigitBox extends StatelessWidget {
  const new({
    required this.digit,
    required this.isActive,
    required this.hasError,
  });

  final String digit;
  final bool isActive;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = switch ((hasError, isActive)) {
      (true, _) => colors.danger,
      (_, true) => colors.brandPrimary,
      _ => colors.borderStrong,
    };
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        digit,
        style: context.text.headingMedium.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
