import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/presentation/state/admin_products_controller.dart';
import 'package:staka/features/admin/products/presentation/state/brand_options_provider.dart';
import 'package:staka/features/admin/products/presentation/widgets/admin_products_scroll_view.dart';
import 'package:staka/features/admin/products/presentation/widgets/brand_filter_sheet.dart';
import 'package:staka/features/admin/products/presentation/widgets/product_filters.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/products`: every product, searchable and
/// filterable by brand, opening each to edit.
class AdminProductsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminProductsControllerProvider);
    final controller = ref.read(adminProductsControllerProvider.notifier);
    final brands = ref.watch(brandOptionsProvider);
    final brandId = state.filter.brandId;

    void addProduct() => context.goNamed(AppRoute.adminProductNew.name);
    void importCsv() => context.goNamed(AppRoute.adminImport.name);

    Future<void> pickBrand(List<BrandSummary> options) async {
      final pick = await showBrandFilterSheet(
        context,
        brands: options,
        selectedId: brandId,
      );
      if (pick != null && pick.brandId != brandId) {
        await controller.filterByBrand(pick.brandId);
      }
    }

    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: AdminProductsScrollView(
        state: state,
        filters: ProductFilters(
          filter: state.filter,
          brandLabel: switch (brands) {
            AsyncData(value: Err()) || AsyncError() => null,
            AsyncData(value: Ok(:final value)) => _nameOf(
              brandId,
              value,
              context.l10n.allBrands,
            ),
            _ => context.l10n.allBrands,
          },
          onBrandPressed: switch (brands) {
            AsyncData(value: Ok(:final value)) => () => pickBrand(value),
            _ => null,
          },
          onSearch: controller.search,
          onClearPressed: controller.clearFilters,
        ),
        onRefresh: controller.refresh,
        onLoadMore: controller.loadMore,
        onRetry: controller.retry,
        onAddPressed: addProduct,
        onImportPressed: importCsv,
        onProductPressed: (product) => context.goNamed(
          AppRoute.adminProductEdit.name,
          pathParameters: {'id': product.id},
        ),
      ),
    );
  }

  static String _nameOf(
    String? brandId,
    List<BrandSummary> brands,
    String allBrands,
  ) {
    for (final brand in brands) {
      if (brand.id == brandId) return brand.name;
    }
    return allBrands;
  }
}
