import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/brands/presentation/state/admin_brands_controller.dart';
import 'package:staka/features/admin/brands/presentation/state/admin_brands_state.dart';
import 'package:staka/features/admin/brands/presentation/widgets/admin_brands_scroll_view.dart';
import 'package:staka/features/admin/brands/presentation/widgets/brand_form_sheet.dart';
import 'package:staka/features/admin/brands/presentation/widgets/delete_brand_dialog.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/brands`: every brand with its product count,
/// added and edited in a sheet, deleted once it has no products.
class AdminBrandsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(adminBrandsControllerProvider);
    final controller = ref.read(adminBrandsControllerProvider.notifier);

    ref.listen(adminBrandsControllerProvider, (previous, next) {
      final failure = next is BrandsLoaded ? next.refreshFailure : null;
      final before = previous is BrandsLoaded ? previous.refreshFailure : null;
      if (failure == null || identical(failure, before)) return;
      AppSnackbar.show(
        context,
        message: messageForFailure(failure, l10n),
        tone: AlertTone.error,
      );
    });

    void showProducts(BrandSummary brand) => context.goNamed(
      AppRoute.adminProducts.name,
      queryParameters: {'brand': brand.id},
    );

    Future<void> edit(BrandSummary? brand) async {
      final saved = await showBrandFormSheet(context, brand: brand);
      if (saved == null || !context.mounted) return;
      AppSnackbar.show(
        context,
        message: brand == null ? l10n.brandAdded : l10n.brandUpdated,
      );
    }

    Future<void> delete(BrandSummary brand) async {
      final outcome = await showDeleteBrandDialog(context, brand: brand);
      if (!context.mounted) return;
      switch (outcome) {
        case DeleteBrandOutcome.deleted:
          AppSnackbar.show(context, message: l10n.brandDeleted(brand.name));
        case DeleteBrandOutcome.seeProducts:
          showProducts(brand);
        case null:
          break;
      }
    }

    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: AdminBrandsScrollView(
        state: state,
        onRefresh: controller.refresh,
        onRetry: controller.retry,
        onAddPressed: () => edit(null),
        onProductsPressed: showProducts,
        onEditPressed: edit,
        onDeletePressed: delete,
      ),
    );
  }
}
