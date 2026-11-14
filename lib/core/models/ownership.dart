import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:staka/core/models/ownership_status.dart';

part 'ownership.freezed.dart';

/// How ownership was proven (API `ClaimMethod`).
enum ClaimMethod { orderMatch, receipt }

/// Where a shopper stands on proving they own one piece.
@freezed
abstract class Ownership with _$Ownership {
  const factory({
    required OwnershipStatus status,
    required int receiptAttemptsUsed,
    required int receiptAttemptsLeft,
    ClaimMethod? method,
    DateTime? verifiedAt,
    DateTime? pendingSince,
    String? lastRejectionReason,
  }) = _Ownership;

  const new _();

  bool get isVerified => status == OwnershipStatus.verified;
}
