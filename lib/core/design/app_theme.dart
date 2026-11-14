import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_colors.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';

/// Assembles ThemeData from the tokens. Nothing else builds a ThemeData.
abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final type = AppTypography.standard();

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.surfaceBase,
      splashFactory: InkSparkle.splashFactory,

      // Material's own scheme still drives some built-in widgets, so keep it
      // aligned with our tokens rather than letting it fall back to purple.
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.brandPrimary,
        onPrimary: c.onBrandPrimary,
        secondary: c.brandSecondary,
        onSecondary: Colors.white,
        tertiary: c.accent,
        onTertiary: c.onAccent,
        error: c.danger,
        onError: c.onDanger,
        surface: c.surfaceRaised,
        onSurface: c.ink,
        surfaceContainerHighest: c.surfaceSunken,
        outline: c.border,
        outlineVariant: c.borderStrong,
      ),

      extensions: <ThemeExtension<dynamic>>[c, type.tinted(c)],

      textTheme: TextTheme(
        displayLarge: type.displayLarge.copyWith(color: c.ink),
        displayMedium: type.displayMedium.copyWith(color: c.ink),
        headlineLarge: type.headingLarge.copyWith(color: c.ink),
        headlineMedium: type.headingMedium.copyWith(color: c.ink),
        headlineSmall: type.headingSmall.copyWith(color: c.ink),
        bodyLarge: type.bodyLarge.copyWith(color: c.ink),
        bodyMedium: type.bodyMedium.copyWith(color: c.ink),
        bodySmall: type.bodySmall.copyWith(color: c.inkMuted),
        labelLarge: type.label.copyWith(color: c.ink),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: c.surfaceBase,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: type.headingLarge.copyWith(color: c.ink),
      ),

      cardTheme: CardThemeData(
        color: c.surfaceRaised,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.allMd,
          side: BorderSide(color: c.border),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.brandPrimary,
          foregroundColor: c.onBrandPrimary,
          minimumSize: const Size(0, AppSizes.minTapTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          textStyle: type.label,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.brandPrimary,
          minimumSize: const Size(0, AppSizes.minTapTarget),
          side: BorderSide(color: c.borderStrong),
          textStyle: type.label,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.brandPrimary,
          minimumSize: const Size(0, AppSizes.minTapTarget),
          textStyle: type.label,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceSunken,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        hintStyle: type.bodyLarge.copyWith(color: c.inkSubtle),
        labelStyle: type.label.copyWith(color: c.inkMuted),
        // dangerText, not danger — error copy must clear 4.5:1 on cream.
        errorStyle: type.bodySmall.copyWith(color: c.dangerText),
        border: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: c.brandPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: c.danger),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceSunken,
        side: BorderSide(color: c.border),
        labelStyle: type.label.copyWith(color: c.inkMuted),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceRaised,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: c.borderStrong,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      ),

      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.ink,
        contentTextStyle: type.bodyMedium.copyWith(color: c.surfaceBase),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surfaceRaised,
        selectedItemColor: c.brandPrimary,
        unselectedItemColor: c.inkSubtle,
        selectedLabelStyle: type.bodySmall,
        unselectedLabelStyle: type.bodySmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.brandPrimary,
        linearTrackColor: c.surfaceSunken,
      ),

      // Motion tokens: swap for a cross-fade under reduce-motion rather than
      // removing transitions entirely — an instant jump is disorienting.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
