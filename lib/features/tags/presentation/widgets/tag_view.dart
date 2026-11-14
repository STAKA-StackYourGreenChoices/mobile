import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/features/tags/presentation/widgets/added_banner.dart';
import 'package:staka/features/tags/presentation/widgets/tag_summary.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/tag_image.dart';

/// The tag page: the shopper's tag (swinging if just added), what it is,
/// the [ownershipPanel], and where to go next — the website's `/tags/[id]`.
class TagView extends StatelessWidget {
  const new({
    required this.card,
    required this.ownershipPanel,
    required this.onScanAnotherPressed,
    required this.onProductDetailsPressed,
    this.isJustAdded = false,
    super.key,
  });

  final DigitalCard card;
  final Widget ownershipPanel;
  final bool isJustAdded;
  final VoidCallback onScanAnotherPressed;
  final VoidCallback onProductDetailsPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final product = card.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.lg,
      children: [
        if (isJustAdded) AddedBanner(productName: product.name),
        Center(
          child: HangTag(
            productName: product.name,
            brandName: product.brand.name,
            sustainability: product.sustainabilityInfo,
            image: switch (product.imageUrl) {
              final url? => TagImage(url),
              null => null,
            },
            gtin: product.gtin,
            ownerName: card.ownerName,
            isOwnerVerified: card.ownership.isVerified,
            size: HangTagSize.lg,
            hasSwing: isJustAdded,
          ),
        ),
        TagSummary(card: card),
        ownershipPanel,
        const Divider(),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton(
              label: l10n.scanAnotherPiece,
              icon: Icons.qr_code_scanner_rounded,
              onPressed: onScanAnotherPressed,
            ),
            AppButton(
              label: l10n.productDetails,
              variant: AppButtonVariant.secondary,
              onPressed: onProductDetailsPressed,
            ),
          ],
        ),
      ],
    );
  }
}
