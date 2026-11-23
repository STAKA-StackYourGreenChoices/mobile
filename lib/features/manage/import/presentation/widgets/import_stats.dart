import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/import/domain/models/import_report.dart';

/// The check's four numbers in a 2 × 2 grid (the website's `<dl>`). Rows
/// to fix turn red when there are any.
class ImportStats extends StatelessWidget {
  const new({required this.report, super.key});

  final ImportReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cells = [
      (l10n.statNewProducts, report.created, false),
      (l10n.statUpdates, report.updated, false),
      (l10n.statNewBrands, report.brandsCreated.length, false),
      (l10n.statRowsToFix, report.failed, report.failed > 0),
    ];
    return ClipRRect(
      borderRadius: AppRadius.allMd,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.border,
          border: Border.all(color: context.colors.border),
          borderRadius: AppRadius.allMd,
        ),
        child: Column(
          spacing: 1,
          children: [
            for (var row = 0; row < 2; row++)
              // Equal heights, so no gap shows the grid lines' colour.
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 1,
                  children: [
                    for (final (label, value, isAlert)
                        in cells.skip(row * 2).take(2))
                      Expanded(
                        child: _Stat(
                          label: label,
                          value: value,
                          isAlert: isAlert,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const new({required this.label, required this.value, required this.isAlert});

  final String label;
  final int value;
  final bool isAlert;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: ColoredBox(
      color: context.colors.surfaceRaised,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.text.bodySmall.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
            Text(
              '$value',
              style: context.text.headingMedium.copyWith(
                color: isAlert ? context.colors.dangerText : null,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
