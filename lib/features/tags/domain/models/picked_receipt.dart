import 'package:flutter/foundation.dart';

/// A receipt photo or PDF the shopper picked, ready to upload.
@immutable
class PickedReceipt {
  const new({required this.name, required this.bytes});

  /// The API accepts at most 5 MB (web `MAX_RECEIPT_BYTES`).
  static const int maxBytes = 5 * 1024 * 1024;

  final String name;
  final Uint8List bytes;

  int get sizeBytes => bytes.length;
  bool get isTooLarge => sizeBytes > maxBytes;
}
