import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// A short confirmation after an action ("Brand deleted", "Link copied"),
/// replacing the website's toasts. Styled by the theme's snackBarTheme;
/// the icon keeps the tone readable without colour (guide §6.1 law 3).
abstract final class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    AlertTone tone = AlertTone.success,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    final foreground = context.colors.surfaceBase;
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon ??
                  (tone == AlertTone.success
                      ? Icons.check_circle_outline_rounded
                      : Icons.error_outline_rounded),
              color: foreground,
              size: AppSizes.iconInline,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
        action: switch ((actionLabel, onAction)) {
          (final label?, final onPressed?) => SnackBarAction(
            label: label,
            onPressed: onPressed,
          ),
          _ => null,
        },
      ),
    );
  }
}
