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
  final ClaimUser user;
  final ClaimProduct product;

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

/// One claim with every claim for the same piece, oldest first.
@immutable
class ClaimDetail {
  const new({required this.claim, required this.history});

  final Claim claim;
  final List<Claim> history;
}

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
