import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// "Reason the shopper will see", with the website's common reasons one
/// tap away, how many uploads they keep, Back and Reject receipt.
class RejectReasonForm extends StatefulWidget {
  const new({
    required this.receiptAttempt,
    required this.onSubmitted,
    required this.onBackPressed,
    this.alertMessage,
    this.isSubmitting = false,
    super.key,
  });

  final int? receiptAttempt;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onBackPressed;
  final String? alertMessage;
  final bool isSubmitting;

  @override
  State<RejectReasonForm> createState() => _RejectReasonFormState();
}

class _RejectReasonFormState extends State<RejectReasonForm> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmitted(_reason.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final attempt = widget.receiptAttempt ?? 0;
    final common = [
      l10n.reasonBlurry,
      l10n.reasonProductMissing,
      l10n.reasonWrongShop,
      l10n.reasonCutOff,
    ];
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          if (widget.alertMessage case final message?)
            AppFormAlert(message: message, tone: AlertTone.error),
          AppTextField(
            label: l10n.rejectReasonLabel,
            controller: _reason,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            inputFormatters: [LengthLimitingTextInputFormatter(500)],
            validator: (value) {
              final length = (value ?? '').trim().length;
              if (length < 3) return l10n.reasonTooShort;
              if (length > 500) return l10n.reasonTooLong;
              return null;
            },
          ),
          Semantics(
            label: l10n.commonReasonsLabel,
            container: true,
            child: ListenableBuilder(
              listenable: _reason,
              builder: (context, _) => Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final text in common)
                    _ReasonChip(
                      label: text,
                      isSelected: _reason.text == text,
                      onPressed: () => _reason.text = text,
                    ),
                ],
              ),
            ),
          ),
          Text(
            attempt >= 5
                ? l10n.lastUpload
                : l10n.rejectUploadsLeft(5 - attempt),
            style: context.text.bodyMedium.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          AppButton(
            label: l10n.rejectReceipt,
            loadingLabel: l10n.rejecting,
            variant: AppButtonVariant.destructive,
            isLoading: widget.isSubmitting,
            isExpanded: true,
            onPressed: _submit,
          ),
          AppButton(
            label: l10n.back,
            variant: AppButtonVariant.ghost,
            isExpanded: true,
            onPressed: widget.isSubmitting ? null : widget.onBackPressed,
          ),
        ],
      ),
    );
  }
}

/// A common reason as a pill that wraps long text (Material chips cut it
/// off); selected when it is the reason typed.
class _ReasonChip extends StatelessWidget {
  const new({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected
            ? colors.brandPrimary.withValues(alpha: 0.1)
            : colors.surfaceRaised,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected ? colors.brandPrimary : colors.borderStrong,
          ),
          borderRadius: AppRadius.allMd,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTapTarget - AppSpacing.xxs,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                label,
                style: context.text.bodySmall.copyWith(
                  color: isSelected ? colors.brandPrimary : colors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
