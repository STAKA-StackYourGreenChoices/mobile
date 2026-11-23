import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/manage/products/presentation/state/admin_products_state.dart';
import 'package:staka/features/manage/products/presentation/widgets/admin_products_header.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_filters.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_list_row.dart';
import 'package:staka/features/manage/products/presentation/widgets/products_empty_state.dart';
import 'package:staka/features/manage/shared/widgets/load_more_footer.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';

/// The products page as one scroll: header, filters, then the list. Rows
/// are built lazily and the next 20 load when about five rows remain
/// (the app's version of the website's Previous / Next pages).
class AdminProductsScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.filters,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    required this.onAddPressed,
    required this.onImportPressed,
    required this.onProductPressed,
    super.key,
  });

  final AdminProductsState state;

  /// The search box and brand filter, wired by the screen.
  final ProductFilters filters;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final VoidCallback onAddPressed;
  final VoidCallback onImportPressed;
  final ValueChanged<Product> onProductPressed;

  /// About five 72 dp rows.
  static const double _prefetchExtent = 72.0 * 5;

  bool _onScroll(Notification notification) {
    final metrics = switch (notification) {
      ScrollNotification(:final metrics) => metrics,
      ScrollMetricsNotification(:final metrics) => metrics,
      _ => null,
    };
    final body = state.body;
    if (metrics != null &&
        metrics.extentAfter < _prefetchExtent &&
        body is ProductListLoaded &&
        body.hasMore &&
        !body.isLoadingMore &&
        body.loadMoreFailure == null) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: NotificationListener<Notification>(
      onNotification: _onScroll,
      child: CustomScrollView(
        // Pull-to-refresh must work even when the content is short.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: AdminProductsHeader(
              onAddPressed: onAddPressed,
              onImportPressed: onImportPressed,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: filters),
          ),
          ..._body(context),
        ],
      ),
    ),
  );

  List<Widget> _body(BuildContext context) => switch (state.body) {
    ProductListLoading() => const [
      SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
    ],
    ProductListEmpty() => [
      SliverToBoxAdapter(
        child: ProductsEmptyState(
          isFiltered: state.filter.isFiltered,
          onAddPressed: onAddPressed,
          onImportPressed: onImportPressed,
        ),
      ),
    ],
    ProductListFailed(:final failure) => [
      SliverToBoxAdapter(
        child: AppErrorState(failure: failure, onRetryPressed: onRetry),
      ),
    ],
    final ProductListLoaded loaded => [
      SliverPadding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        sliver: SliverToBoxAdapter(
          child: Semantics(
            liveRegion: true,
            child: Text(
              context.l10n.showingProducts(
                loaded.total,
                1,
                loaded.items.length,
              ),
              style: context.text.bodyMedium.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          ),
        ),
      ),
      _ProductRows(items: loaded.items, onProductPressed: onProductPressed),
      SliverToBoxAdapter(
        child: LoadMoreFooter(
          isLoading: loaded.isLoadingMore,
          failure: loaded.loadMoreFailure,
          onRetryPressed: onLoadMore,
        ),
      ),
    ],
  };
}

/// The rows in one bordered card, separated by hairlines.
class _ProductRows extends StatelessWidget {
  const new({required this.items, required this.onProductPressed});

  final List<Product> items;
  final ValueChanged<Product> onProductPressed;

  @override
  Widget build(BuildContext context) => DecoratedSliver(
    decoration: BoxDecoration(
      color: context.colors.surfaceRaised,
      border: Border.all(color: context.colors.border),
      borderRadius: AppRadius.allMd,
    ),
    sliver: SliverList.separated(
      itemCount: items.length,
      itemBuilder: (_, index) => ProductListRow(
        key: ValueKey(items[index].id),
        product: items[index],
        onPressed: () => onProductPressed(items[index]),
      ),
      separatorBuilder: (_, _) =>
          Divider(height: 1, color: context.colors.border),
    ),
  );
}
