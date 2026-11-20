import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// "What the file needs", folded away until opened (the website's
/// `<details>`).
class FileNeeds extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    final points = [
      Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${l10n.fileNeedsColumnsLabel} '),
            TextSpan(
              text: l10n.fileNeedsColumns,
              style: TextStyle(
                color: context.colors.ink,
                fontWeight: context.text.label.fontWeight,
              ),
            ),
          ],
        ),
        style: muted,
      ),
      Text(l10n.fileNeedsBarcodes, style: muted),
      Text(l10n.fileNeedsFigures, style: muted),
      Text(l10n.fileNeedsBrands, style: muted),
      Text(l10n.fileNeedsReview, style: muted),
    ];
    return Material(
      color: context.colors.surfaceRaised,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colors.border),
        borderRadius: AppRadius.allSm,
      ),
      child: ExpansionTile(
        title: Text(l10n.fileNeedsTitle, style: context.text.label),
        shape: const Border(),
        collapsedShape: const Border(),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final point in points)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: muted),
                  Expanded(child: point),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
