import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// No products: none match the filters, or the catalog is empty and the
/// admin is invited to add or import some (the website's `EmptyState`).
class ProductsEmptyState extends StatelessWidget {
  const new({
    required this.isFiltered,
    required this.onAddPressed,
    required this.onImportPressed,
    super.key,
  });

  final bool isFiltered;
  final VoidCallback onAddPressed;
  final VoidCallback onImportPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FeedbackMessage(
      icon: Icons.inventory_2_outlined,
      iconColor: context.colors.brandPrimary,
      title: Text(
        isFiltered ? l10n.noProductsMatchTitle : l10n.noProductsTitle,
        style: context.text.headingMedium,
      ),
      message: isFiltered ? l10n.noProductsMatchBody : l10n.noProductsBody,
      action: isFiltered
          ? null
          : Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                AppButton(label: l10n.addProduct, onPressed: onAddPressed),
                AppButton(
                  label: l10n.importCsv,
                  variant: AppButtonVariant.secondary,
                  onPressed: onImportPressed,
                ),
              ],
            ),
    );
  }
}
