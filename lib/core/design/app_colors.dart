import 'package:material_ui/material_ui.dart';

/// The ONLY file in the codebase permitted to contain colour literals.
///
/// Palette: Fresh Greens — 386641 / 6A994E / A7C957 / F2E8CF / BC4749
/// Every contrast ratio in the comments is WCAG 2.1 and was computed,
/// not guessed.
///
/// Usage in widgets:  context.colors.brandPrimary
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const new({
    required this.surfaceBase,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.ink,
    required this.inkMuted,
    required this.inkSubtle,
    required this.brandPrimary,
    required this.onBrandPrimary,
    required this.brandSecondary,
    required this.accent,
    required this.onAccent,
    required this.success,
    required this.danger,
    required this.onDanger,
    required this.dangerText,
    required this.warning,
  });

  // ---------------------------------------------------------------- raw ramp
  // Derived from the brand primary #386641. Do not reference these directly
  // from feature code — go through the semantic tokens below.
  static const forest900 = Color(0xFF192E1D); // 11.88 on cream
  static const forest800 = Color(0xFF24422A); //  9.12
  static const forest700 = Color(0xFF2E5435); //  7.07
  static const forest600 = Color(0xFF386641); //  5.48  brand primary
  static const forest500 = Color(0xFF5C8263); //  3.57  large text / icons only
  static const forest400 = Color(0xFF84A089); //  2.34  decorative
  static const forest300 = Color(0xFFAFC2B3);
  static const forest200 = Color(0xFFD3DDD5);
  static const forest100 = Color(0xFFEBF0EC);

  static const sage = Color(0xFF6A994E); // fill only — 2.74 on cream
  static const lime = Color(0xFFA7C957); // never white text — 1.89
  static const cream = Color(0xFFF2E8CF);
  static const brick = Color(0xFFBC4749);

  // ------------------------------------------------------------------ light
  static const light = AppColors(
    surfaceBase: cream,
    surfaceRaised: Color(0xFFFBF6EA),
    surfaceSunken: Color(0xFFE5D9BC),
    border: Color(0xFFDCCFB0),
    borderStrong: Color(0xFFC9BB9B),
    ink: Color(0xFF1B2E20), // 11.81 AAA
    inkMuted: Color(0xFF4A5B4D), //  5.95 AA
    inkSubtle: Color(0xFF6B7A6E), //  3.72 large text only
    brandPrimary: forest600, //  5.48 AA
    onBrandPrimary: Color(0xFFFFFFFF), //  6.68 on brandPrimary
    brandSecondary: sage, // FILL ONLY
    accent: lime,
    onAccent: forest900, //  7.64 on accent
    success: forest700,
    danger: brick,
    onDanger: Color(0xFFFFFFFF), //  5.08 on danger
    dangerText: Color(0xFF8C3335), //  6.52 on cream — use for danger TEXT
    warning: Color(0xFFA03D3F), //  5.32 on cream
  );

  // ------------------------------------------------------------------- dark
  static const dark = AppColors(
    surfaceBase: Color(0xFF0F1611),
    surfaceRaised: Color(0xFF1C271F),
    surfaceSunken: Color(0xFF141C16),
    border: Color(0xFF26332A),
    borderStrong: Color(0xFF33422F),
    ink: cream, // 14.26 AAA
    inkMuted: Color(0xFF9FB8A5), //  8.18 AA
    inkSubtle: Color(0xFF7A8F80),
    brandPrimary: lime, //  9.74 on base
    onBrandPrimary: Color(0xFF0F1611),
    brandSecondary: sage,
    accent: lime,
    onAccent: Color(0xFF0F1611),
    success: lime,
    danger: Color(0xFFE86B6D), //  5.59 — brick is too dark on dark
    onDanger: Color(0xFF0F1611),
    dangerText: Color(0xFFE86B6D),
    warning: Color(0xFFE0A05C),
  );

  final Color surfaceBase;
  final Color surfaceRaised;
  final Color surfaceSunken;
  final Color border;
  final Color borderStrong;
  final Color ink;
  final Color inkMuted;
  final Color inkSubtle;
  final Color brandPrimary;
  final Color onBrandPrimary;
  final Color brandSecondary;
  final Color accent;
  final Color onAccent;
  final Color success;
  final Color danger;
  final Color onDanger;
  final Color dangerText;
  final Color warning;

  @override
  AppColors copyWith({
    Color? surfaceBase,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? ink,
    Color? inkMuted,
    Color? inkSubtle,
    Color? brandPrimary,
    Color? onBrandPrimary,
    Color? brandSecondary,
    Color? accent,
    Color? onAccent,
    Color? success,
    Color? danger,
    Color? onDanger,
    Color? dangerText,
    Color? warning,
  }) {
    return AppColors(
      surfaceBase: surfaceBase ?? this.surfaceBase,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      inkSubtle: inkSubtle ?? this.inkSubtle,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      onBrandPrimary: onBrandPrimary ?? this.onBrandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerText: dangerText ?? this.dangerText,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      surfaceBase: c(surfaceBase, other.surfaceBase),
      surfaceRaised: c(surfaceRaised, other.surfaceRaised),
      surfaceSunken: c(surfaceSunken, other.surfaceSunken),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      ink: c(ink, other.ink),
      inkMuted: c(inkMuted, other.inkMuted),
      inkSubtle: c(inkSubtle, other.inkSubtle),
      brandPrimary: c(brandPrimary, other.brandPrimary),
      onBrandPrimary: c(onBrandPrimary, other.onBrandPrimary),
      brandSecondary: c(brandSecondary, other.brandSecondary),
      accent: c(accent, other.accent),
      onAccent: c(onAccent, other.onAccent),
      success: c(success, other.success),
      danger: c(danger, other.danger),
      onDanger: c(onDanger, other.onDanger),
      dangerText: c(dangerText, other.dangerText),
      warning: c(warning, other.warning),
    );
  }
}
