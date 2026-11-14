import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/ownership_chip.dart';
import 'package:staka/shared/widgets/data_display/tag_image.dart';

/// One piece in the wardrobe: its small hang tag, and under it the
/// ownership status unless it is already proven (the website's grid item).
class WardrobeTagItem extends StatelessWidget {
  const new({required this.card, super.key});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) {
    final product = card.product;
    final isVerified = card.ownership.isVerified;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          HangTag(
            productName: product.name,
            brandName: product.brand.name,
            sustainability: product.sustainabilityInfo,
            image: switch (product.imageUrl) {
              final url? => TagImage(url),
              null => null,
            },
            gtin: product.gtin,
            ownerName: card.ownerName,
            isOwnerVerified: isVerified,
            size: HangTagSize.sm,
          ),
          if (!isVerified) OwnershipChip(status: card.ownership.status),
        ],
      ),
    );
  }
}
