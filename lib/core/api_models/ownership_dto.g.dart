// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownership_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnershipDto _$OwnershipDtoFromJson(Map<String, dynamic> json) => OwnershipDto(
  status: json['status'] as String,
  receiptAttemptsUsed: (json['receiptAttemptsUsed'] as num).toInt(),
  receiptAttemptsLeft: (json['receiptAttemptsLeft'] as num).toInt(),
  method: json['method'] as String?,
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  pendingSince: json['pendingSince'] == null
      ? null
      : DateTime.parse(json['pendingSince'] as String),
  lastRejectionReason: json['lastRejectionReason'] as String?,
);
