import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/tag_figures.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/tag_footer.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/tag_photo_area.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/tag_shape.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/tag_swing.dart';
import 'package:staka/shared/widgets/layout/dashed_border.dart';

/// Tag widths, from the website (232 / 288 / 320).
enum HangTagSize {
  sm(232),
  md(288),
  lg(320);

  new(this.width);

  final double width;
}

/// STAKA's signature element: a product's digital twin drawn as a garment
/// hang tag — chamfered top corners, a punched and reinforced hole, a
/// stitched border. The only element in the app that casts a shadow
/// (web DESIGN.md "The tag is the only bold element").
class HangTag extends StatelessWidget {
  const new({
    required this.productName,
    required this.brandName,
    this.sustainability,
    this.image,
    this.gtin,
    this.ownerName,
    this.size = HangTagSize.md,
    this.isOwnerVerified = false,
    this.hasPhotoArea = true,
    this.hasString = false,
    this.hasSwing = false,
    super.key,
  });

  final String productName;
  final String brandName;
  final SustainabilityInfo? sustainability;

  /// The product photo (e.g. `TagImage`); null shows "No photo yet".
  final Widget? image;
  final String? gtin;

  /// Shown as "Kept by …" when the tag belongs to someone.
  final String? ownerName;
  final HangTagSize size;
  final bool isOwnerVerified;
  final bool hasPhotoArea;

  /// Draws the string the tag hangs from.
  final bool hasString;

  /// Swings once when it first appears (cross-fades under reduce-motion).
  final bool hasSwing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final tag = Semantics(
      container: true,
      // Its own labelled node, contents read as separate items (web:
      // <figure aria-label>).
      explicitChildNodes: true,
      label: context.l10n.tagSemantics(productName, brandName),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The string runs 30 dp into the tag; the tag paints over it, so
          // its end shows only through the punched hole, as on the website.
          if (hasString)
            SizedBox(
              height: TagString.size.height - TagString.overlap,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxHeight: TagString.size.height,
                child: TagString(color: colors.inkSubtle),
              ),
            ),
          PhysicalShape(
            clipper: const TagClipper(),
            color: colors.surfaceRaised,
            elevation: AppSpacing.xs,
            // Card stock hanging off a garment: a soft, ink-tinted shadow,
            // near-black in dark mode where ink is cream.
            shadowColor: isLight ? colors.ink : colors.surfaceBase,
            child: SizedBox(
              width: size.width,
              child: _TagBody(tag: this),
            ),
          ),
        ],
      ),
    );
    return hasSwing ? TagSwing(child: tag) : tag;
  }
}

class _TagBody extends StatelessWidget {
  const new({required this.tag});

  final HangTag tag;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompact = tag.size == HangTagSize.sm;
    final padding = isCompact ? AppSpacing.lg - AppSpacing.xxs : AppSpacing.lg;
    return Stack(
      children: [
        const _ReinforcementRing(),
        Positioned.fill(
          child: Padding(
            padding: TagGeometry.stitchInset,
            child: DashedBorder(
              color: colors.borderStrong,
              radius: TagGeometry.stitchRadius,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            padding,
            TagGeometry.contentTop,
            padding,
            padding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: isCompact ? AppSpacing.sm : AppSpacing.md,
            children: [
              _TagTitle(tag: tag, isCompact: isCompact),
              if (tag.hasPhotoArea) TagPhotoArea(image: tag.image),
              TagFigures(info: tag.sustainability, isCompact: isCompact),
              if (tag.ownerName != null || tag.gtin != null)
                TagFooter(
                  ownerName: tag.ownerName,
                  isOwnerVerified: tag.isOwnerVerified,
                  gtin: tag.gtin,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TagTitle extends StatelessWidget {
  const new({required this.tag, required this.isCompact});

  final HangTag tag;
  final bool isCompact;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        tag.brandName,
        style: context.text.bodySmall.copyWith(color: context.colors.inkMuted),
      ),
      Text(
        tag.productName,
        style: isCompact
            ? context.text.headingSmall
            : context.text.headingMedium,
      ),
    ],
  );
}

class _ReinforcementRing extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Positioned(
    top: TagGeometry.ringTop,
    left: 0,
    right: 0,
    child: Center(
      child: Container(
        width: TagGeometry.ringSize,
        height: TagGeometry.ringSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.colors.brandSecondary.withValues(alpha: 0.35),
            width: TagGeometry.ringWidth,
          ),
        ),
      ),
    ),
  );
}
