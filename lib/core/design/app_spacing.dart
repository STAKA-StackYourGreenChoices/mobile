import 'package:flutter/widgets.dart';

/// 4pt base grid. No magic numbers anywhere else in the codebase.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double huge = 64;

  /// Standard horizontal screen padding.
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: md);

  /// Standard card interior padding.
  static const EdgeInsets card = EdgeInsets.all(md);
}

/// Three radii, each meaning something. See guide §6.3.
abstract final class AppRadius {
  static const Radius sm = Radius.circular(8);
  static const Radius md = Radius.circular(16);
  static const Radius lg = Radius.circular(28);
  static const Radius full = Radius.circular(999);

  static const BorderRadius allSm = BorderRadius.all(sm);
  static const BorderRadius allMd = BorderRadius.all(md);
  static const BorderRadius allLg = BorderRadius.all(lg);
  static const BorderRadius allFull = BorderRadius.all(full);

  /// Bottom sheets: rounded top corners only.
  static const BorderRadius sheetTop = BorderRadius.only(
    topLeft: lg,
    topRight: lg,
  );
}

/// Minimum interactive target, per guide §12.
abstract final class AppSizes {
  static const double minTapTarget = 48;
  static const double iconInline = 20;
  static const double iconDefault = 24;
  static const double iconFeature = 32;
  static const double iconEmptyState = 48;

  /// Cap body prose line length on wide screens.
  static const double maxProseWidth = 640;
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 400);
}

abstract final class AppCurves {
  static const Curve fast = Curves.easeOut;
  static const Curve base = Curves.easeInOutCubic;
  static const Curve slow = Curves.easeInOutCubic;
}
