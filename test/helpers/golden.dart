import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the real fonts (Plus Jakarta Sans, Manrope, Material Icons) so
/// goldens show actual type instead of the test font's boxes.
Future<void> loadAppFonts() async {
  final manifest = jsonDecode(
    await rootBundle.loadString('FontManifest.json'),
  ) as List<Object?>;
  for (final entry in manifest.cast<Map<String, Object?>>()) {
    final loader = FontLoader(entry['family']! as String);
    for (final font
        in (entry['fonts']! as List<Object?>).cast<Map<String, Object?>>()) {
      loader.addFont(rootBundle.load(font['asset']! as String));
    }
    await loader.load();
  }
}

/// Golden baselines are rendered on the developer's OS. Font rasterising
/// differs between Windows, macOS and Linux, so these run with
/// `flutter test --tags golden`, not in CI (see dart_test.yaml).
const goldenTag = 'golden';
