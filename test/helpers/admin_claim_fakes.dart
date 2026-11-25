import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/domain/repositories/admin_claim_repository.dart';

typedef ClaimPageRequest = ({ClaimStatus status, int page});

/// Claim pages from `pages` (default: none), details from `details`
/// (unknown ids are not found), receipts from `receipts`, decisions from
/// the `decisions` script. Records what was asked and decided.
class FakeAdminClaimRepository implements AdminClaimRepository {
  new({
    FutureOr<Result<ClaimPage>> Function(ClaimPageRequest request)? pages,
    this.details = const {},
    this.receipts = const {},
    this.products = const {},
    List<Result<ClaimDetail>> decisions = const [],
  }) : _pages = pages ?? ((_) => const Ok(ClaimPage(items: [], total: 0))),
       _decisions = [...decisions];

  final FutureOr<Result<ClaimPage>> Function(ClaimPageRequest request) _pages;
  final Map<String, Result<ClaimDetail>> details;
  final Map<String, Result<ClaimReceipt>> receipts;
  final Map<String, Result<Product>> products;
  final List<Result<ClaimDetail>> _decisions;
  final List<ClaimPageRequest> requests = [];

  /// The order asked for with each page (V2-8).
  final List<ClaimSort> sorts = [];
  final List<String> approved = [];
  final List<(String, String)> rejected = [];

  /// (claim id, decision, reason) for each overrule.
  final List<(String, ClaimStatus, String)> overruled = [];

  @override
  Future<Result<ClaimPage>> fetchClaims(
    ClaimStatus status,
    int page, {
    ClaimSort sort = ClaimSort.newest,
  }) async {
    final request = (status: status, page: page);
    requests.add(request);
    sorts.add(sort);
    return await _pages(request);
  }

  @override
  Future<Result<ClaimDetail>> fetchClaim(String id) async =>
      details[id] ?? const Err(NotFoundFailure(['Claim not found']));

  @override
  Future<Result<ClaimReceipt>> fetchReceipt(String claimId) async =>
      receipts[claimId] ?? const Err(NotFoundFailure(['Receipt not found']));

  @override
  Future<Result<Product>> fetchProduct(String productId) async =>
      products[productId] ?? const Err(NotFoundFailure(['Product not found']));

  @override
  Future<Result<ClaimDetail>> approve(String id) async {
    approved.add(id);
    return _decisions.removeAt(0);
  }

  @override
  Future<Result<ClaimDetail>> reject(String id, String reason) async {
    rejected.add((id, reason));
    return _decisions.removeAt(0);
  }

  @override
  Future<Result<ClaimDetail>> overrule(
    String id, {
    required ClaimStatus decision,
    required String reason,
  }) async {
    overruled.add((id, decision, reason));
    return _decisions.removeAt(0);
  }
}

final DateTime _sent = DateTime.utc(2026, 11, 12);

/// A claim id the review page accepts (a UUID).
String claimId(int n) => '00000000-0000-4000-8000-${'$n'.padLeft(12, '0')}';

Claim claimFor(
  int n, {
  ClaimStatus status = ClaimStatus.pending,
  ClaimMethod method = ClaimMethod.receipt,
  int? receiptAttempt = 2,
  String? mimeType = 'image/png',
  String? rejectionReason,
  String productName = 'Organic Cotton Tee',
  int? score,
  bool isDuplicate = false,
}) => Claim(
  score: score,
  isDuplicate: isDuplicate,
  id: claimId(n),
  method: method,
  status: status,
  createdAt: _sent,
  reviewedAt: status == ClaimStatus.pending ? null : DateTime.utc(2026, 11, 14),
  reviewedByName: status == ClaimStatus.pending ? null : 'Sam Admin',
  rejectionReason: rejectionReason,
  orderId: method == ClaimMethod.orderMatch ? 'ORD-1042' : null,
  hasReceipt: method == ClaimMethod.receipt,
  receiptMimeType: method == ClaimMethod.receipt ? mimeType : null,
  receiptAttempt: method == ClaimMethod.receipt ? receiptAttempt : null,
  user: const ClaimUser(
    id: 'u1',
    name: 'Ada Lovelace',
    email: 'ada@example.com',
  ),
  product: ClaimProduct(
    id: 'p1',
    name: productName,
    gtin: '08901234500019',
    sku: 'TT-TEE-01',
    brandName: 'Terra Threads',
  ),
);

Result<ClaimDetail> detailOf(
  Claim claim, {
  List<Claim>? history,
  ReceiptAnalysis? analysis,
}) => Ok(
  ClaimDetail(claim: claim, history: history ?? [claim], analysis: analysis),
);

/// A finished check that read everything and found a reused file.
final ReceiptAnalysis sampleAnalysis = ReceiptAnalysis(
  status: AnalysisStatus.done,
  merchant: 'Terra Threads, Bandra West',
  purchaseDate: DateTime.utc(2026, 11, 2),
  total: 1299,
  brandMatched: true,
  productMatched: false,
  duplicateOfClaimId: claimId(9),
  score: 64,
);

/// A valid 1 × 1 PNG, as a receipt photo.
final Uint8List onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA'
  '60e6kgAAAABJRU5ErkJggg==',
);
