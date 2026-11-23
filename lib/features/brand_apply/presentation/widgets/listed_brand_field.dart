import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_applications_controller.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';

/// "My brand is already on STAKA": a switch, and when it's on, the brands
/// STAKA lists to pick from (`existingBrandId`).
class ListedBrandField extends ConsumerWidget {
  const new({
    required this.isClaiming,
    required this.brandId,
    required this.validator,
    required this.onClaimingChanged,
    required this.onBrandChanged,
    super.key,
  });

  final bool isClaiming;
  final String? brandId;
  final Validator validator;
  final ValueChanged<bool> onClaimingChanged;
  final ValueChanged<BrandSummary> onBrandChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          value: isClaiming,
          onChanged: onClaimingChanged,
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.brandAlreadyListed, style: context.text.label),
          subtitle: Text(
            l10n.brandAlreadyListedHint,
            style: context.text.bodySmall.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
        ),
        if (isClaiming) ...[
          const SizedBox(height: AppSpacing.xs),
          switch (ref.watch(listedBrandsProvider)) {
            AsyncData(value: Ok(value: final brands)) => _BrandDropdown(
              brands: brands,
              brandId: brandId,
              validator: validator,
              onChanged: onBrandChanged,
            ),
            AsyncData(value: Err()) || AsyncError() => Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.listedBrandsFailed,
                    style: context.text.bodySmall.copyWith(
                      color: context.colors.dangerText,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(listedBrandsProvider),
                  child: Text(l10n.tryAgain),
                ),
              ],
            ),
            _ => const Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: AppLoader(),
            ),
          },
        ],
      ],
    );
  }
}

class _BrandDropdown extends StatelessWidget {
  const new({
    required this.brands,
    required this.brandId,
    required this.validator,
    required this.onChanged,
  });

  final List<BrandSummary> brands;
  final String? brandId;
  final Validator validator;
  final ValueChanged<BrandSummary> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // A brand that has since left the list isn't offered.
    final value = brands.any((brand) => brand.id == brandId) ? brandId : null;
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      style: context.text.bodyLarge.copyWith(color: context.colors.ink),
      validator: validator,
      onChanged: (id) {
        for (final brand in brands) {
          if (brand.id == id) onChanged(brand);
        }
      },
      hint: Text(
        l10n.chooseYourBrand,
        style: context.text.bodyLarge.copyWith(color: context.colors.inkMuted),
      ),
      items: [
        for (final brand in brands)
          DropdownMenuItem(
            value: brand.id,
            child: Text(brand.name, overflow: TextOverflow.ellipsis),
          ),
      ],
    );
  }
}
