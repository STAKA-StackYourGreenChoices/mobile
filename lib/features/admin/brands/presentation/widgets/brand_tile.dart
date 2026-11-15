import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// One brand on the brands page: name, what they make, how many products
/// (opens them), and Edit / Delete — the website's list row.
class BrandTile extends StatelessWidget {
  const new({
    required this.brand,
    required this.onProductsPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final BrandSummary brand;
  final VoidCallback onProductsPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(brand.name, style: context.text.label),
          ),
          if (brand.description case final text?)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs - 2),
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMedium.copyWith(
                  color: context.colors.inkMuted,
                ),
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: onProductsPressed,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(l10n.brandProductCount(brand.productCount)),
            ),
          ),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              Semantics(
                label: l10n.editBrandLabel(brand.name),
                excludeSemantics: true,
                button: true,
                child: AppButton(
                  label: l10n.edit,
                  icon: Icons.edit_outlined,
                  variant: AppButtonVariant.secondary,
                  onPressed: onEditPressed,
                ),
              ),
              Semantics(
                label: l10n.deleteBrandLabel(brand.name),
                excludeSemantics: true,
                button: true,
                child: AppButton(
                  label: l10n.delete,
                  icon: Icons.delete_outline_rounded,
                  variant: AppButtonVariant.quietDestructive,
                  onPressed: onDeletePressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
