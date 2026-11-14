import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_state.dart';
import 'package:staka/features/wardrobe/presentation/widgets/tag_section_header.dart';
import 'package:staka/features/wardrobe/presentation/widgets/wardrobe_header.dart';
import 'package:staka/features/wardrobe/presentation/widgets/wardrobe_tag_item.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';

/// The wardrobe's scrolling content: optional banner, header, then either
/// the empty-state invitation or the Verified / Waiting for proof groups.
/// Tags are built lazily (guide §7.1 rule 6); pull down to refresh.
class WardrobeScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.title,
    required this.onRefresh,
    required this.onScanPressed,
    this.banner,
    super.key,
  });

  /// `WardrobeEmpty` or `WardrobeData`.
  final WardrobeState state;
  final String title;
  final Future<void> Function() onRefresh;
  final VoidCallback onScanPressed;
  final Widget? banner;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = switch (state) {
      final WardrobeData data => data,
      _ => null,
    };
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
            ..._section(
              TagSectionHeader(
                title: l10n.sectionVerified,
                count: data.verified.length,
                description: l10n.sectionVerifiedBody,
              ),
              data.verified,
            ),
            ..._section(
              TagSectionHeader(
                title: l10n.sectionWaiting,
                count: data.waiting.length,
                description: l10n.sectionWaitingBody,
              ),
              data.waiting,
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
        itemBuilder: (_, index) =>
            WardrobeTagItem(key: ValueKey(cards[index].id), card: cards[index]),
      ),
    ],
  ];
}
