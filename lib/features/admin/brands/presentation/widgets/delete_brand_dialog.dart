import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/admin/brands/presentation/state/brand_delete_controller.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// How the delete dialog ended.
enum DeleteBrandOutcome { deleted, seeProducts }

/// The website's `DeleteBrand`. A brand with products can't be deleted,
/// so the dialog says so and offers its products instead; otherwise it
/// asks, and stays open to show why the API refused. Null if closed.
Future<DeleteBrandOutcome?> showDeleteBrandDialog(
  BuildContext context, {
  required BrandSummary brand,
}) async {
  final container = ProviderScope.containerOf(context);
  final outcome = await showDialog<DeleteBrandOutcome>(
    context: context,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: brand.productCount > 0
          ? _BrandHasProducts(brand: brand)
          : _ConfirmDelete(brand: brand),
    ),
  );
  container.read(brandDeleteControllerProvider(brand.id).notifier).reset();
  return outcome;
}

class _BrandHasProducts extends StatelessWidget {
  const new({required this.brand});

  final BrandSummary brand;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.brandHasProductsTitle(brand.name)),
      content: Text(l10n.brandHasProductsBody(brand.productCount)),
      actions: [
        AppButton(
          label: l10n.close,
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: l10n.seeItsProducts,
          onPressed: () =>
              Navigator.of(context).pop(DeleteBrandOutcome.seeProducts),
        ),
      ],
    );
  }
}

class _ConfirmDelete extends ConsumerWidget {
  const new({required this.brand});

  final BrandSummary brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = brandDeleteControllerProvider(brand.id);
    final request = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) {
        Navigator.of(context).pop(DeleteBrandOutcome.deleted);
      }
    });
    final isDeleting = request is RequestSending;
    final failure = request is RequestFailed ? request.failure : null;

    return AlertDialog(
      title: Text(l10n.deleteBrandTitle(brand.name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Text(l10n.cantBeUndone),
          if (failure != null)
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
        ],
      ),
      actions: [
        AppButton(
          label: l10n.keepBrand,
          variant: AppButtonVariant.ghost,
          onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: l10n.deleteBrand,
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
