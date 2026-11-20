import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

typedef LoginSubmit = void Function(String email, String password);

/// Email, password, "Forgot your password?" and Sign in — the website's
/// `LoginForm`. Holds only its text; the screen owns the request.
class LoginForm extends StatefulWidget {
  const new({
    required this.onSubmitted,
    required this.onForgotPasswordPressed,
    this.alert,
    this.isSubmitting = false,
    super.key,
  });

  final LoginSubmit onSubmitted;
  final VoidCallback onForgotPasswordPressed;
  final ({String message, AlertTone tone})? alert;
  final bool isSubmitting;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmitted(_email.text, _password.text);
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
            if (widget.alert case (:final message, :final tone))
              AppFormAlert(message: message, tone: tone),
            AppTextField(
              label: l10n.fieldEmail,
              controller: _email,
              validator: rules.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            AppTextField(
              label: l10n.fieldPassword,
              controller: _password,
              validator: rules.password,
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _submit(),
            ),
            AppButton(
              label: l10n.forgotPassword,
              variant: AppButtonVariant.ghost,
              onPressed: widget.onForgotPasswordPressed,
            ),
            AppButton(
              label: l10n.signIn,
              loadingLabel: l10n.signingIn,
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
