import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/formatters/gtin_format.dart';

/// "Kept by Ada ✓" and "Barcode 8901234500019" at the bottom of the tag.
class TagFooter extends StatelessWidget {
  const new({
    this.ownerName,
    this.isOwnerVerified = false,
    this.gtin,
    super.key,
  });

  final String? ownerName;
  final bool isOwnerVerified;
  final String? gtin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final style = context.text.bodySmall.copyWith(color: colors.inkMuted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ownerName case final owner?)
          Semantics(
            label: isOwnerVerified
                ? '${l10n.keptBy(owner)}, ${l10n.verifiedOwnerSemantics}'
                : l10n.keptBy(owner),
            excludeSemantics: true,
            child: Row(
              spacing: AppSpacing.xxs,
              children: [
                Flexible(
                  child: Text(
                    l10n.keptBy(owner),
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isOwnerVerified)
                  Icon(
                    Icons.verified_rounded,
                    size: AppSpacing.md,
                    color: colors.success,
                  ),
              ],
            ),
          ),
        if (gtin case final gtin?)
          Text(
            l10n.barcodeNumber(displayGtin(gtin)),
            style: style.copyWith(
              fontFeatures: context.text.numeric.fontFeatures,
            ),
          ),
      ],
    );
  }
}
