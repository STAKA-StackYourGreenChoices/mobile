import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';

/// The brand chosen in the sheet: a null `brandId` means "All brands".
typedef BrandPick = ({String? brandId});

/// The website's brand `Select` as a bottom sheet: "All brands", then every
/// brand, the current one ticked. Null if the admin closes the sheet.
Future<BrandPick?> showBrandFilterSheet(
  BuildContext context, {
  required List<BrandSummary> brands,
  required String? selectedId,
}) {
  final l10n = context.l10n;
  final options = <({String? id, String name})>[
    (id: null, name: l10n.allBrands),
    for (final brand in brands) (id: brand.id, name: brand.name),
  ];
  return showModalBottomSheet<BrandPick>(
    context: context,
    // Over the whole app, like dialogs: the tab bar is covered too.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Semantics(
                header: true,
                child: Text(
                  l10n.filterByBrand,
                  style: context.text.headingSmall,
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                children: [
                  for (final option in options)
                    ListTile(
                      title: Text(option.name),
                      selected: option.id == selectedId,
                      trailing: option.id == selectedId
                          ? const Icon(Icons.check_rounded)
                          : null,
                      onTap: () =>
                          Navigator.of(context).pop((brandId: option.id)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
