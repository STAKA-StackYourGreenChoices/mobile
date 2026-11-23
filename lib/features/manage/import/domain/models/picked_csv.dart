import 'package:flutter/foundation.dart';

/// A spreadsheet file the admin picked, ready to check and import.
@immutable
class PickedCsv {
  const new({required this.name, required this.bytes});

  /// The API accepts at most 2 MB (`MAX_IMPORT_BYTES`).
  static const int maxBytes = 2 * 1024 * 1024;

  final String name;
  final Uint8List bytes;

  int get sizeBytes => bytes.length;
  bool get isEmpty => bytes.isEmpty;
  bool get isTooLarge => sizeBytes > maxBytes;

  /// Judged by name, like the website and the API.
  bool get isCsv => name.toLowerCase().endsWith('.csv');
}
