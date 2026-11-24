import 'package:json_annotation/json_annotation.dart';

part 'ownership_dto.g.dart';

/// Wire format of `summarizeOwnership` in the API.
@JsonSerializable(createToJson: false)
class OwnershipDto {
  const new({
    required this.status,
    required this.receiptAttemptsUsed,
    required this.receiptAttemptsLeft,
    this.method,
    this.verifiedAt,
    this.pendingSince,
    this.lastRejectionReason,
    this.decidedBy,
    this.brandName,
    this.dispute,
  });

  factory fromJson(Map<String, dynamic> json) => _$OwnershipDtoFromJson(json);

  /// UNVERIFIED | PENDING | REJECTED | BLOCKED | VERIFIED
  final String status;
  final int receiptAttemptsUsed;
  final int receiptAttemptsLeft;

  /// ORDER_MATCH | RECEIPT
  final String? method;
  final DateTime? verifiedAt;
  final DateTime? pendingSince;
  final String? lastRejectionReason;

  /// BRAND | ADMIN, for the latest decided receipt (V2-12).
  final String? decidedBy;

  /// The brand that makes the piece and checks its receipts.
  final String? brandName;
  final OwnershipDisputeDto? dispute;
}

/// `dispute` in an ownership summary: the shopper's request to look again.
@JsonSerializable(createToJson: false)
class OwnershipDisputeDto {
  const new({required this.status, this.resolution});

  factory fromJson(Map<String, dynamic> json) =>
      _$OwnershipDisputeDtoFromJson(json);

  /// OPEN | UPHELD | OVERTURNED
  final String status;

  /// STAKA's note when it resolved the request.
  final String? resolution;
}
