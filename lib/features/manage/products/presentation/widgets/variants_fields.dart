import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_rules.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_values.dart';
import 'package:staka/features/manage/products/presentation/forms/product_save_errors.dart';
import 'package:staka/features/manage/products/presentation/forms/variant_form_values.dart';
import 'package:staka/features/manage/products/presentation/widgets/variant_card.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// "Sizes and colours" (V2-2): one card per size/colour, at least one, and
/// Add a size or colour. Barcodes and SKUs must differ between cards.
class VariantsFields extends StatelessWidget {
  const new({
    required this.values,
    required this.rules,
    required this.serverErrors,
    required this.onOtherCodesPressed,
    super.key,
  });

  final ProductFormValues values;
  final ProductFormRules rules;
  final Map<VariantFieldKey, String> serverErrors;

  /// Null while the product isn't saved yet (no codes can be added).
  final void Function(VariantFormValues variant)? onOtherCodesPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final variants = values.variants;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        Text(
          l10n.variantsHint,
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        for (final (index, variant) in variants.indexed)
          VariantCard(
            key: variant.key,
            number: index + 1,
            variant: variant,
            rules: rules,
            gtinValidator: rules.variantGtin([
              for (final other in variants.take(index)) other.gtin.text,
            ]),
            skuValidator: rules.variantSku([
              for (final other in variants.take(index)) other.sku.text,
            ]),
            serverErrors: {
              for (final MapEntry(:key, :value) in serverErrors.entries)
                if (key.row == index) key.field: value,
            },
            onRemovePressed: variants.length > 1
                ? () => values.removeVariant(variant)
                : null,
            onOtherCodesPressed: switch ((variant.id, onOtherCodesPressed)) {
              (_?, final open?) => () => open(variant),
              _ => null,
            },
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppButton(
            label: l10n.addVariant,
            icon: Icons.add_rounded,
            variant: AppButtonVariant.secondary,
            onPressed: values.addVariant,
          ),
        ),
      ],
    );
  }
}
