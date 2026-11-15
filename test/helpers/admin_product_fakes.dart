import 'dart:async';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';
import 'package:staka/features/admin/products/domain/repositories/admin_product_repository.dart';

import 'product_fakes.dart';

typedef PageRequest = ({ProductFilter filter, int page});

/// Answers product pages from `pages` (default: no products; return a
/// future to hold an answer back) and the brand list from [brands],
/// recording every page asked for.
class FakeAdminProductRepository implements AdminProductRepository {
  new({
    FutureOr<Result<ProductPage>> Function(PageRequest request)? pages,
    this.brands = const Ok([]),
  }) : _pages = pages ?? ((_) => Ok(pageOf(const [])));

  final FutureOr<Result<ProductPage>> Function(PageRequest request) _pages;
  final Result<List<BrandSummary>> brands;
  final List<PageRequest> requests = [];

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
}

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
