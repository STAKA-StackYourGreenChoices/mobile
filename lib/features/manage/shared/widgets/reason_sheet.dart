import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// What the API accepts for a reason or note (after trimming).
abstract final class ReasonRules {
  static const minLength = 3;
  static const maxLength = 500;
}

/// A bottom sheet asking an admin for a reason (3–500 characters) before
/// a decision: reject or suspend a brand, resolve a dispute, overrule a
/// claim. [onSubmitted] starts the request that [request] follows; the
/// sheet stays open to show the API's refusal and closes once it is done.
/// True once done.
Future<bool> showReasonSheet(
  BuildContext context, {
  required String title,
  required String body,
  required String fieldLabel,
  required String submitLabel,
  required String submittingLabel,
  required ProviderListenable<RequestState<void>> request,
  required Future<void> Function(String reason) onSubmitted,
  required VoidCallback onClosed,
  bool isDestructive = false,
}) async {
  final container = ProviderScope.containerOf(context);
  final done = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _ReasonSheet(
        title: title,
        body: body,
        fieldLabel: fieldLabel,
        submitLabel: submitLabel,
        submittingLabel: submittingLabel,
        request: request,
        onSubmitted: onSubmitted,
        isDestructive: isDestructive,
      ),
    ),
  );
  onClosed();
  return done ?? false;
}

class _ReasonSheet extends ConsumerStatefulWidget {
  const new({
    required this.title,
    required this.body,
    required this.fieldLabel,
    required this.submitLabel,
    required this.submittingLabel,
    required this.request,
    required this.onSubmitted,
    required this.isDestructive,
  });

  final String title;
  final String body;
  final String fieldLabel;
  final String submitLabel;
  final String submittingLabel;
  final ProviderListenable<RequestState<void>> request;
  final Future<void> Function(String reason) onSubmitted;
  final bool isDestructive;

  @override
  ConsumerState<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends ConsumerState<_ReasonSheet> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmitted(_reason.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final request = ref.watch(widget.request);
    ref.listen(widget.request, (_, next) {
      if (next is RequestDone) Navigator.of(context).pop(true);
    });
    final failure = request is RequestFailed ? request.failure : null;
    final isSending = request is RequestSending;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                Semantics(
                  header: true,
                  child: Text(widget.title, style: context.text.headingMedium),
                ),
                Text(
                  widget.body,
                  style: context.text.bodySmall.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                if (failure != null)
                  AppFormAlert(
                    message: messageForFailure(failure, l10n),
                    tone: AlertTone.error,
                  ),
                AppTextField(
                  label: widget.fieldLabel,
                  controller: _reason,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(ReasonRules.maxLength),
                  ],
                  validator: (value) {
                    final length = (value ?? '').trim().length;
                    if (length < ReasonRules.minLength) {
                      return l10n.noteTooShort;
                    }
                    if (length > ReasonRules.maxLength) {
                      return l10n.noteTooLong;
                    }
                    return null;
                  },
                ),
                AppButton(
                  label: widget.submitLabel,
                  loadingLabel: widget.submittingLabel,
                  variant: widget.isDestructive
                      ? AppButtonVariant.destructive
                      : AppButtonVariant.primary,
                  isLoading: isSending,
                  isExpanded: true,
                  onPressed: _submit,
                ),
                AppButton(
                  label: l10n.cancel,
                  variant: AppButtonVariant.ghost,
                  isExpanded: true,
                  onPressed: isSending
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
