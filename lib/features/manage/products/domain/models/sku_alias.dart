import 'package:flutter/foundation.dart';

/// A code another shop uses for one size/colour (V2-2), so their order
/// lines and receipts match it.
@immutable
class SkuAlias {
  const new({required this.source, required this.code});

  /// The shop's name, e.g. "Myntra".
  final String source;
  final String code;

  @override
  bool operator ==(Object other) =>
      other is SkuAlias && other.source == source && other.code == code;

  @override
  int get hashCode => Object.hash(source, code);
}
