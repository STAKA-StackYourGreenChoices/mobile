import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/tags/domain/models/card_stats.dart';
import 'package:staka/shared/formatters/share_labels.dart';

/// "How your link is doing" on a shared tag (V2-5): views, visits to the
/// brand, and views per channel as bars.
class TagStatsSection extends StatelessWidget {
  const new({required this.stats, super.key});

  final CardStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final number = NumberFormat.decimalPattern();
    final channels = stats.channelsByViews;
    final most = channels.isEmpty ? 1 : channels.first.$2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        const Divider(),
        Semantics(
          header: true,
          child: Text(l10n.tagStatsTitle, style: context.text.label),
        ),
        Row(
          children: [
            Expanded(
              child: _Count(
                value: number.format(stats.views),
                label: l10n.tagStatsViews,
              ),
            ),
            Expanded(
              child: _Count(
                value: number.format(stats.clicks),
                label: l10n.tagStatsClicks,
              ),
            ),
          ],
        ),
        if (channels.isEmpty)
          Text(
            l10n.tagStatsNoViews,
            style: context.text.bodySmall.copyWith(
              color: context.colors.inkMuted,
            ),
          )
        else ...[
          Text(
            l10n.tagStatsByChannel,
            style: context.text.bodySmall.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          for (final (channel, views) in channels)
            _ChannelBar(
              label: channelName(channel, l10n),
              value: number.format(views),
              share: views / most,
            ),
        ],
      ],
    );
  }
}

class _Count extends StatelessWidget {
  const new({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: context.text.headingMedium),
        Text(
          label,
          style: context.text.bodySmall.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
      ],
    ),
  );
}

/// A channel's name and views over a bar as long as its part of the most
/// viewed channel's views.
class _ChannelBar extends StatelessWidget {
  const new({required this.label, required this.value, required this.share});

  final String label;
  final String value;

  /// 0 to 1.
  final double share;

  static const _height = 6.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xxs,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: context.text.bodyMedium)),
              Text(value, style: context.text.label),
            ],
          ),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_height / 2),
              child: SizedBox(
                height: _height,
                child: ColoredBox(
                  color: colors.surfaceSunken,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: share.clamp(0, 1),
                      heightFactor: 1,
                      child: ColoredBox(color: colors.brandPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
