import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/shared/formatters/product_labels.dart';

/// "All" then one chip per kind of piece the shopper has (V2-2). Scrolls
/// sideways when they don't fit.
class WardrobeCategoryFilter extends StatelessWidget {
  const new({
    required this.categories,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<ProductCategory> categories;

  /// Null means All.
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = <(ProductCategory?, String)>[
      (null, l10n.wardrobeFilterAll),
      for (final category in categories)
        (category, categoryName(category, l10n)),
    ];
    return Semantics(
      container: true,
      label: l10n.wardrobeFilterLabel,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            for (final (category, label) in options)
              ChoiceChip(
                label: Text(label),
                selected: selected == category,
                onSelected: (_) => onSelected(category),
                // The theme has no selected look; the brand fill with its
                // own text colour keeps the label readable.
                selectedColor: context.colors.brandPrimary,
                checkmarkColor: context.colors.onBrandPrimary,
                labelStyle: selected == category
                    ? context.text.label.copyWith(
                        color: context.colors.onBrandPrimary,
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
