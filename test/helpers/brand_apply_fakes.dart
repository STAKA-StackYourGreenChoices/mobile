import 'dart:typed_data';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application_draft.dart';
import 'package:staka/features/brand_apply/domain/models/brand_file.dart';
import 'package:staka/features/brand_apply/domain/repositories/brand_application_repository.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_file_picker.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';

import 'admin_claim_fakes.dart';

/// Answers from scripts and records what was sent: `mine` for each
/// applications load, `listed` for the "already on STAKA" brands, `sends`
/// for apply and resubmit (in order). [sent] holds `(applicationId, draft)`;
/// the id is null for a new application.
class FakeBrandApplicationRepository implements BrandApplicationRepository {
  new({
    List<Result<List<BrandApplication>>> mine = const [Ok([])],
    this.listed = const Ok([]),
    List<Result<BrandApplication>> sends = const [],
  }) : _mine = [...mine],
       _sends = [...sends];

  final List<Result<List<BrandApplication>>> _mine;
  final Result<List<BrandSummary>> listed;
  final List<Result<BrandApplication>> _sends;
  final List<(String?, BrandApplicationDraft)> sent = [];
  int loads = 0;

  @override
  Future<Result<List<BrandApplication>>> fetchMine() async {
    loads++;
    // The last script repeats, so a refresh needs no extra script.
    return _mine.length == 1 ? _mine.first : _mine.removeAt(0);
  }

  @override
  Future<Result<List<BrandSummary>>> fetchListedBrands() async => listed;

  @override
  Future<Result<BrandApplication>> apply(BrandApplicationDraft draft) async {
    sent.add((null, draft));
    return _sends.removeAt(0);
  }

  @override
  Future<Result<BrandApplication>> resubmit(
    String applicationId,
    BrandApplicationDraft draft,
  ) async {
    sent.add((applicationId, draft));
    return _sends.removeAt(0);
  }
}

/// Hands back scripted files (null = cancelled) and records the document
/// sources asked for.
class FakeBrandFilePicker implements BrandFilePicker {
  new({
    List<BrandFile?> logos = const [],
    List<BrandFile?> documents = const [],
  }) : _logos = [...logos],
       _documents = [...documents];

  final List<BrandFile?> _logos;
  final List<BrandFile?> _documents;
  final List<ReceiptSource> documentSources = [];

  @override
  Future<BrandFile?> pickLogo() async => _logos.removeAt(0);

  @override
  Future<BrandFile?> pickDocument(ReceiptSource source) async {
    documentSources.add(source);
    return _documents.removeAt(0);
  }
}

BrandApplication brandApplication({
  String id = 'ba1',
  String name = 'Terra Threads',
  String legalName = 'Terra Threads Private Limited',
  BrandApplicationStatus status = BrandApplicationStatus.pending,
  String? statusReason,
  String? existingBrandId,
  String? logoUrl,
  DateTime? appliedAt,
}) => BrandApplication(
  id: id,
  name: name,
  legalName: legalName,
  status: status,
  statusReason: statusReason,
  description: 'Organic cotton basics, made in Tiruppur.',
  websiteUrl: 'https://terrathreads.example',
  gstin: '33AAACT1234F1Z5',
  contactEmail: 'hello@terrathreads.example',
  contactPhone: '+919876543210',
  existingBrandId: existingBrandId,
  logoUrl: logoUrl,
  appliedAt: appliedAt ?? DateTime.utc(2026, 11, 20, 9),
);

/// A small PNG logo.
BrandFile logoFile({String name = 'logo.png'}) =>
    BrandFile(name: name, bytes: onePixelPng);

/// A file of [bytes] zero bytes (for the size limits).
BrandFile bigFile(String name, int bytes) =>
    BrandFile(name: name, bytes: Uint8List(bytes));
