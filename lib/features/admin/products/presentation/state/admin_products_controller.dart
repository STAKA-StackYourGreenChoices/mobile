import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/admin/products/domain/models/product_page.dart';
import 'package:staka/features/admin/products/presentation/state/admin_products_state.dart';

part 'admin_products_controller.g.dart';

/// The admin product list: search, brand filter, and pages loaded as the
/// admin scrolls (guide §11: 20 at a time).
@riverpod
class AdminProductsController extends _$AdminProductsController {
  /// Bumped on every new search, so answers to an older one are dropped.
  int _generation = 0;

  @override
  AdminProductsState build() {
    unawaited(Future.microtask(() => _reload(const ProductFilter())));
    return const AdminProductsState(
      filter: ProductFilter(),
      body: ProductListLoading(),
    );
  }

  Future<void> search(String text) => _reload(state.filter.withSearch(text));

  Future<void> filterByBrand(String? brandId) =>
      _reload(state.filter.withBrand(brandId));

  /// The website's "Clear": no search, all brands.
  Future<void> clearFilters() => _reload(const ProductFilter());

  Future<void> retry() => _reload(state.filter);

  /// Pull to refresh: back to the first page of the same filter.
  Future<void> refresh() => _reload(state.filter, keepShowing: true);

  Future<void> loadMore() async {
    final body = state.body;
    if (body is! ProductListLoaded || !body.hasMore || body.isLoadingMore) {
      return;
    }
    final generation = _generation;
    final filter = state.filter;
    _show(filter, body.copy(isLoadingMore: true));
    final result = await ref
        .read(adminProductRepositoryProvider)
        .fetchProducts(filter, body.loadedPages + 1);
    if (!ref.mounted || generation != _generation) return;
    _show(filter, switch (result) {
      Ok(:final value) => ProductListLoaded(
        items: [...body.items, ...value.items],
        total: value.total,
        loadedPages: body.loadedPages + 1,
      ),
      Err(:final failure) => body.copy(loadMoreFailure: failure),
    });
  }

  Future<void> _reload(ProductFilter filter, {bool keepShowing = false}) async {
    final generation = ++_generation;
    if (!keepShowing) _show(filter, const ProductListLoading());
    final result = await ref
        .read(adminProductRepositoryProvider)
        .fetchProducts(filter, 1);
    if (!ref.mounted || generation != _generation) return;
    _show(filter, switch (result) {
      Ok(value: ProductPage(total: 0)) => const ProductListEmpty(),
      Ok(:final value) => ProductListLoaded(
        items: value.items,
        total: value.total,
        loadedPages: 1,
      ),
      Err(:final failure) => ProductListFailed(failure),
    });
  }

  void _show(ProductFilter filter, ProductListBody body) =>
      state = AdminProductsState(filter: filter, body: body);
}

extension on ProductListLoaded {
  /// The same items, now loading more or after a failed "load more".
  ProductListLoaded copy({
    bool isLoadingMore = false,
    Failure? loadMoreFailure,
  }) => ProductListLoaded(
    items: items,
    total: total,
    loadedPages: loadedPages,
    isLoadingMore: isLoadingMore,
    loadMoreFailure: loadMoreFailure,
  );
}
