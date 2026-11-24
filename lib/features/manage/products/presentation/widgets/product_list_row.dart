import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_thumbnail.dart';
import 'package:staka/shared/formatters/gtin_format.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';
import 'package:staka/shared/widgets/data_display/sustainability_badge.dart';

/// One product on a phone: photo, name, "brand, barcode" and whether its
/// figures are verified. The whole row opens the product (the website's
/// stacked rows below 768 px).
class ProductListRow extends StatelessWidget {
  const new({required this.product, required this.onPressed, super.key});

  final Product product;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: InkWell(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              ProductThumbnail(imageUrl: product.imageUrl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.label,
                    ),
                    Text(
                      '${product.brand.name}, ${displayGtin(product.gtin)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium.copyWith(
                        color: context.colors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (product.isHidden)
                StatusPill(
                  icon: Icons.visibility_off_outlined,
                  label: context.l10n.hiddenFromShoppers,
                  color: context.colors.inkMuted,
                )
              else
                SustainabilityBadge(
                  info: product.sustainabilityInfo,
                  isCompact: true,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
