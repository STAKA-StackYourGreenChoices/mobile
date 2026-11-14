import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// Email and "Send reset link" — the website's `ForgotPasswordForm`. After a
/// link is sent, the button offers to send another.
class ForgotPasswordForm extends StatefulWidget {
  const new({
    required this.onSubmitted,
    this.alert,
    this.isSending = false,
    this.hasSent = false,
    super.key,
  });

  final ValueChanged<String> onSubmitted;
  final ({String message, AlertTone tone})? alert;
  final bool isSending;
  final bool hasSent;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmitted(_email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          if (widget.alert case (:final message, :final tone))
            AppFormAlert(message: message, tone: tone),
          AppTextField(
            label: l10n.fieldEmail,
            controller: _email,
            validator: Validators(l10n).email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.send,
            autofillHints: const [AutofillHints.email],
            onSubmitted: (_) => _submit(),
          ),
          AppButton(
            label: widget.hasSent ? l10n.sendAnotherLink : l10n.sendResetLink,
            loadingLabel: l10n.sendingLink,
            isLoading: widget.isSending,
            isExpanded: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
