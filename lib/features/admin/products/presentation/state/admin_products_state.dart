import 'package:flutter/foundation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';

/// The admin product list: what it is filtered by, and what it shows.
@immutable
class AdminProductsState {
  const new({required this.filter, required this.body});

  final ProductFilter filter;
  final ProductListBody body;
}

/// The list's four states (guide §4.3).
sealed class ProductListBody {
  const new();
}

final class ProductListLoading extends ProductListBody {
  const new();
}

/// Nothing to show: no products at all, or none that match the filter.
final class ProductListEmpty extends ProductListBody {
  const new();
}

final class ProductListLoaded extends ProductListBody {
  const new({
    required this.items,
    required this.total,
    required this.loadedPages,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<Product> items;
  final int total;
  final int loadedPages;
  final bool isLoadingMore;

  /// The next page failed; the list stays and offers to try again.
  final Failure? loadMoreFailure;

  bool get hasMore => items.length < total;
}

final class ProductListFailed extends ProductListBody {
  const new(this.failure);

  final Failure failure;
}
