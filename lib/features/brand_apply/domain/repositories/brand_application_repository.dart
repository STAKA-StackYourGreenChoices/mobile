import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application_draft.dart';

/// Bringing a brand to STAKA (V2-12): apply, see where it stands, fix and
/// resend a rejected one.
abstract interface class BrandApplicationRepository {
  /// The signed-in person's applications, newest first.
  Future<Result<List<BrandApplication>>> fetchMine();

  /// The brands STAKA already lists, for "My brand is already on STAKA".
  Future<Result<List<BrandSummary>>> fetchListedBrands();

  /// Sends a new application; the caller becomes the brand's owner. 409
  /// when a brand with that name already runs itself on STAKA.
  Future<Result<BrandApplication>> apply(BrandApplicationDraft draft);

  /// Sends a rejected application again with the changes (back to
  /// pending).
  Future<Result<BrandApplication>> resubmit(
    String applicationId,
    BrandApplicationDraft draft,
  );
}
