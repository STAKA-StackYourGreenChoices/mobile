import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/features/manage/brand_review/domain/repositories/brand_review_repository.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';

/// Serves brands by status (empty for any not given) and by id, and
/// answers decisions from `decisions` in order. Records each decision as
/// `(action, id, reason)`.
class FakeBrandReviewRepository implements BrandReviewRepository {
  new({
    this._lists = const {},
    this._details,
    this._documents = const {},
    List<Result<void>> decisions = const [],
  }) : _decisions = [...decisions];

  final Map<BrandApplicationStatus, Result<List<ReviewBrand>>> _lists;
  final Map<String, Result<ReviewBrand>>? _details;
  final Map<String, Result<BrandDocument>> _documents;
  final List<Result<void>> _decisions;
  final List<(String, String, String?)> decided = [];

  @override
  Future<Result<List<ReviewBrand>>> fetchBrands(
    BrandApplicationStatus status,
  ) async => _lists[status] ?? const Ok([]);

  @override
  Future<Result<ReviewBrand>> fetchBrand(String id) async {
    if (_details?[id] case final detail?) return detail;
    // Otherwise whichever list holds it.
    for (final list in _lists.values) {
      if (list case Ok(:final value)) {
        for (final brand in value) {
          if (brand.id == id) return Ok(brand);
        }
      }
    }
    return const Err(NotFoundFailure(['Brand not found']));
  }

  @override
  Future<Result<BrandDocument>> fetchDocument(String id) async =>
      _documents[id] ?? const Err(NotFoundFailure(['No document']));

  Future<Result<void>> _decide(String action, String id, [String? reason]) {
    decided.add((action, id, reason));
    return Future.value(_decisions.removeAt(0));
  }

  @override
  Future<Result<void>> approve(String id) => _decide('approve', id);

  @override
  Future<Result<void>> reject(String id, String reason) =>
      _decide('reject', id, reason);

  @override
  Future<Result<void>> suspend(String id, String reason) =>
      _decide('suspend', id, reason);

  @override
  Future<Result<void>> reinstate(String id) => _decide('reinstate', id);
}

/// A brand to review; Terra Threads waiting by default.
ReviewBrand reviewBrand({
  String id = 'b1',
  String name = 'Terra Threads',
  BrandApplicationStatus status = BrandApplicationStatus.pending,
  String? statusReason,
  int? memberCount = 1,
  bool hasDocument = true,
}) => ReviewBrand(
  application: BrandApplication(
    id: id,
    name: name,
    legalName: '$name Pvt Ltd',
    status: status,
    statusReason: statusReason,
    description: 'Organic cotton basics, made in Tiruppur.',
    websiteUrl: 'https://terrathreads.example',
    gstin: '29ABCDE1234F1Z5',
    contactEmail: 'hello@terrathreads.example',
    contactPhone: '+919876543210',
    appliedAt: DateTime(2026, 11, 20, 10),
  ),
  memberCount: memberCount,
  hasDocument: hasDocument,
);

/// Serves disputes by status and answers resolutions in order. Records
/// each as `(id, outcome, note)`.
class FakeDisputeRepository implements DisputeRepository {
  new({this._lists = const {}, List<Result<void>> resolutions = const []})
    : _resolutions = [...resolutions];

  final Map<DisputeStatus, Result<List<AdminDispute>>> _lists;
  final List<Result<void>> _resolutions;
  final List<(String, DisputeOutcome, String)> resolved = [];

  @override
  Future<Result<List<AdminDispute>>> fetchDisputes(
    DisputeStatus status,
  ) async => _lists[status] ?? const Ok([]);

  @override
  Future<Result<void>> resolve(
    String id,
    DisputeOutcome outcome,
    String note,
  ) async {
    resolved.add((id, outcome, note));
    return _resolutions.removeAt(0);
  }
}

/// An open dispute about [claim].
AdminDispute disputeOf(
  Claim claim, {
  String id = 'd1',
  DisputeStatus status = DisputeStatus.open,
  String message = 'This is the Terra Threads shop in Pune; the tee is line 2.',
  String? resolution,
  DateTime? resolvedAt,
}) => AdminDispute(
  id: id,
  claimId: claim.id,
  status: status,
  message: message,
  createdAt: DateTime(2026, 11, 21, 9),
  resolution: resolution,
  resolvedAt: resolvedAt,
  claim: claim,
);
