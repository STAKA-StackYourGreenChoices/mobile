import 'package:staka/core/error/result.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';

/// STAKA admins approve, reject, suspend and reinstate brands (V2-12).
abstract interface class BrandReviewRepository {
  /// Newest application first.
  Future<Result<List<ReviewBrand>>> fetchBrands(BrandApplicationStatus status);

  Future<Result<ReviewBrand>> fetchBrand(String id);

  Future<Result<BrandDocument>> fetchDocument(String id);

  Future<Result<void>> approve(String id);

  /// [reason] (3–500) is shown to the brand's owners.
  Future<Result<void>> reject(String id, String reason);

  /// Locks the brand's portal; [reason] is shown to its team.
  Future<Result<void>> suspend(String id, String reason);

  Future<Result<void>> reinstate(String id);
}
