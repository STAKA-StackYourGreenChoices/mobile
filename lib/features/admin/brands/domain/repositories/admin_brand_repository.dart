import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/brands/domain/models/brand_draft.dart';

/// The brands every product is filed under.
abstract interface class AdminBrandRepository {
  /// Sorted by name, each with its product count.
  Future<Result<List<BrandSummary>>> fetchBrands();

  /// Refused with a conflict when another brand has the name.
  Future<Result<BrandSummary>> createBrand(BrandDraft draft);

  Future<Result<BrandSummary>> updateBrand(String id, BrandDraft draft);

  /// Refused with a conflict while the brand still has products.
  Future<Result<void>> deleteBrand(String id);
}
