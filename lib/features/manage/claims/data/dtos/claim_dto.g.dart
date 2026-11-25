// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimDto _$ClaimDtoFromJson(Map<String, dynamic> json) => ClaimDto(
  id: json['id'] as String,
  method: json['method'] as String,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  hasReceipt: json['hasReceipt'] as bool,
  user: ClaimUserDto.fromJson(json['user'] as Map<String, dynamic>),
  product: ClaimProductDto.fromJson(json['product'] as Map<String, dynamic>),
  reviewedAt: json['reviewedAt'] == null
      ? null
      : DateTime.parse(json['reviewedAt'] as String),
  rejectionReason: json['rejectionReason'] as String?,
  reviewedByName: json['reviewedByName'] as String?,
  orderId: json['orderId'] as String?,
  receiptMimeType: json['receiptMimeType'] as String?,
  receiptAttempt: (json['receiptAttempt'] as num?)?.toInt(),
  disputeStatus: ClaimDto._readDisputeStatus(json, 'disputeStatus') as String?,
  score: (json['score'] as num?)?.toInt(),
  isDuplicate: json['isDuplicate'] as bool?,
);

ClaimUserDto _$ClaimUserDtoFromJson(Map<String, dynamic> json) => ClaimUserDto(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
);

ClaimProductDto _$ClaimProductDtoFromJson(Map<String, dynamic> json) =>
    ClaimProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      gtin: json['gtin'] as String,
      sku: json['sku'] as String,
      brandName: json['brandName'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
