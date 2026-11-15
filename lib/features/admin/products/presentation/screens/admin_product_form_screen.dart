import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/admin/products/domain/models/editable_product.dart';
import 'package:staka/features/admin/products/presentation/forms/product_save_errors.dart';
import 'package:staka/features/admin/products/presentation/state/product_editor_controller.dart';
import 'package:staka/features/admin/products/presentation/state/product_editor_state.dart';
import 'package:staka/features/admin/products/presentation/state/product_save_controller.dart';
import 'package:staka/features/admin/products/presentation/widgets/delete_product_dialog.dart';
import 'package:staka/features/admin/products/presentation/widgets/product_form.dart';
import 'package:staka/features/admin/products/presentation/widgets/product_form_header.dart';
import 'package:staka/features/admin/products/presentation/widgets/product_not_found.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/products/new` ([productId] null) and
/// `/admin/products/[id]`: the product form, and on edit Delete product.
class AdminProductFormScreen extends ConsumerWidget {
  const new({this.productId, super.key});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final editor = ref.watch(productEditorControllerProvider(productId));
    final save = ref.watch(productSaveControllerProvider(productId));

    ref.listen(productSaveControllerProvider(productId), (_, next) {
      if (next is! RequestDone<EditableProduct>) return;
      if (productId == null) {
        AppSnackbar.show(context, message: l10n.productAdded);
        // Like the website: carry on editing the new product.
        context.goNamed(
          AppRoute.adminProductEdit.name,
          pathParameters: {'id': next.value.product.id},
        );
      } else {
        AppSnackbar.show(context, message: l10n.changesSaved);
      }
    });

    return AppScaffold(
      showAppBar: true,
      isScrollable: editor is EditorReady,
      body: switch (editor) {
        EditorLoading() => const AppLoader(),
        EditorNotFound() => ProductNotFound(
          onProductsPressed: () => context.goNamed(AppRoute.adminProducts.name),
        ),
        EditorFailed(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: ref
              .read(productEditorControllerProvider(productId).notifier)
              .retry,
        ),
        EditorReady(:final brands, :final product) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(product: product),
            const SizedBox(height: AppSpacing.xl),
            ProductForm(
              brands: brands,
              product: product,
              isSaving: save is RequestSending,
              saveErrors: switch (save) {
                RequestFailed(:final failure) => productSaveErrors(
                  failure,
                  l10n,
                ),
                _ => null,
              },
              onSubmitted: ref
                  .read(productSaveControllerProvider(productId).notifier)
                  .submit,
              onCancelPressed: () => _leave(context),
              onAddBrandPressed: () =>
                  context.goNamed(AppRoute.adminBrands.name),
            ),
          ],
        ),
      },
    );
  }

  static void _leave(BuildContext context) => context.canPop()
      ? context.pop()
      : context.goNamed(AppRoute.adminProducts.name);
}

/// The page heading; on edit it also deletes.
class _Header extends StatelessWidget {
  const new({required this.product});

  final EditableProduct? product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = product?.product;
    if (current == null) {
      return ProductFormHeader(
        title: l10n.addProduct,
        description: l10n.productNewDescription,
      );
    }
    return ProductFormHeader(
      title: current.name,
      description: l10n.productLastUpdated(formatDate(current.updatedAt)),
      onDeletePressed: () async {
        final deleted = await showDeleteProductDialog(
          context,
          productId: current.id,
          productName: current.name,
        );
        if (!deleted || !context.mounted) return;
        AppSnackbar.show(context, message: l10n.productDeleted(current.name));
        context.goNamed(AppRoute.adminProducts.name);
      },
    );
  }
}
