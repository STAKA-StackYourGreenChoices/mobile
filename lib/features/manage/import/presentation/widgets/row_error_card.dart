import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/import/domain/models/import_report.dart';

/// One skipped row: its line, its barcode and what to fix. The website's
/// table row, stacked to fit a phone.
class RowErrorCard extends StatelessWidget {
  const new({required this.error, super.key});

  final ImportRowError error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = context.text.bodySmall.copyWith(
      color: context.colors.inkMuted,
    );
    const tabular = [FontFeature.tabularFigures()];
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xxs,
            children: [
              _Field(
                label: l10n.columnLine,
                value: '${error.row}',
                labelStyle: label,
                valueStyle: context.text.bodyMedium.copyWith(
                  fontFeatures: tabular,
                ),
              ),
              _Field(
                label: l10n.columnBarcode,
                value: error.gtin ?? l10n.barcodeMissing,
                labelStyle: label,
                valueStyle: context.text.bodyMedium.copyWith(
                  color: context.colors.inkMuted,
                  fontFeatures: tabular,
                ),
              ),
            ],
          ),
          Text(l10n.columnFix, style: label),
          for (final message in error.messages)
            Text(message, style: context.text.bodyMedium),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    ),
  );
}
