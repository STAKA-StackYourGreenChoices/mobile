import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';

/// "Brand": choose one from the list, with the website's "Missing one? Add
/// it on the Brands page." link under it (when [onAddBrandPressed] is
/// given). [isLocked] shows the brand without letting it change (a brand's
/// own products).
class BrandPickerField extends StatelessWidget {
  const new({
    required this.brands,
    required this.value,
    required this.validator,
    required this.onChanged,
    required this.onAddBrandPressed,
    this.isLocked = false,
    super.key,
  });

  final List<BrandSummary> brands;
  final String? value;
  final Validator validator;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onAddBrandPressed;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.text.bodySmall.copyWith(
      color: context.colors.inkMuted,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fieldBrand, style: context.text.label),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          style: context.text.bodyLarge.copyWith(color: context.colors.ink),
          validator: validator,
          onChanged: isLocked ? null : onChanged,
          hint: Text(
            l10n.chooseBrand,
            style: context.text.bodyLarge.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          items: [
            for (final brand in brands)
              DropdownMenuItem(
                value: brand.id,
                child: Text(brand.name, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
        if (onAddBrandPressed case final onAddBrandPressed?)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.brandMissing, style: muted),
              TextButton(
                onPressed: onAddBrandPressed,
                child: Text(l10n.addBrandLink),
              ),
            ],
          ),
      ],
    );
  }
}
