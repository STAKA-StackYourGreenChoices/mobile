import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';

/// The eye button inside a password field. Icon-only, so it carries a
/// label (guide §7.1 rule 8) and keeps the 48 dp tap target.
class PasswordVisibilityButton extends StatelessWidget {
  const new({required this.isObscured, required this.onPressed, super.key});

  final bool isObscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = isObscured
        ? context.l10n.showPassword
        : context.l10n.hidePassword;
    return IconButton(
      onPressed: onPressed,
      tooltip: label,
      icon: Icon(
        isObscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
      ),
    );
  }
}
