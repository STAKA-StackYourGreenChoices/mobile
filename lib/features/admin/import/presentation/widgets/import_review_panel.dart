import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/admin/import/domain/models/import_report.dart';
import 'package:staka/features/admin/import/presentation/widgets/import_stats.dart';
import 'package:staka/features/admin/import/presentation/widgets/row_error_card.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// Step 2: what the check found, the rows that will be skipped, and the
/// import button (only when something can be imported).
class ImportReviewPanel extends StatelessWidget {
  const new({
    required this.report,
    required this.fileName,
    required this.isImporting,
    required this.onImportPressed,
    required this.onChooseAnotherPressed,
    super.key,
  });

  final ImportReport report;
  final String fileName;
  final bool isImporting;
  final VoidCallback onImportPressed;
  final VoidCallback onChooseAnotherPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final writable = report.writable;
    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            Semantics(
              header: true,
              child: Text(
                writable > 0
                    ? l10n.readyToImport(writable)
                    : l10n.nothingToImport,
                style: context.text.headingMedium,
              ),
            ),
            Text(l10n.checkedRows(report.totalRows, fileName), style: muted),
          ],
        ),
        ImportStats(report: report),
        if (report.brandsCreated.isNotEmpty)
          Text(
            l10n.newBrandsList(report.brandsCreated.join(', ')),
            style: context.text.bodyMedium,
          ),
        if (report.errors.isNotEmpty) _SkippedRows(errors: report.errors),
        const Divider(height: 1),
        if (writable > 0)
          AppButton(
            label: l10n.importProductCount(writable),
            loadingLabel: l10n.importing,
            isLoading: isImporting,
            isExpanded: true,
            onPressed: onImportPressed,
          ),
        AppButton(
          label: l10n.chooseDifferentFile,
          variant: AppButtonVariant.ghost,
          isExpanded: true,
          onPressed: isImporting ? null : onChooseAnotherPressed,
        ),
      ],
    );
  }
}

class _SkippedRows extends StatelessWidget {
  const new({required this.errors});

  final List<ImportRowError> errors;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Semantics(
          header: true,
          child: Row(
            spacing: AppSpacing.xs,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: AppSizes.iconInline - 4,
                color: context.colors.dangerText,
              ),
              Expanded(
                child: Text(
                  l10n.rowsSkipped(errors.length),
                  style: context.text.label,
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.rowsSkippedHint,
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surfaceRaised,
            border: Border.all(color: context.colors.border),
            borderRadius: AppRadius.allMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < errors.length; i++) ...[
                if (i > 0) Divider(height: 1, color: context.colors.border),
                RowErrorCard(error: errors[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
