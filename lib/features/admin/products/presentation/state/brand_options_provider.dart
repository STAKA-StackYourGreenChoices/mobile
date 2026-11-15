import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/admin/shared/admin_catalog_revision.dart';

part 'brand_options_provider.g.dart';

/// The brands to filter products by (and, later, to pick in the product
/// form). Loading while the future runs; a failed `Result` hides the filter.
@riverpod
Future<Result<List<BrandSummary>>> brandOptions(Ref ref) {
  // Brands added, renamed or deleted elsewhere show up here too.
  ref.watch(adminCatalogRevisionProvider);
  return ref.read(adminProductRepositoryProvider).fetchBrands();
}
