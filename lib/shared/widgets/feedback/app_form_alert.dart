import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

enum AlertTone { error, success }

/// The message above a form after it's submitted, e.g. "That email and
/// password don't match an account." Icon + text + colour, never colour
/// alone; announced to screen readers when it appears. The website's
/// `FormAlert`.
class AppFormAlert extends StatelessWidget {
  const new({required this.message, required this.tone, super.key});

  final String message;
  final AlertTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, color) = switch (tone) {
      AlertTone.error => (Icons.error_outline_rounded, colors.dangerText),
      AlertTone.success => (Icons.check_circle_outline_rounded, colors.success),
    };
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          border: Border.all(color: color.withValues(alpha: 0.35)),
          borderRadius: AppRadius.allSm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: AppSizes.iconInline, color: color),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  message,
                  style: context.text.bodyMedium.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
