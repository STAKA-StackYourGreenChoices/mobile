import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_state.dart';
import 'package:staka/features/wardrobe/presentation/widgets/tag_section_header.dart';
import 'package:staka/features/wardrobe/presentation/widgets/wardrobe_category_filter.dart';
import 'package:staka/features/wardrobe/presentation/widgets/wardrobe_header.dart';
import 'package:staka/features/wardrobe/presentation/widgets/wardrobe_share_card.dart';
import 'package:staka/features/wardrobe/presentation/widgets/wardrobe_tag_item.dart';
import 'package:staka/shared/formatters/product_labels.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';

/// The wardrobe's scrolling content: optional banner, header, then either
/// the empty-state invitation or the Verified / Waiting for proof groups.
/// Tags are built lazily (guide §7.1 rule 6); pull down to refresh. With
/// two or more kinds of piece, chips filter the groups by kind (V2-2).
/// With a verified piece, a card offers to share the wardrobe (V2-3).
class WardrobeScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.title,
    required this.onRefresh,
    required this.onScanPressed,
    required this.onTagPressed,
    this.banner,
    this.category,
    this.onCategorySelected,
    this.onSharePressed,
    this.impact,
    this.headerTrailing,
    super.key,
  });

  /// `WardrobeEmpty` or `WardrobeData`.
  final WardrobeState state;
  final String title;
  final Future<void> Function() onRefresh;
  final VoidCallback onScanPressed;
  final ValueChanged<DigitalCard> onTagPressed;
  final Widget? banner;

  /// The kind of piece shown; null shows everything.
  final ProductCategory? category;
  final ValueChanged<ProductCategory?>? onCategorySelected;

  /// Opens the wardrobe share screen; null hides the card.
  final VoidCallback? onSharePressed;

  /// "Your impact" (V2-5), under the header once the wardrobe has pieces.
  final Widget? impact;

  /// Beside the title: the notification bell (V2-9).
  final Widget? headerTrailing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = switch (state) {
      final WardrobeData data => data,
      _ => null,
    };
    final categories = data?.categories ?? const <ProductCategory>[];
    final hasFilter = categories.length > 1 && onCategorySelected != null;
    // A filter whose pieces are all gone shows everything again.
    final selected = hasFilter && categories.contains(category)
        ? category
        : null;
    final shown = data?.only(selected);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        // Pull-to-refresh must work even when the content is short.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (banner case final banner?)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              sliver: SliverToBoxAdapter(child: banner),
            ),
          SliverToBoxAdapter(
            child: WardrobeHeader(
              title: title,
              description: data == null
                  ? l10n.wardrobeEmptyDescription
                  : l10n.wardrobeCount(data.total, data.verified.length),
              actionLabel: data == null ? null : l10n.scanAProduct,
              onActionPressed: data == null ? null : onScanPressed,
              trailing: headerTrailing,
            ),
          ),
          if (data == null)
            SliverToBoxAdapter(
              child: AppEmptyState(
                icon: Icons.qr_code_scanner_rounded,
                title: l10n.wardrobeEmptyTitle,
                message: l10n.wardrobeEmptyBody,
                actionLabel: l10n.scanFirstPiece,
                actionIcon: Icons.qr_code_scanner_rounded,
                onActionPressed: onScanPressed,
              ),
            )
          else ...[
            if (impact case final impact?)
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                sliver: SliverToBoxAdapter(child: impact),
              ),
            if ((onSharePressed, data.verified.isNotEmpty) case (
              final onPressed?,
              true,
            ))
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: WardrobeShareCard(onPressed: onPressed),
                ),
              ),
            if (hasFilter)
              SliverPadding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: WardrobeCategoryFilter(
                    categories: categories,
                    selected: selected,
                    onSelected: onCategorySelected!,
                  ),
                ),
              ),
            if (shown != null && shown.total == 0 && selected != null)
              SliverToBoxAdapter(
                child: Text(
                  l10n.wardrobeFilterEmpty(categoryName(selected, l10n)),
                  style: context.text.bodyLarge.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
              ),
            ..._section(
              TagSectionHeader(
                title: l10n.sectionVerified,
                count: shown!.verified.length,
                description: l10n.sectionVerifiedBody,
              ),
              shown.verified,
            ),
            ..._section(
              TagSectionHeader(
                title: l10n.sectionWaiting,
                count: shown.waiting.length,
                description: l10n.sectionWaitingBody,
              ),
              shown.waiting,
            ),
          ],
        ],
      ),
    );
  }

  /// A heading and its tags; nothing at all when the group is empty.
  List<Widget> _section(Widget header, List<DigitalCard> cards) => [
    if (cards.isNotEmpty) ...[
      SliverToBoxAdapter(child: header),
      SliverList.builder(
        itemCount: cards.length,
        itemBuilder: (_, index) => WardrobeTagItem(
          key: ValueKey(cards[index].id),
          card: cards[index],
          onPressed: () => onTagPressed(cards[index]),
        ),
      ),
    ],
  ];
}
