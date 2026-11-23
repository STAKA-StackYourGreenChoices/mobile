import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_search_field.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// Search, brand filter and Clear: the website's `ProductFilters`.
///
/// [brandLabel] is the chosen brand's name ("All brands" when none); null
/// hides the brand filter because the brands could not be loaded. A null
/// [onBrandPressed] disables it while they load.
class ProductFilters extends StatelessWidget {
  const new({
    required this.filter,
    required this.brandLabel,
    required this.onSearch,
    required this.onBrandPressed,
    required this.onClearPressed,
    super.key,
  });

  final ProductFilter filter;
  final String? brandLabel;
  final ValueChanged<String> onSearch;
  final VoidCallback? onBrandPressed;
  final VoidCallback onClearPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        ProductSearchField(value: filter.search, onSearch: onSearch),
        Row(
          spacing: AppSpacing.sm,
          children: [
            if (brandLabel case final label?)
              Expanded(
                child: Semantics(
                  label: l10n.filterByBrand,
                  child: OutlinedButton.icon(
                    onPressed: onBrandPressed,
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.expand_more_rounded),
                    label: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(label, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ),
            if (filter.isFiltered)
              AppButton(
                label: l10n.clearFilters,
                icon: Icons.close_rounded,
                variant: AppButtonVariant.ghost,
                onPressed: onClearPressed,
              ),
          ],
        ),
      ],
    );
  }
}
