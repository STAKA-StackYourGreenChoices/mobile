import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

typedef RegisterSubmit = void Function(
  String name,
  String email,
  String password,
);

/// Name, email and password — the website's `RegisterForm`, with its hints.
/// [emailError] is the API's "already used" answer, shown on the field.
class RegisterForm extends StatefulWidget {
  const new({
    required this.onSubmitted,
    this.alertMessage,
    this.emailError,
    this.isSubmitting = false,
    super.key,
  });

  final RegisterSubmit onSubmitted;
  final String? alertMessage;
  final String? emailError;
  final bool isSubmitting;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmitted(_name.text, _email.text, _password.text);
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
              label: l10n.fieldYourName,
              helperText: l10n.nameHint,
              controller: _name,
              validator: rules.name,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
            ),
            AppTextField(
              label: l10n.fieldEmail,
              controller: _email,
              validator: rules.email,
              errorText: widget.emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            AppTextField(
              label: l10n.fieldPassword,
              helperText: l10n.passwordHint,
              controller: _password,
              validator: rules.newPassword,
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: l10n.createAccountSubmit,
              loadingLabel: l10n.creatingAccount,
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
