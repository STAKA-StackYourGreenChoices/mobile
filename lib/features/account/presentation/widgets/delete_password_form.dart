import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The password that confirms deleting the account.
class DeletePasswordForm extends StatefulWidget {
  const new({
    required this.onSubmitted,
    this.alertMessage,
    this.passwordError,
    this.isDeleting = false,
    super.key,
  });

  final ValueChanged<String> onSubmitted;
  final String? alertMessage;
  final String? passwordError;
  final bool isDeleting;

  @override
  State<DeletePasswordForm> createState() => _DeletePasswordFormState();
}

class _DeletePasswordFormState extends State<DeletePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmitted(_password.text);
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
          if (widget.alertMessage case final message?)
            AppFormAlert(message: message, tone: AlertTone.error),
          Text(l10n.deleteAccountConfirmPassword),
          AppTextField(
            label: l10n.fieldPassword,
            controller: _password,
            validator: Validators(l10n).password,
            errorText: widget.passwordError,
            isPassword: true,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onSubmitted: (_) => _submit(),
          ),
          AppButton(
            label: l10n.deleteAccount,
            loadingLabel: l10n.deletingAccount,
            variant: AppButtonVariant.destructive,
            isLoading: widget.isDeleting,
            isExpanded: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
