import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';
import 'package:staka/features/manage/import/presentation/widgets/file_needs.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/layout/dashed_border.dart';

/// Step 1: a dashed box to pick a CSV (showing the chosen one), the
/// template, "Check file", and what the file needs.
class ChooseFilePanel extends StatelessWidget {
  const new({
    required this.file,
    required this.isChecking,
    required this.isFetchingTemplate,
    required this.onChoosePressed,
    required this.onCheckPressed,
    required this.onTemplatePressed,
    super.key,
  });

  final PickedCsv? file;
  final bool isChecking;
  final bool isFetchingTemplate;
  final VoidCallback onChoosePressed;
  final VoidCallback onCheckPressed;

  /// Given the button's place on screen, for the iPad share popover.
  final ValueChanged<Rect?> onTemplatePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        _DropBox(file: file, onPressed: isChecking ? null : onChoosePressed),
        AppButton(
          label: l10n.checkFile,
          loadingLabel: l10n.checkingFile,
          isLoading: isChecking,
          isExpanded: true,
          onPressed: file == null ? null : onCheckPressed,
        ),
        Builder(
          builder: (context) => AppButton(
            label: l10n.downloadTemplate,
            icon: Icons.download_rounded,
            variant: AppButtonVariant.ghost,
            isLoading: isFetchingTemplate,
            onPressed: () => onTemplatePressed(_rectOf(context)),
          ),
        ),
        const FileNeeds(),
      ],
    );
  }

  static Rect? _rectOf(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

class _DropBox extends StatelessWidget {
  const new({required this.file, required this.onPressed});

  final PickedCsv? file;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final chosen = file;
    return Material(
      color: colors.surfaceRaised,
      borderRadius: AppRadius.allMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: DashedBorder(
          color: colors.borderStrong,
          radius: AppRadius.md.x,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  chosen == null
                      ? Icons.upload_file_outlined
                      : Icons.description_outlined,
                  size: AppSizes.iconFeature + AppSpacing.xxs,
                  color: colors.brandPrimary,
                ),
                Text(
                  chosen?.name ?? l10n.chooseCsvFile,
                  textAlign: TextAlign.center,
                  style: chosen == null
                      ? context.text.label.copyWith(color: colors.brandPrimary)
                      : context.text.label,
                ),
                Text(
                  chosen == null
                      ? l10n.csvLimits
                      : l10n.chosenFileSize(_kilobytes(chosen.sizeBytes)),
                  textAlign: TextAlign.center,
                  style: context.text.bodySmall.copyWith(
                    color: colors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// One decimal under 10 KB, like the website.
  static String _kilobytes(int bytes) =>
      (bytes / 1024).toStringAsFixed(bytes < 10240 ? 1 : 0);
}
