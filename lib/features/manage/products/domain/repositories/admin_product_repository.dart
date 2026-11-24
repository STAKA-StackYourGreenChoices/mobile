import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';

/// The admin catalog: listing, adding, editing and deleting products, and
/// the brands to filter and file them under.
abstract interface class AdminProductRepository {
  /// [page] starts at 1; 20 per page, like the website.
  Future<Result<ProductPage>> fetchProducts(ProductFilter filter, int page);

  Future<Result<List<BrandSummary>>> fetchBrands();

  Future<Result<EditableProduct>> fetchProduct(String id);

  Future<Result<EditableProduct>> createProduct(ProductDraft draft);

  Future<Result<EditableProduct>> updateProduct(String id, ProductDraft draft);

  /// Refused with a conflict while shoppers hold tags for it.
  Future<Result<void>> deleteProduct(String id);

  /// Admins only (V2-12): hides the product from shoppers, or shows it
  /// again.
  Future<Result<void>> setHidden(String id, {required bool hidden});
}
