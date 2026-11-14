import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

typedef ChangePasswordSubmit = void Function(
  String currentPassword,
  String newPassword,
);

/// Current password, new password and its confirmation. The new-password
/// rules and messages are the website's (reset-password form).
class ChangePasswordForm extends StatefulWidget {
  const new({
    required this.onSubmitted,
    this.alertMessage,
    this.currentPasswordError,
    this.isSubmitting = false,
    super.key,
  });

  final ChangePasswordSubmit onSubmitted;
  final String? alertMessage;
  final String? currentPasswordError;
  final bool isSubmitting;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmitted(_current.text, _new.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rules = Validators(l10n);
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            if (widget.alertMessage case final message?)
              AppFormAlert(message: message, tone: AlertTone.error),
            AppTextField(
              label: l10n.fieldCurrentPassword,
              controller: _current,
              validator: rules.required(l10n.validationCurrentPasswordRequired),
              errorText: widget.currentPasswordError,
              isPassword: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.password],
            ),
            AppTextField(
              label: l10n.fieldNewPassword,
              helperText: l10n.passwordHint,
              controller: _new,
              validator: rules.newPassword,
              isPassword: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
            ),
            AppTextField(
              label: l10n.fieldConfirmPassword,
              controller: _confirm,
              validator: rules.matches(() => _new.text),
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: l10n.changePassword,
              loadingLabel: l10n.changingPassword,
              isLoading: widget.isSubmitting,
              isExpanded: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
