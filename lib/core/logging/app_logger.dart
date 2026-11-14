import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// The app's only logger (guide §18 bans `print`). Silent in release builds.
///
/// Never pass tokens, emails, receipt contents or tag ids (guide §15).
abstract final class AppLogger {
  static void debug(String message, {String name = 'staka'}) {
    if (kReleaseMode) return;
    developer.log(message, name: name);
  }
}
