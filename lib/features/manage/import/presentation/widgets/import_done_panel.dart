import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/import/domain/models/import_report.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// Step 3: how many products were imported, then View products or Import
/// another file.
class ImportDonePanel extends StatelessWidget {
  const new({
    required this.report,
    required this.onViewProductsPressed,
    required this.onImportAnotherPressed,
    super.key,
  });

  final ImportReport report;
  final VoidCallback onViewProductsPressed;
  final VoidCallback onImportAnotherPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final brands = report.brandsCreated.length;
    final summary = l10n.importSummary(
      l10n.importAdded(report.created),
      l10n.importUpdated(report.updated),
      brands > 0 ? l10n.importBrandsCreated(brands) : '',
      report.failed > 0 ? l10n.importSkipped(report.failed) : '',
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        border: Border.all(color: colors.border),
        borderRadius: AppRadius.allMd,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            CircleAvatar(
              radius: AppSpacing.md + AppSpacing.xxs,
              backgroundColor: colors.success.withValues(alpha: 0.15),
              child: Icon(Icons.check_rounded, color: colors.success),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.importedCount(report.writable),
                    style: context.text.headingMedium,
                  ),
                ),
                Text(
                  summary,
                  style: context.text.bodyLarge.copyWith(
                    color: colors.inkMuted,
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                AppButton(
                  label: l10n.viewProducts,
                  onPressed: onViewProductsPressed,
                ),
                AppButton(
                  label: l10n.importAnotherFile,
                  variant: AppButtonVariant.secondary,
                  onPressed: onImportAnotherPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
