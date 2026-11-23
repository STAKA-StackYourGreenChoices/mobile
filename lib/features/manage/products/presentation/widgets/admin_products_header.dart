import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// "Products", what they are, and the Import CSV / Add product actions:
/// the website's `PageHeader` on `/admin/products`.
class AdminProductsHeader extends StatelessWidget {
  const new({
    required this.onAddPressed,
    required this.onImportPressed,
    super.key,
  });

  final VoidCallback onAddPressed;
  final VoidCallback onImportPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.adminProducts, style: context.text.headingLarge),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.adminProductsDescription,
          style: context.text.bodyLarge.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            AppButton(
              label: l10n.importCsv,
              icon: Icons.upload_file_outlined,
              variant: AppButtonVariant.secondary,
              onPressed: onImportPressed,
            ),
            AppButton(
              label: l10n.addProduct,
              icon: Icons.add_rounded,
              onPressed: onAddPressed,
            ),
          ],
        ),
      ],
    );
  }
}
