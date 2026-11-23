import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';

/// "Your brands": pick which one the Brand tab shows. Null if closed.
Future<BrandMembership?> showBrandSwitcherSheet(
  BuildContext context, {
  required List<BrandMembership> brands,
  required String selectedId,
}) {
  final l10n = context.l10n;
  return showModalBottomSheet<BrandMembership>(
    context: context,
    // Over the whole app, like dialogs: the tab bar is covered too.
    useRootNavigator: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Semantics(
                header: true,
                child: Text(l10n.yourBrands, style: context.text.headingSmall),
              ),
            ),
            for (final brand in brands)
              ListTile(
                leading: Icon(
                  brand.id == selectedId
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: Text(brand.name),
                subtitle: Text(
                  brand.isOwner ? l10n.brandRoleOwner : l10n.brandRoleStaff,
                ),
                selected: brand.id == selectedId,
                onTap: () => Navigator.of(context).pop(brand),
              ),
          ],
        ),
      ),
    ),
  );
}
