import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
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
    required this.onChangeNumberPressed,
    this.alertMessage,
    this.isChecking = false,
    this.isResending = false,
    super.key,
  });

  final DateTime resendAvailableAt;
  final DateTime Function() now;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onResendPressed;
  final VoidCallback onChangeNumberPressed;
  final String? alertMessage;
  final bool isChecking;
  final bool isResending;

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
          onCompleted: widget.onSubmitted,
        ),
        ListenableBuilder(
          listenable: _code,
          builder: (context, _) => AppButton(
            label: l10n.checkCode,
            loadingLabel: l10n.checkingCode,
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
            AppButton(
              label: l10n.changeNumber,
              variant: AppButtonVariant.ghost,
              onPressed: widget.onChangeNumberPressed,
            ),
          ],
        ),
      ],
    );
  }
}
