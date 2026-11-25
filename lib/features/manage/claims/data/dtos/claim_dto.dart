import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/config/env.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/utils/image_url.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';

part 'claim_dto.g.dart';

/// Wire format of `ClaimDto` in the API.
@JsonSerializable(createToJson: false)
class ClaimDto {
  const new({
    required this.id,
    required this.method,
    required this.status,
    required this.createdAt,
    required this.hasReceipt,
    required this.user,
    required this.product,
    this.reviewedAt,
    this.rejectionReason,
    this.reviewedByName,
    this.orderId,
    this.receiptMimeType,
    this.receiptAttempt,
    this.disputeStatus,
    this.score,
    this.isDuplicate,
  });

  factory fromJson(Map<String, dynamic> json) => _$ClaimDtoFromJson(json);

  final String id;
  final String method;
  final String status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final String? reviewedByName;
  final String? orderId;
  final bool hasReceipt;
  final String? receiptMimeType;
  final int? receiptAttempt;
  final ClaimUserDto user;
  final ClaimProductDto product;

  /// V2-8: in lists and details once the receipt was checked.
  final int? score;
  final bool? isDuplicate;

  /// `dispute.status` (V2-12): OPEN | UPHELD | OVERTURNED.
  @JsonKey(readValue: _readDisputeStatus)
  final String? disputeStatus;

  static Object? _readDisputeStatus(Map<dynamic, dynamic> json, String _) =>
      switch (json['dispute']) {
        {'status': final Object? status} => status,
        _ => null,
      };

  Claim toDomain({String webAppUrl = Env.webAppUrl}) => Claim(
    id: id,
    method: claimMethodFromApi(method) ?? ClaimMethod.receipt,
    status: ClaimStatus.fromApi(status),
    createdAt: createdAt,
    reviewedAt: reviewedAt,
    rejectionReason: rejectionReason,
    reviewedByName: reviewedByName,
    orderId: orderId,
    hasReceipt: hasReceipt,
    receiptMimeType: receiptMimeType,
    receiptAttempt: receiptAttempt,
    isDisputed: disputeStatus == 'OPEN',
    score: score,
    isDuplicate: isDuplicate ?? false,
    user: ClaimUser(id: user.id, name: user.name, email: user.email),
    product: ClaimProduct(
      id: product.id,
      name: product.name,
      gtin: product.gtin,
      sku: product.sku,
      brandName: product.brandName,
      imageUrl: resolveImageUrl(product.imageUrl, webAppUrl: webAppUrl),
    ),
  );
}

@JsonSerializable(createToJson: false)
class ClaimUserDto {
  const new({required this.id, required this.name, required this.email});

  factory fromJson(Map<String, dynamic> json) => _$ClaimUserDtoFromJson(json);

  final String id;
  final String name;

  /// Null for a shopper who signed up with a phone number only.
  final String? email;
}

@JsonSerializable(createToJson: false)
class ClaimProductDto {
  const new({
    required this.id,
    required this.name,
    required this.gtin,
    required this.sku,
    required this.brandName,
    this.imageUrl,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$ClaimProductDtoFromJson(json);

  final String id;
  final String name;
  final String gtin;
  final String sku;
  final String brandName;
  final String? imageUrl;
}

/// `ClaimDetailDto`: a claim plus its `history` and `analysis` (V2-8).
ClaimDetail claimDetailFromJson(Map<String, dynamic> json) => ClaimDetail(
  claim: ClaimDto.fromJson(json).toDomain(),
  history: [
    for (final item in json['history'] as List<dynamic>? ?? const [])
      ClaimDto.fromJson(item as Map<String, dynamic>).toDomain(),
  ],
  analysis: switch (json['analysis']) {
    final Map<String, dynamic> analysis => receiptAnalysisFromJson(analysis),
    _ => null,
  },
);

/// `{status, merchant?, purchaseDate?, total?, brandMatched?,
/// productMatched?, dateOk?, duplicateOfClaimId?, score?}`. `total` may
/// come as a number or as a decimal string.
ReceiptAnalysis receiptAnalysisFromJson(Map<String, dynamic> json) =>
    ReceiptAnalysis(
      status: AnalysisStatus.fromApi(json['status']),
      merchant: json['merchant'] as String?,
      purchaseDate: switch (json['purchaseDate']) {
        final String date => DateTime.tryParse(date),
        _ => null,
      },
      total: switch (json['total']) {
        final num total => total,
        final String total => num.tryParse(total),
        _ => null,
      },
      brandMatched: json['brandMatched'] as bool?,
      productMatched: json['productMatched'] as bool?,
      dateOk: json['dateOk'] as bool?,
      duplicateOfClaimId: json['duplicateOfClaimId'] as String?,
      score: (json['score'] as num?)?.toInt(),
    );
