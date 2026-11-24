import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:staka/core/models/ownership_status.dart';

part 'ownership.freezed.dart';

/// How ownership was proven (API `ClaimMethod`).
enum ClaimMethod { orderMatch, receipt }

/// Who decided the latest receipt (API `decidedBy`): the brand that makes
/// the piece, or STAKA.
enum ClaimDecider { brand, admin }

/// Where the shopper's "Ask STAKA to look again" stands (API
/// `ClaimDispute.status`). Upheld keeps the brand's decision; overturned
/// approves the receipt.
enum DisputeStatus { open, upheld, overturned }

/// The shopper asked STAKA to look again at a brand's rejection.
@freezed
abstract class OwnershipDispute with _$OwnershipDispute {
  const factory({required DisputeStatus status, String? resolution}) =
      _OwnershipDispute;
}

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
    ClaimDecider? decidedBy,
    String? brandName,
    OwnershipDispute? dispute,
  }) = _Ownership;

  const new _();

  bool get isVerified => status == OwnershipStatus.verified;

  /// The brand turned the latest receipt down and the shopper hasn't asked
  /// STAKA yet: the API takes one request per claim.
  bool get canAskToLookAgain =>
      decidedBy == ClaimDecider.brand &&
      dispute == null &&
      (status == OwnershipStatus.rejected || status == OwnershipStatus.blocked);
}
