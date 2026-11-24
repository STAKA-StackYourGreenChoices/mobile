import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/products/presentation/widgets/figures_explained.dart';
import 'package:staka/features/products/presentation/widgets/product_heading.dart';
import 'package:staka/shared/formatters/product_labels.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/tag_image.dart';

/// The product page: its tag swinging in (the scan's moment, web DESIGN.md
/// principle 4), name and description, the ownership [action], what the
/// figures mean, and about the brand.
class ProductFoundView extends StatelessWidget {
  const new({required this.product, required this.action, super.key});

  final Product product;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final brand = product.brand;
    final divider = Divider(color: context.colors.border);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.lg,
      children: [
        Center(
          child: HangTag(
            productName: product.name,
            brandName: brand.name,
            sustainability: product.sustainabilityInfo,
            image: switch (product.imageUrl) {
              final url? => TagImage(url),
              null => null,
            },
            gtin: product.shownGtin,
            size: HangTagSize.lg,
            hasSwing: true,
          ),
        ),
        ProductHeading(
          brandName: brand.name,
          productName: product.name,
          variantDetails: variantDetails(product.matchedVariant, context.l10n),
          categoryName: switch (product.category) {
            ProductCategory.other => null,
            final category => categoryName(category, context.l10n),
          },
          description: product.description,
        ),
        action,
        divider,
        FiguresExplained(
          brandName: brand.name,
          info: product.sustainabilityInfo,
        ),
        if (brand.description case final about?) ...[
          divider,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Semantics(
                header: true,
                child: Text(
                  context.l10n.aboutBrand(brand.name),
                  style: context.text.headingMedium,
                ),
              ),
              Text(
                about,
                style: context.text.bodyMedium.copyWith(
                  color: context.colors.inkMuted,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
