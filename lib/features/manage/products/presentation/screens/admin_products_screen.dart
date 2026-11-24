import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/app/routes.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/manage/products/presentation/state/admin_products_controller.dart';
import 'package:staka/features/manage/products/presentation/state/brand_options_provider.dart';
import 'package:staka/features/manage/products/presentation/widgets/admin_products_scroll_view.dart';
import 'package:staka/features/manage/products/presentation/widgets/brand_filter_sheet.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_filters.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_visibility_dialog.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/products`. A brand's team adds, imports and edits
/// its own products here; a STAKA admin sees every brand's, read-only,
/// and can hide one from shoppers (V2-12). [brandId] opens it already
/// filtered to that brand (the website's `?brand=`).
class AdminProductsScreen extends ConsumerWidget {
  const new({required this.scope, this.brandId, super.key});

  /// Admin (every brand) or one brand's team.
  final ManageScope scope;
  final String? brandId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = adminProductsControllerProvider(scope, brandId: this.brandId);
    final state = ref.watch(list);
    final controller = ref.read(list.notifier);
    // A brand lists its own products only: no brand filter to load.
    final brands = scope is BrandScope
        ? null
        : ref.watch(brandOptionsProvider(scope));
    final brandId = state.filter.brandId;

    final canEdit = scope is BrandScope;
    void addProduct() => context.goNamed(AppRoute.brandProductNew.name);
    void importCsv() => context.goNamed(AppRoute.brandImport.name);

    Future<void> openProduct(Product product) async {
      if (canEdit) {
        context.goNamed(
          AppRoute.brandProductEdit.name,
          pathParameters: {'id': product.id},
        );
        return;
      }
      final changed = await showProductVisibilityDialog(
        context,
        product: product,
      );
      if (changed && context.mounted) {
        AppSnackbar.show(
          context,
          message: product.isHidden
              ? context.l10n.productShown(product.name)
              : context.l10n.productHidden(product.name),
        );
      }
    }

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
            null || AsyncData(value: Err()) || AsyncError() => null,
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
        onAddPressed: canEdit ? addProduct : null,
        onImportPressed: canEdit ? importCsv : null,
        onProductPressed: openProduct,
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
