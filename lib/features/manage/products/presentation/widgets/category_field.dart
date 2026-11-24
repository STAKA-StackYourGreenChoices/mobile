import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/shared/formatters/product_labels.dart';

/// "Type of piece" (V2-2): Tops, Bottoms, … Other.
class CategoryField extends StatelessWidget {
  const new({required this.value, required this.onChanged, super.key});

  final ProductCategory value;
  final ValueChanged<ProductCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fieldCategory, style: context.text.label),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<ProductCategory>(
          initialValue: value,
          isExpanded: true,
          style: context.text.bodyLarge.copyWith(color: context.colors.ink),
          onChanged: (category) {
            if (category != null) onChanged(category);
          },
          items: [
            for (final category in ProductCategory.values)
              DropdownMenuItem(
                value: category,
                child: Text(categoryName(category, l10n)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            l10n.categoryHint,
            style: context.text.bodySmall.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
        ),
      ],
    );
  }
}
