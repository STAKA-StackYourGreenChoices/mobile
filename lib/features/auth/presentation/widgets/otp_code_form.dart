import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/auth/presentation/widgets/resend_code_button.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_otp_field.dart';

/// The six code boxes, Continue, Resend and Change number. Holds only the
/// typed code; give it a new key to clear it (a new code was sent).
class OtpCodeForm extends StatefulWidget {
  const new({
    required this.resendAvailableAt,
    required this.now,
    required this.onSubmitted,
    required this.onResendPressed,
    this.onChangeNumberPressed,
    this.alertMessage,
    this.isChecking = false,
    this.isResending = false,
    this.submitLabel,
    this.submittingLabel,
    this.isDestructive = false,
    this.submitsOnLastDigit = true,
    super.key,
  });

  final DateTime resendAvailableAt;
  final DateTime Function() now;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onResendPressed;

  /// No "Change number" button without it (e.g. the account's own number).
  final VoidCallback? onChangeNumberPressed;
  final String? alertMessage;
  final bool isChecking;
  final bool isResending;

  /// Defaults to "Continue" / "Checking…".
  final String? submitLabel;
  final String? submittingLabel;

  /// The submit button in the danger colour, for deleting the account.
  final bool isDestructive;

  /// False when the code confirms something that can't be undone: the
  /// person presses the button themselves.
  final bool submitsOnLastDigit;

  @override
  State<OtpCodeForm> createState() => _OtpCodeFormState();
}

class _OtpCodeFormState extends State<OtpCodeForm> {
  static const _length = 6;
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (_code.text.length == _length) widget.onSubmitted(_code.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        if (widget.alertMessage case final message?)
          AppFormAlert(message: message, tone: AlertTone.error),
        AppOtpField(
          label: l10n.fieldCode,
          controller: _code,
          hasError: widget.alertMessage != null,
          isEnabled: !widget.isChecking,
          onCompleted: widget.submitsOnLastDigit ? widget.onSubmitted : (_) {},
        ),
        ListenableBuilder(
          listenable: _code,
          builder: (context, _) => AppButton(
            label: widget.submitLabel ?? l10n.checkCode,
            loadingLabel: widget.submittingLabel ?? l10n.checkingCode,
            variant: widget.isDestructive
                ? AppButtonVariant.destructive
                : AppButtonVariant.primary,
            isLoading: widget.isChecking,
            isExpanded: true,
            onPressed: _code.text.length == _length ? _submit : null,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ResendCodeButton(
              availableAt: widget.resendAvailableAt,
              now: widget.now,
              isSending: widget.isResending,
              onPressed: widget.onResendPressed,
            ),
            if (widget.onChangeNumberPressed case final onPressed?)
              AppButton(
                label: l10n.changeNumber,
                variant: AppButtonVariant.ghost,
                onPressed: onPressed,
              ),
          ],
        ),
      ],
    );
  }
}

/// A wrong or expired code gets its own words; anything else is worded
/// like every other request.
String codeFailureMessage(Failure failure, AppLocalizations l10n) =>
    switch (failure) {
      UnauthorizedFailure() => l10n.codeWrong,
      BadRequestFailure(statusCode: 410) => l10n.codeExpired,
      _ => messageForFailure(failure, l10n),
    };
