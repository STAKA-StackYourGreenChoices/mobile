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
}
