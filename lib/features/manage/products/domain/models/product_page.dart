import 'package:flutter/foundation.dart';

import 'package:staka/core/models/product.dart';

/// One page of `GET /products`: [items] and how many match in all.
@immutable
class ProductPage {
  const new({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<Product> items;
  final int total;
  final int page;
  final int limit;
}

/// What the admin list is narrowed to. Empty means everything.
@immutable
class ProductFilter {
  const new({this.search = '', this.brandId});

  /// Matches name, SKU, barcode or brand name (the API decides how).
  final String search;
  final String? brandId;

  bool get isFiltered => search.isNotEmpty || brandId != null;

  ProductFilter withSearch(String value) =>
      ProductFilter(search: value.trim(), brandId: brandId);

  ProductFilter withBrand(String? id) =>
      ProductFilter(search: search, brandId: id);

  @override
  bool operator ==(Object other) =>
      other is ProductFilter &&
      other.search == search &&
      other.brandId == brandId;

  @override
  int get hashCode => Object.hash(search, brandId);
}
