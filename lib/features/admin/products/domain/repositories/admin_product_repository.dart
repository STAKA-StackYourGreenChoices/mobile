import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';

/// The admin catalog: listing products and the brands to filter them by.
abstract interface class AdminProductRepository {
  /// [page] starts at 1; 20 per page, like the website.
  Future<Result<ProductPage>> fetchProducts(ProductFilter filter, int page);

  Future<Result<List<BrandSummary>>> fetchBrands();
}
