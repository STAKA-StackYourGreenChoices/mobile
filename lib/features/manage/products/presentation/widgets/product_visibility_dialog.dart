import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/products/presentation/state/product_visibility_controller.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Asks before an admin hides [product] from shoppers, or shows it again.
/// Stays open to show why the API refused. True once done.
Future<bool> showProductVisibilityDialog(
  BuildContext context, {
  required Product product,
}) async {
  final container = ProviderScope.containerOf(context);
  final done = await showDialog<bool>(
    context: context,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _ProductVisibilityDialog(product: product),
    ),
  );
  container
      .read(productVisibilityControllerProvider(product.id).notifier)
      .reset();
  return done ?? false;
}

class _ProductVisibilityDialog extends ConsumerWidget {
  const new({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = productVisibilityControllerProvider(product.id);
    final request = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop(true);
    });
    final isSending = request is RequestSending;
    final failure = request is RequestFailed ? request.failure : null;
    final hide = !product.isHidden;

    return AlertDialog(
      title: Text(
        hide
            ? l10n.hideProductTitle(product.name)
            : l10n.showProductTitle(product.name),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Text(
            hide
                ? l10n.hideProductBody(product.brand.name)
                : l10n.showProductBody,
          ),
          if (failure != null)
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
        ],
      ),
      actions: [
        AppButton(
          label: l10n.cancel,
          variant: AppButtonVariant.ghost,
          onPressed: isSending ? null : () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: hide ? l10n.hideProduct : l10n.showProduct,
          loadingLabel: l10n.saving,
          variant: hide
              ? AppButtonVariant.destructive
              : AppButtonVariant.primary,
          isLoading: isSending,
          onPressed: () => ref.read(provider.notifier).change(hidden: hide),
        ),
      ],
    );
  }
}
