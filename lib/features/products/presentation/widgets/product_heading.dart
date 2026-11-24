import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';

/// Brand, product name, the scanned size/colour, its category and the
/// description at the top of the product page.
class ProductHeading extends StatelessWidget {
  const new({
    required this.brandName,
    required this.productName,
    this.variantDetails,
    this.categoryName,
    this.description,
    super.key,
  });

  final String brandName;
  final String productName;

  /// "Size M · Navy" (V2-2).
  final String? variantDetails;

  /// Shown as a chip; null for products without one (V2-2).
  final String? categoryName;
  final String? description;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        brandName,
        style: context.text.label.copyWith(color: context.colors.inkMuted),
      ),
      const SizedBox(height: AppSpacing.xxs),
      Semantics(
        header: true,
        child: Text(productName, style: context.text.headingLarge),
      ),
      if (variantDetails case final details?) ...[
        const SizedBox(height: AppSpacing.xxs),
        Text(
          details,
          style: context.text.bodyLarge.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
      ],
      if (categoryName case final category?) ...[
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          label: context.l10n.categoryLabel(category),
          excludeSemantics: true,
          child: StatusPill(
            icon: Icons.sell_outlined,
            label: category,
            color: context.colors.inkMuted,
          ),
        ),
      ],
      if (description case final text?) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(text, style: context.text.bodyLarge),
      ],
    ],
  );
}
