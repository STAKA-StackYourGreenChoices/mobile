import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/layout/dashed_border.dart';

/// Option 2 of proving ownership: a receipt photo or PDF for an admin to
/// check. [fileError] is shown on the file (too big, wrong type); other
/// problems go in [alertMessage].
class ReceiptOption extends StatelessWidget {
  const new({
    required this.uploadsLeft,
    required this.onChoosePressed,
    required this.onSendPressed,
    this.file,
    this.fileError,
    this.alertMessage,
    this.isSending = false,
    this.checkerName,
    super.key,
  });

  final int uploadsLeft;

  /// The brand that checks receipts, when the API names it.
  final String? checkerName;
  final PickedReceipt? file;
  final String? fileError;
  final String? alertMessage;
  final bool isSending;
  final VoidCallback onChoosePressed;
  final VoidCallback onSendPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final file = this.file;
    final error =
        fileError ??
        (file != null && file.isTooLarge ? l10n.fileTooLarge : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(l10n.receiptTitle, style: context.text.label),
        Text(
          switch (checkerName) {
            final brand? => l10n.receiptBodyForBrand(
              brand,
              l10n.uploadsLeft(uploadsLeft),
            ),
            null => l10n.receiptBody(l10n.uploadsLeft(uploadsLeft)),
          },
          style: context.text.bodySmall.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        if (alertMessage case final message?)
          AppFormAlert(message: message, tone: AlertTone.error),
        _FileChooser(
          file: file,
          hasError: error != null,
          onPressed: onChoosePressed,
        ),
        if (error != null)
          Text(
            error,
            style: context.text.bodySmall.copyWith(
              color: context.colors.dangerText,
            ),
          ),
        AppButton(
          label: l10n.sendForReview,
          loadingLabel: l10n.sendingReceipt,
          isLoading: isSending,
          onPressed: file == null || error != null ? null : onSendPressed,
        ),
      ],
    );
  }
}

/// The dashed drop area: "Choose a photo or PDF", or the chosen file's name
/// and size with "Tap to change" — the website's file input.
class _FileChooser extends StatelessWidget {
  const new({required this.onPressed, required this.hasError, this.file});

  final PickedReceipt? file;
  final bool hasError;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final file = this.file;
    final megabytes = file == null
        ? ''
        : (file.sizeBytes / 1024 / 1024).toStringAsFixed(1);
    return Semantics(
      button: true,
      label: file == null
          ? l10n.choosePhotoOrPdf
          : '${file.name}, ${l10n.fileSizeTapToChange(megabytes)}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.allSm,
        child: DashedBorder(
          color: hasError ? colors.danger : colors.borderStrong,
          radius: AppRadius.sm.x,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTapTarget + AppSpacing.xs,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  Icon(Icons.upload_file_rounded, color: colors.brandPrimary),
                  Expanded(
                    child: file == null
                        ? Text(
                            l10n.choosePhotoOrPdf,
                            style: context.text.label.copyWith(
                              color: colors.brandPrimary,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                file.name,
                                style: context.text.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                l10n.fileSizeTapToChange(megabytes),
                                style: context.text.bodySmall.copyWith(
                                  color: colors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
