import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'idempotency_key.g.dart';

/// A new random `Idempotency-Key` (V2-7), 128 bits from `Random.secure`
/// shaped like a UUID v4. No package needed.
String newIdempotencyKey([Random? random]) {
  final source = random ?? Random.secure();
  final bytes = [for (var i = 0; i < 16; i++) source.nextInt(256)];
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = [for (final b in bytes) b.toRadixString(16).padLeft(2, '0')];
  return '${hex.sublist(0, 4).join()}-${hex.sublist(4, 6).join()}-'
      '${hex.sublist(6, 8).join()}-${hex.sublist(8, 10).join()}-'
      '${hex.sublist(10).join()}';
}

/// Makes keys; tests swap it for a predictable one.
@Riverpod(keepAlive: true)
String Function() idempotencyKeys(Ref ref) => newIdempotencyKey;
