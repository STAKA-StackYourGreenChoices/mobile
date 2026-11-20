import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_colors.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/sustainability_info.dart';

/// Whether a product's figures are verified, brand-stated or missing: the
/// website's `SustainabilityBadge`. [isCompact] shows only the icon in a
/// circle (phone rows) and is announced as "Figures: Verified".
class SustainabilityBadge extends StatelessWidget {
  const new({required this.info, this.isCompact = false, super.key});

  final SustainabilityInfo? info;
  final bool isCompact;

  /// The website's `size-8` compact circle.
  static const double _compactSize = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (icon, label, color) = _style(info, l10n, context.colors);
    final decoration = BoxDecoration(
      color: color.withValues(alpha: 0.08),
      border: Border.all(color: color.withValues(alpha: 0.35)),
      borderRadius: AppRadius.allFull,
    );
    final glyph = Icon(icon, size: AppSpacing.md - 2, color: color);

    if (isCompact) {
      return Semantics(
        label: l10n.figuresBadgeLabel(label),
        excludeSemantics: true,
        child: Tooltip(
          message: l10n.figuresBadgeLabel(label),
          child: Container(
            width: _compactSize,
            height: _compactSize,
            decoration: decoration,
            alignment: Alignment.center,
            child: glyph,
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm - 2,
          vertical: AppSpacing.xxs - 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs - 2,
          children: [
            glyph,
            Text(
              label,
              style: context.text.bodySmall.copyWith(
                color: color,
                fontWeight: context.text.label.fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static (IconData, String, Color) _style(
    SustainabilityInfo? info,
    AppLocalizations l10n,
    AppColors colors,
  ) => switch (info) {
    null => (
      Icons.radio_button_unchecked_rounded,
      l10n.figuresMissing,
      colors.warning,
    ),
    SustainabilityInfo(isVerified: true) => (
      Icons.verified_rounded,
      l10n.figuresVerified,
      colors.success,
    ),
    SustainabilityInfo() => (
      Icons.info_outline_rounded,
      l10n.figuresBrandStated,
      colors.inkMuted,
    ),
  };
}
