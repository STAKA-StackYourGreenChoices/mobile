import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';

/// Icon (or spinner) plus label inside an `AppButton`. Colours are inherited
/// from the button, so it works on every variant and both themes.
class AppButtonContent extends StatelessWidget {
  const new({
    required this.label,
    required this.isLoading,
    this.icon,
    super.key,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final leading = isLoading
        ? const _ButtonSpinner()
        : switch (icon) {
            final icon? => Icon(icon, size: AppSizes.iconInline),
            null => null,
          };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: AppSpacing.xs)],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    // The button's current foreground colour (also correct when disabled).
    final color = DefaultTextStyle.of(context).style.color;
    return SizedBox.square(
      dimension: AppSizes.iconInline - AppSpacing.xxs,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
