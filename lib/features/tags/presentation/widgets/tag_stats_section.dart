import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/tags/domain/models/card_stats.dart';
import 'package:staka/shared/formatters/share_labels.dart';
import 'package:staka/shared/widgets/data_display/value_bar.dart';

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
            ValueBar(
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
