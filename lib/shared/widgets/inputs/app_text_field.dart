import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/inputs/password_visibility_button.dart';

/// Label above, input, hint and error below: the website's `TextField`.
///
/// [errorText] is an error from the server (e.g. "An account already uses
/// this email") and wins over [validator]. The label and field are merged
/// for screen readers, so the field is announced by its label.
class AppTextField extends StatefulWidget {
  const new({
    required this.label,
    this.controller,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.onSubmitted,
    this.maxLines = 1,
    this.isPassword = false,
    this.isEnabled = true,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;

  /// Obscured, with a show/hide button.
  final bool isPassword;
  final bool isEnabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final obscure = widget.isPassword && _isObscured;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: context.text.label),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            forceErrorText: widget.errorText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            onFieldSubmitted: widget.onSubmitted,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            enabled: widget.isEnabled,
            obscureText: obscure,
            autocorrect: !widget.isPassword,
            enableSuggestions: !widget.isPassword,
            style: context.text.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              helperText: widget.helperText,
              helperMaxLines: 3,
              errorMaxLines: 3,
              suffixIcon: widget.isPassword
                  ? PasswordVisibilityButton(
                      isObscured: _isObscured,
                      onPressed: () =>
                          setState(() => _isObscured = !_isObscured),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
