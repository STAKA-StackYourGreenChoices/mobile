import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/admin/products/presentation/state/product_delete_controller.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Asks before deleting, like the website's `DeleteProduct`. The dialog
/// stays open to show why the API refused (e.g. shoppers hold its tags).
/// True once the product is deleted.
Future<bool> showDeleteProductDialog(
  BuildContext context, {
  required String productId,
  required String productName,
}) async {
  final container = ProviderScope.containerOf(context);
  final deleted = await showDialog<bool>(
    context: context,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _DeleteProductDialog(
        productId: productId,
        productName: productName,
      ),
    ),
  );
  container.read(productDeleteControllerProvider(productId).notifier).reset();
  return deleted ?? false;
}

class _DeleteProductDialog extends ConsumerWidget {
  const new({required this.productId, required this.productName});

  final String productId;
  final String productName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = productDeleteControllerProvider(productId);
    final request = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop(true);
    });
    final isDeleting = request is RequestSending;
    final failure = request is RequestFailed ? request.failure : null;

    return AlertDialog(
      title: Text(l10n.deleteProductTitle(productName)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Text(l10n.deleteProductBody),
          if (failure != null)
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
        ],
      ),
      actions: [
        AppButton(
          label: l10n.keepProduct,
          variant: AppButtonVariant.ghost,
          onPressed: isDeleting ? null : () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: l10n.deleteProduct,
          loadingLabel: l10n.deleting,
          variant: AppButtonVariant.destructive,
          isLoading: isDeleting,
          onPressed: failure != null
              ? null
              : ref.read(provider.notifier).delete,
        ),
      ],
    );
  }
}
