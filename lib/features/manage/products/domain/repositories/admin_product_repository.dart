import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';

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

  /// Other shops' codes for one size/colour (V2-2); brands only.
  Future<Result<void>> addAlias(
    String productId,
    String variantId,
    SkuAlias alias,
  );

  Future<Result<void>> removeAlias(
    String productId,
    String variantId,
    SkuAlias alias,
  );

  /// Admins only (V2-12): hides the product from shoppers, or shows it
  /// again.
  Future<Result<void>> setHidden(String id, {required bool hidden});
}
