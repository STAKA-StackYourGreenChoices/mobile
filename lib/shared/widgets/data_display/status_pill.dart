import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// A status as a pill: icon + label + colour, never colour alone (guide
/// §6.1 law 3). Used by the ownership and brand application chips.
class StatusPill extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;

  /// Text and icon colour; the fill and border are tints of it. Must reach
  /// 4.5:1 on the surface as small text.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: AppRadius.allFull,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm - AppSpacing.xxs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xxs,
          children: [
            Icon(icon, size: AppSpacing.md, color: color),
            Flexible(
              child: Text(
                label,
                style: context.text.bodySmall.copyWith(
                  color: color,
                  fontWeight: context.text.label.fontWeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
