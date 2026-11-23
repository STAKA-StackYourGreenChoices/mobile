import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The one field a new phone account needs: a name.
class OtpNameForm extends StatefulWidget {
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
  State<OtpNameForm> createState() => _OtpNameFormState();
}

class _OtpNameFormState extends State<OtpNameForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmitted(_name.text.trim());
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
            label: l10n.fieldYourName,
            controller: _name,
            validator: Validators(l10n).name,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.name],
            onSubmitted: (_) => _submit(),
          ),
          AppButton(
            label: l10n.createAccountSubmit,
            loadingLabel: l10n.creatingAccount,
            isLoading: widget.isSubmitting,
            isExpanded: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
