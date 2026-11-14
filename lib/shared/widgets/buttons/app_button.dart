import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/buttons/app_button_content.dart';

enum AppButtonVariant {
  /// The one main action on a screen (filled, brand colour).
  primary,

  /// A second action next to a primary one (outlined).
  secondary,

  /// Low-emphasis actions such as "Turn camera off" (text only).
  ghost,

  /// Irreversible actions such as delete (filled, danger colour).
  destructive,
}

/// The app's only button. Sizes, radius and type come from the theme, so
/// every button is at least 48 dp tall (guide §12).
///
/// While [isLoading] it keeps its colour but ignores taps and keyboard
/// activation, and shows a spinner with [loadingLabel] ("Signing in…"),
/// like the website's submit buttons. A null [onPressed] greys it out.
class AppButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loadingLabel,
    this.isLoading = false,
    this.isExpanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final String? loadingLabel;
  final bool isLoading;

  /// Fills the available width, e.g. the submit button of a form.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Loading must not look disabled, so the button stays enabled with a
    // no-op action; IgnorePointer below stops taps from reaching it at all.
    final action = isLoading && onPressed != null ? _ignore : onPressed;
    final content = AppButtonContent(
      label: isLoading ? loadingLabel ?? label : label,
      icon: icon,
      isLoading: isLoading,
    );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: action,
        child: content,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: action,
        child: content,
      ),
      AppButtonVariant.ghost => TextButton(onPressed: action, child: content),
      AppButtonVariant.destructive => FilledButton(
        onPressed: action,
        style: FilledButton.styleFrom(
          backgroundColor: colors.danger,
          foregroundColor: colors.onDanger,
          textStyle: context.text.label,
        ),
        child: content,
      ),
    };

    final guarded = IgnorePointer(ignoring: isLoading, child: button);
    return isExpanded
        ? SizedBox(width: double.infinity, child: guarded)
        : guarded;
  }

  static void _ignore() {}
}
