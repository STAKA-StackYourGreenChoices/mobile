import 'package:flutter/foundation.dart';

import 'package:staka/core/models/ownership.dart';

/// Where a claim is in review (API `ClaimStatus`).
enum ClaimStatus {
  pending('PENDING'),
  approved('APPROVED'),
  rejected('REJECTED');

  new(this.apiName);

  final String apiName;

  static ClaimStatus fromApi(String value) => values.firstWhere(
    (status) => status.apiName == value,
    orElse: () => ClaimStatus.pending,
  );
}

/// A shopper's proof of ownership for one piece: a receipt they uploaded,
/// or an order matched automatically.
@immutable
class Claim {
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
    this.isDisputed = false,
    this.score,
    this.isDuplicate = false,
  });

  final String id;
  final ClaimMethod method;
  final ClaimStatus status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final String? reviewedByName;
  final String? orderId;
  final bool hasReceipt;
  final String? receiptMimeType;

  /// Which of the shopper's five uploads this is (receipts only).
  final int? receiptAttempt;

  /// The shopper asked STAKA to look again and it hasn't answered yet.
  final bool isDisputed;
  final ClaimUser user;
  final ClaimProduct product;

  /// The automatic check's 0–100 match score (V2-8), once it has run.
  final int? score;

  /// The same receipt file came with an earlier claim (V2-8).
  final bool isDuplicate;

  bool get isPdf => receiptMimeType == 'application/pdf';
}

@immutable
class ClaimUser {
  const new({required this.id, required this.name, required this.email});

  final String id;
  final String name;

  /// Null for a shopper who signed up with a phone number only.
  final String? email;
}

/// The piece claimed. [imageUrl] is ready for this phone to load.
@immutable
class ClaimProduct {
  const new({
    required this.id,
    required this.name,
    required this.gtin,
    required this.sku,
    required this.brandName,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String gtin;
  final String sku;
  final String brandName;
  final String? imageUrl;
}

/// One claim with every claim for the same piece, oldest first, and the
/// automatic receipt check (V2-8; null for claims sent before it).
@immutable
class ClaimDetail {
  const new({required this.claim, required this.history, this.analysis});

  final Claim claim;
  final List<Claim> history;
  final ReceiptAnalysis? analysis;
}

/// How far the automatic check is (API `ReceiptAnalysis.status`).
enum AnalysisStatus {
  pending('PENDING'),
  done('DONE'),
  failed('FAILED');

  new(this.apiName);

  final String apiName;

  static AnalysisStatus fromApi(Object? value) => values.firstWhere(
    (status) => status.apiName == value,
    orElse: () => AnalysisStatus.pending,
  );
}

/// What the automatic check read on the receipt and how it compares with
/// the claim (V2-8). It only helps: the reviewer still decides.
@immutable
class ReceiptAnalysis {
  const new({
    required this.status,
    this.merchant,
    this.purchaseDate,
    this.total,
    this.brandMatched,
    this.productMatched,
    this.dateOk,
    this.duplicateOfClaimId,
    this.score,
  });

  final AnalysisStatus status;
  final String? merchant;
  final DateTime? purchaseDate;
  final num? total;

  /// Null when the check couldn't tell.
  final bool? brandMatched;
  final bool? productMatched;
  final bool? dateOk;

  /// An earlier claim with the same file. Brands get the flag only.
  final String? duplicateOfClaimId;
  final int? score;

  bool get isDuplicate => duplicateOfClaimId != null;
}

/// The order of the claims list (V2-8 adds `sort=score`).
enum ClaimSort { newest, score }

/// One page of `GET /claims`.
@immutable
class ClaimPage {
  const new({required this.items, required this.total});

  final List<Claim> items;
  final int total;
}

/// The uploaded receipt itself.
@immutable
class ClaimReceipt {
  const new({required this.bytes, required this.mimeType});

  final Uint8List bytes;
  final String mimeType;

  bool get isPdf => mimeType == 'application/pdf';
}
