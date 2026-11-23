import 'package:flutter/foundation.dart';

/// A logo or business document picked on the phone, ready to upload.
@immutable
class BrandFile {
  const new({required this.name, required this.bytes});

  /// The API's limits (API plan V2-12): logo image 2 MB, document 5 MB.
  static const int logoMaxBytes = 2 * 1024 * 1024;
  static const int documentMaxBytes = 5 * 1024 * 1024;

  final String name;
  final Uint8List bytes;

  int get sizeBytes => bytes.length;

  bool get isPdf => name.toLowerCase().endsWith('.pdf');
}
