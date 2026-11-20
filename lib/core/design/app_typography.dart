import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_colors.dart';

/// The ONLY file permitted to construct TextStyle from scratch.
///
/// Two families, distinct roles (guide §6.2):
///   Plus Jakarta Sans — all UI text and headings
///   Manrope          — numerals in data display ONLY, tabular figures on
///
/// Usage in widgets:  context.text.bodyLarge
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const new({
    required this.displayLarge,
    required this.displayMedium,
    required this.headingLarge,
    required this.headingMedium,
    required this.headingSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.label,
    required this.numeric,
    required this.numericLarge,
  });
  factory standard() => const AppTypography(
    displayLarge: TextStyle(
      fontFamily: _ui,
      fontSize: 40,
      fontWeight: FontWeight.w800,
      height: 42 / 40,
      letterSpacing: -0.8,
    ),
    displayMedium: TextStyle(
      fontFamily: _ui,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 36 / 32,
      letterSpacing: -0.48,
    ),
    headingLarge: TextStyle(
      fontFamily: _ui,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 30 / 24,
      letterSpacing: -0.24,
    ),
    headingMedium: TextStyle(
      fontFamily: _ui,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 26 / 20,
      letterSpacing: -0.1,
    ),
    headingSmall: TextStyle(
      fontFamily: _ui,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 23 / 17,
    ),
    bodyLarge: TextStyle(
      fontFamily: _ui,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 25 / 16,
    ),
    bodyMedium: TextStyle(
      fontFamily: _ui,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 23 / 15,
    ),
    bodySmall: TextStyle(
      fontFamily: _ui,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 20 / 13,
      letterSpacing: 0.065,
    ),
    label: TextStyle(
      fontFamily: _ui,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 18 / 14,
      letterSpacing: 0.14,
    ),
    numeric: TextStyle(
      fontFamily: _num,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 20 / 15,
      fontFeatures: _tabular,
    ),
    numericLarge: TextStyle(
      fontFamily: _num,
      fontSize: 40,
      fontWeight: FontWeight.w800,
      height: 42 / 40,
      letterSpacing: -0.8,
      fontFeatures: _tabular,
    ),
  );

  static const _ui = 'PlusJakartaSans';
  static const _num = 'Manrope';

  /// Digits keep a constant advance width so a ticking balance doesn't jitter.
  static const _tabular = <FontFeature>[FontFeature.tabularFigures()];

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle headingLarge;
  final TextStyle headingMedium;
  final TextStyle headingSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle label;
  final TextStyle numeric;
  final TextStyle numericLarge;

  /// Applies the theme's ink colours to the scale.
  AppTypography tinted(AppColors colors) => AppTypography(
    displayLarge: displayLarge.copyWith(color: colors.ink),
    displayMedium: displayMedium.copyWith(color: colors.ink),
    headingLarge: headingLarge.copyWith(color: colors.ink),
    headingMedium: headingMedium.copyWith(color: colors.ink),
    headingSmall: headingSmall.copyWith(color: colors.ink),
    bodyLarge: bodyLarge.copyWith(color: colors.ink),
    bodyMedium: bodyMedium.copyWith(color: colors.ink),
    bodySmall: bodySmall.copyWith(color: colors.inkMuted),
    label: label.copyWith(color: colors.ink),
    numeric: numeric.copyWith(color: colors.ink),
    numericLarge: numericLarge.copyWith(color: colors.ink),
  );

  @override
  AppTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? headingLarge,
    TextStyle? headingMedium,
    TextStyle? headingSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? numeric,
    TextStyle? numericLarge,
  }) {
    return AppTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      headingLarge: headingLarge ?? this.headingLarge,
      headingMedium: headingMedium ?? this.headingMedium,
      headingSmall: headingSmall ?? this.headingSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
      numeric: numeric ?? this.numeric,
      numericLarge: numericLarge ?? this.numericLarge,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    TextStyle s(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AppTypography(
      displayLarge: s(displayLarge, other.displayLarge),
      displayMedium: s(displayMedium, other.displayMedium),
      headingLarge: s(headingLarge, other.headingLarge),
      headingMedium: s(headingMedium, other.headingMedium),
      headingSmall: s(headingSmall, other.headingSmall),
      bodyLarge: s(bodyLarge, other.bodyLarge),
      bodyMedium: s(bodyMedium, other.bodyMedium),
      bodySmall: s(bodySmall, other.bodySmall),
      label: s(label, other.label),
      numeric: s(numeric, other.numeric),
      numericLarge: s(numericLarge, other.numericLarge),
    );
  }
}

/// The two accessors every widget uses. Nothing else reaches into Theme.
extension AppThemeAccess on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppTypography get text => Theme.of(this).extension<AppTypography>()!;
}
