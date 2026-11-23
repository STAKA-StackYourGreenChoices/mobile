import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/brand_apply/domain/models/brand_file.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// A heading, its help, and either a button to pick the file or the picked
/// file with Replace and Remove. [keptNote] says a file sent earlier stays
/// (resubmit); [errorText] is why a pick was refused (too large).
class BrandFileField extends StatelessWidget {
  const new({
    required this.title,
    required this.hint,
    required this.chooseLabel,
    required this.chooseIcon,
    required this.file,
    required this.onChoosePressed,
    required this.onRemovePressed,
    this.keptNote,
    this.errorText,
    super.key,
  });

  final String title;
  final String hint;
  final String chooseLabel;
  final IconData chooseIcon;
  final BrandFile? file;
  final VoidCallback onChoosePressed;
  final VoidCallback onRemovePressed;
  final String? keptNote;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final muted = context.text.bodySmall.copyWith(color: colors.inkMuted);
    final file = this.file;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: context.text.label),
        const SizedBox(height: AppSpacing.xxs),
        Text(hint, style: muted),
        if (keptNote case final note? when file == null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(note, style: muted),
        ],
        const SizedBox(height: AppSpacing.xs),
        if (file == null)
          AppButton(
            label: chooseLabel,
            icon: chooseIcon,
            variant: AppButtonVariant.secondary,
            isExpanded: true,
            onPressed: onChoosePressed,
          )
        else
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              border: Border.all(color: colors.border),
              borderRadius: AppRadius.allSm,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  _Preview(file),
                  Expanded(
                    child: Text(
                      file.name,
                      style: context.text.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: onChoosePressed,
                    child: Text(l10n.replaceFile),
                  ),
                  TextButton(
                    onPressed: onRemovePressed,
                    child: Text(l10n.removeFile),
                  ),
                ],
              ),
            ),
          ),
        if (errorText case final error?) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            error,
            style: context.text.bodySmall.copyWith(color: colors.dangerText),
          ),
        ],
      ],
    );
  }
}

/// The picked photo, small; a PDF icon for a PDF.
class _Preview extends StatelessWidget {
  const new(this.file);

  final BrandFile file;

  static const double _size = AppSpacing.xxl;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: AppRadius.allSm,
      child: SizedBox.square(
        dimension: _size,
        child: file.isPdf
            ? ColoredBox(
                color: colors.surfaceSunken,
                child: Icon(
                  Icons.picture_as_pdf_outlined,
                  color: colors.inkMuted,
                ),
              )
            : Image.memory(
                file.bytes,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: colors.surfaceSunken,
                  child: Icon(Icons.image_outlined, color: colors.inkMuted),
                ),
              ),
      ),
    );
  }
}
