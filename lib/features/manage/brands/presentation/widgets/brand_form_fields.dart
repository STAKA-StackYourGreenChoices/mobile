import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/brands/presentation/forms/brand_form_rules.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// Brand name, About the brand and Logo link, with the website's hints and
/// limits. [nameError] is the API's refusal ("A brand with this name
/// already exists").
class BrandFormFields extends StatelessWidget {
  const new({
    required this.name,
    required this.description,
    required this.logoUrl,
    this.nameError,
    super.key,
  });

  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController logoUrl;
  final String? nameError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rules = BrandFormRules(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg - AppSpacing.xxs,
      children: [
        AppTextField(
          label: l10n.fieldBrandName,
          controller: name,
          validator: rules.name,
          errorText: nameError,
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          textInputAction: TextInputAction.next,
        ),
        AppTextField(
          label: l10n.fieldAboutBrand,
          controller: description,
          helperText: l10n.aboutBrandHint,
          validator: rules.description,
          inputFormatters: [LengthLimitingTextInputFormatter(1000)],
          keyboardType: TextInputType.multiline,
          maxLines: 3,
        ),
        AppTextField(
          label: l10n.fieldLogoLink,
          controller: logoUrl,
          hint: l10n.photoLinkPlaceholder,
          helperText: l10n.optionalHint,
          validator: rules.logoUrl,
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }
}
