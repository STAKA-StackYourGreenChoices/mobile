import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// "Add product" or the product's name, one line under it, and on the
/// edit page the Delete product action (the website's `PageHeader`).
class ProductFormHeader extends StatelessWidget {
  const new({
    required this.title,
    required this.description,
    this.onDeletePressed,
    super.key,
  });

  final String title;
  final String description;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: context.text.headingLarge),
      ),
      const SizedBox(height: AppSpacing.xxs),
      Text(
        description,
        style: context.text.bodyLarge.copyWith(color: context.colors.inkMuted),
      ),
      if (onDeletePressed case final onPressed?)
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: AppButton(
            label: context.l10n.deleteProduct,
            icon: Icons.delete_outline_rounded,
            variant: AppButtonVariant.destructive,
            onPressed: onPressed,
          ),
        ),
    ],
  );
}
