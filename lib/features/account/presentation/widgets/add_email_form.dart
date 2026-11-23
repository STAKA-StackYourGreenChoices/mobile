import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The email to add to a phone-only account.
class AddEmailForm extends StatefulWidget {
  const new({
    required this.onSubmitted,
    this.alertMessage,
    this.isSubmitting = false,
    super.key,
  });

  final ValueChanged<String> onSubmitted;
  final String? alertMessage;
  final bool isSubmitting;

  @override
  State<AddEmailForm> createState() => _AddEmailFormState();
}

class _AddEmailFormState extends State<AddEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmitted(_email.text);
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
          AppTextField(
            label: l10n.fieldEmail,
            controller: _email,
            validator: Validators(l10n).email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            onSubmitted: (_) => _submit(),
          ),
          AppButton(
            label: l10n.addEmail,
            loadingLabel: l10n.addingEmail,
            isLoading: widget.isSubmitting,
            isExpanded: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
