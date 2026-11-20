import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/presentation/forms/product_form_rules.dart';
import 'package:staka/features/admin/products/presentation/forms/product_form_values.dart';
import 'package:staka/features/admin/products/presentation/forms/product_save_errors.dart';
import 'package:staka/features/admin/products/presentation/widgets/brand_picker_field.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The form's "Product" section: name, brand, barcode, SKU, description
/// and photo link, with the website's hints and limits.
class ProductDetailsFields extends StatelessWidget {
  const new({
    required this.values,
    required this.rules,
    required this.brands,
    required this.serverErrors,
    required this.onAddBrandPressed,
    super.key,
  });

  final ProductFormValues values;
  final ProductFormRules rules;
  final List<BrandSummary> brands;
  final Map<ProductField, String> serverErrors;
  final VoidCallback onAddBrandPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg - AppSpacing.xxs,
      children: [
        AppTextField(
          label: l10n.fieldProductName,
          controller: values.name,
          helperText: l10n.productNameHint,
          validator: rules.name,
          inputFormatters: [LengthLimitingTextInputFormatter(200)],
          textInputAction: TextInputAction.next,
        ),
        BrandPickerField(
          brands: brands,
          value: values.brandId,
          validator: rules.brand,
          onChanged: (id) => values.brandId = id,
          onAddBrandPressed: onAddBrandPressed,
        ),
        AppTextField(
          label: l10n.fieldBarcode,
          controller: values.gtin,
          helperText: l10n.barcodeHint,
          validator: rules.gtin,
          errorText: serverErrors[ProductField.gtin],
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(14),
          ],
          textInputAction: TextInputAction.next,
        ),
        AppTextField(
          label: l10n.fieldSku,
          controller: values.sku,
          helperText: l10n.skuHint,
          validator: rules.sku,
          errorText: serverErrors[ProductField.sku],
          inputFormatters: [LengthLimitingTextInputFormatter(64)],
          textInputAction: TextInputAction.next,
        ),
        AppTextField(
          label: l10n.fieldDescription,
          controller: values.description,
          helperText: l10n.descriptionHint,
          validator: rules.description,
          inputFormatters: [LengthLimitingTextInputFormatter(2000)],
          keyboardType: TextInputType.multiline,
          maxLines: 4,
        ),
        AppTextField(
          label: l10n.fieldPhotoLink,
          controller: values.imageUrl,
          hint: l10n.photoLinkPlaceholder,
          helperText: l10n.photoLinkHint,
          validator: rules.imageUrl,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
