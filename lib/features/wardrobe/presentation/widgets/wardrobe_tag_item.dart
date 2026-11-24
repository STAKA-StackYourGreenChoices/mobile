import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/shared/formatters/product_labels.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/ownership_chip.dart';
import 'package:staka/shared/widgets/data_display/tag_image.dart';

/// One piece in the wardrobe: its small hang tag, and under it the
/// ownership status unless it is already proven (the website's grid item).
/// Tapping the tag opens it.
class WardrobeTagItem extends StatelessWidget {
  const new({required this.card, required this.onPressed, super.key});

  final DigitalCard card;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final product = card.product;
    final isVerified = card.ownership.isVerified;
    final details = variantDetails(card.variant, context.l10n);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          Semantics(
            button: true,
            label: [
              context.l10n.openTagLabel(product.name, product.brand.name),
              ?details,
            ].join(', '),
            excludeSemantics: true,
            child: GestureDetector(
              onTap: onPressed,
              child: HangTag(
                productName: product.name,
                brandName: product.brand.name,
                sustainability: product.sustainabilityInfo,
                image: switch (product.imageUrl) {
                  final url? => TagImage(url),
                  null => null,
                },
                gtin: card.variant?.gtin ?? product.gtin,
                ownerName: card.ownerName,
                isOwnerVerified: isVerified,
                size: HangTagSize.sm,
              ),
            ),
          ),
          if (details != null)
            ExcludeSemantics(
              child: Text(
                details,
                style: context.text.bodyMedium.copyWith(
                  color: context.colors.inkMuted,
                ),
              ),
            ),
          if (!isVerified) OwnershipChip(status: card.ownership.status),
        ],
      ),
    );
  }
}
