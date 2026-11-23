import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The mobile number and "Send code". Hands the number on as E.164.
class PhoneForm extends StatefulWidget {
  const new({
    required this.onSubmitted,
    this.alertMessage,
    this.isSending = false,
    super.key,
  });

  final ValueChanged<String> onSubmitted;
  final String? alertMessage;
  final bool isSending;

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final e164 = PhoneNumber.toE164(_phone.text);
    if (e164 != null) widget.onSubmitted(e164);
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
            label: l10n.fieldPhone,
            controller: _phone,
            helperText: l10n.phoneHelper,
            validator: Validators(l10n).phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumber],
            onSubmitted: (_) => _submit(),
          ),
          AppButton(
            label: l10n.sendCode,
            loadingLabel: l10n.sendingCode,
            isLoading: widget.isSending,
            isExpanded: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
