import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_rules.dart';
import 'package:staka/features/manage/products/presentation/forms/product_save_errors.dart';
import 'package:staka/features/manage/products/presentation/forms/variant_form_values.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// One size/colour (V2-2): barcode, SKU, size, colour, and its other shop
/// codes. [onRemovePressed] is null for the only one left;
/// [onOtherCodesPressed] is null until it is saved.
class VariantCard extends StatelessWidget {
  const new({
    required this.number,
    required this.variant,
    required this.rules,
    required this.gtinValidator,
    required this.skuValidator,
    required this.serverErrors,
    this.onRemovePressed,
    this.onOtherCodesPressed,
    super.key,
  });

  /// From 1, for the heading.
  final int number;
  final VariantFormValues variant;
  final ProductFormRules rules;
  final Validator gtinValidator;
  final Validator skuValidator;
  final Map<ProductField, String> serverErrors;
  final VoidCallback? onRemovePressed;
  final VoidCallback? onOtherCodesPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        border: Border.all(color: context.colors.border),
        borderRadius: AppRadius.allMd,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.variantHeading(number),
                      style: context.text.label,
                    ),
                  ),
                ),
                if (onRemovePressed case final onRemove?)
                  Semantics(
                    label: l10n.removeVariantLabel(number),
                    button: true,
                    excludeSemantics: true,
                    child: TextButton.icon(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text(l10n.removeVariant),
                    ),
                  )
                else
                  // Keeps the heading the same height as with the button.
                  const SizedBox(height: AppSpacing.xxl),
              ],
            ),
            AppTextField(
              label: l10n.fieldBarcode,
              controller: variant.gtin,
              helperText: l10n.barcodeHint,
              validator: gtinValidator,
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
              controller: variant.sku,
              helperText: l10n.skuHint,
              validator: skuValidator,
              errorText: serverErrors[ProductField.sku],
              inputFormatters: [LengthLimitingTextInputFormatter(64)],
              textInputAction: TextInputAction.next,
            ),
            AppTextField(
              label: l10n.fieldSize,
              controller: variant.size,
              helperText: l10n.sizeHint,
              validator: rules.size,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              textInputAction: TextInputAction.next,
            ),
            AppTextField(
              label: l10n.fieldColour,
              controller: variant.colour,
              helperText: l10n.colourHint,
              validator: rules.colour,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              textInputAction: TextInputAction.next,
            ),
            if (onOtherCodesPressed case final onOtherCodes?)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: onOtherCodes,
                  icon: const Icon(Icons.qr_code_2_rounded),
                  label: Text(l10n.otherShopCodes(variant.aliases.length)),
                ),
              )
            else
              Text(
                l10n.otherShopCodesSaveFirst,
                style: context.text.bodySmall.copyWith(
                  color: context.colors.inkMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
