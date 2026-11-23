import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_rules.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_values.dart';
import 'package:staka/features/manage/products/presentation/widgets/form_switch_row.dart';
import 'package:staka/shared/formatters/carbon_format.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The form's "Sustainability figures" section. Figures can be switched
/// on for a product without them, but never removed once saved; "Verified
/// by" appears only for third-party verified figures.
class FiguresFields extends StatelessWidget {
  const new({required this.values, required this.rules, super.key});

  final ProductFormValues values;
  final ProductFormRules rules;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final digits = FilteringTextInputFormatter.digitsOnly;
    return ListenableBuilder(
      listenable: values,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg - AppSpacing.xxs,
        children: [
          if (values.canRemoveFigures)
            FormSwitchRow(
              label: l10n.includeFigures,
              value: values.hasFigures,
              onChanged: (on) => values.hasFigures = on,
            ),
          if (values.hasFigures) ...[
            AppTextField(
              label: l10n.fieldCarbon,
              controller: values.carbon,
              helperText: switch (int.tryParse(values.carbon.text)) {
                final grams? => l10n.carbonShownAs(formatCarbon(grams, l10n)),
                null => l10n.carbonHint,
              },
              validator: rules.carbon,
              keyboardType: TextInputType.number,
              inputFormatters: [digits, LengthLimitingTextInputFormatter(9)],
              textInputAction: TextInputAction.next,
            ),
            AppTextField(
              label: l10n.fieldRecyclable,
              controller: values.recyclability,
              helperText: l10n.recyclableHint,
              validator: rules.recyclability,
              keyboardType: TextInputType.number,
              inputFormatters: [digits, LengthLimitingTextInputFormatter(3)],
            ),
            FormSwitchRow(
              label: l10n.verifiedByThirdParty,
              description: l10n.verifiedByThirdPartyHint,
              value: values.isVerified,
              onChanged: (on) => values.isVerified = on,
            ),
            if (values.isVerified)
              AppTextField(
                label: l10n.fieldCertifier,
                controller: values.certifier,
                helperText: l10n.certifierHint,
                validator: rules.certifier,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
              ),
          ],
        ],
      ),
    );
  }
}
