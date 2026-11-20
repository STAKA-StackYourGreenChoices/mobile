import 'dart:async';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/admin/products/domain/models/editable_product.dart';
import 'package:staka/features/admin/products/domain/models/product_draft.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';
import 'package:staka/features/admin/products/domain/repositories/admin_product_repository.dart';

import 'product_fakes.dart';

typedef PageRequest = ({ProductFilter filter, int page});

/// Answers product pages from `pages` (default: no products; return a
/// future to hold an answer back) and the brand list from [brands],
/// recording every page asked for. One product is answered from
/// [products] (unknown ids are not found); saves and deletes from the
/// `saves` and `deletes` scripts, recorded in [saved] and [deleted].
class FakeAdminProductRepository implements AdminProductRepository {
  new({
    FutureOr<Result<ProductPage>> Function(PageRequest request)? pages,
    this.brands = const Ok([]),
    this.products = const {},
    List<Result<EditableProduct>> saves = const [],
    List<Result<void>> deletes = const [],
  }) : _pages = pages ?? ((_) => Ok(pageOf(const []))),
       _saves = [...saves],
       _deletes = [...deletes];

  final FutureOr<Result<ProductPage>> Function(PageRequest request) _pages;
  final Result<List<BrandSummary>> brands;
  final List<PageRequest> requests = [];
  final Map<String, Result<EditableProduct>> products;
  final List<Result<EditableProduct>> _saves;
  final List<Result<void>> _deletes;

  /// (product id or null for a new one, what was sent).
  final List<(String?, ProductDraft)> saved = [];
  final List<String> deleted = [];

  @override
  Future<Result<ProductPage>> fetchProducts(
    ProductFilter filter,
    int page,
  ) async {
    final request = (filter: filter, page: page);
    requests.add(request);
    return await _pages(request);
  }

  @override
  Future<Result<List<BrandSummary>>> fetchBrands() async => brands;

  @override
  Future<Result<EditableProduct>> fetchProduct(String id) async =>
      products[id] ?? const Err(NotFoundFailure(['Product not found']));

  @override
  Future<Result<EditableProduct>> createProduct(ProductDraft draft) async {
    saved.add((null, draft));
    return _saves.removeAt(0);
  }

  @override
  Future<Result<EditableProduct>> updateProduct(
    String id,
    ProductDraft draft,
  ) async {
    saved.add((id, draft));
    return _saves.removeAt(0);
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    deleted.add(id);
    return _deletes.removeAt(0);
  }
}

/// [product] opened for editing, its photo stored as [storedImageUrl].
Result<EditableProduct> editable(Product product, {String? storedImageUrl}) =>
    Ok(EditableProduct(product: product, storedImageUrl: storedImageUrl));

/// One page as the API sends it: 20 per page unless [total] says fewer.
ProductPage pageOf(List<Product> items, {int? total, int page = 1}) =>
    ProductPage(
      items: items,
      total: total ?? items.length,
      page: page,
      limit: 20,
    );

/// Products "Product 1" … with distinct barcodes, starting at [from].
List<Product> numberedProducts(int count, {int from = 1}) => [
  for (var n = from; n < from + count; n++)
    productNamed(
      'Product $n',
      gtin: '0890123450${n.toString().padLeft(4, '0')}',
    ),
];

BrandSummary brandSummary(String id, String name) => BrandSummary(
  id: id,
  name: name,
  productCount: 3,
  createdAt: DateTime.utc(2026, 11, 2),
);
