import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';

/// Who sees a tab.
enum TabAudience { everyone, brandMembers, admins }

/// One bottom-bar tab. [branch] is its index in the router's shell route,
/// which is fixed; the visible order (this enum's) skips Brand for people
/// without an approved brand and Admin for non-admins.
enum ShellTab {
  wardrobe(
    0,
    Icons.checkroom_outlined,
    Icons.checkroom_rounded,
    TabAudience.everyone,
  ),
  scan(
    1,
    Icons.qr_code_scanner_rounded,
    Icons.qr_code_scanner_rounded,
    TabAudience.everyone,
  ),
  brand(
    4,
    Icons.storefront_outlined,
    Icons.storefront_rounded,
    TabAudience.brandMembers,
  ),
  admin(
    2,
    Icons.inventory_2_outlined,
    Icons.inventory_2_rounded,
    TabAudience.admins,
  ),
  account(
    3,
    Icons.account_circle_outlined,
    Icons.account_circle_rounded,
    TabAudience.everyone,
  );

  new(this.branch, this.icon, this.selectedIcon, this.audience);

  final int branch;
  final IconData icon;
  final IconData selectedIcon;
  final TabAudience audience;

  String label(AppLocalizations l10n) => switch (this) {
    ShellTab.wardrobe => l10n.navWardrobe,
    ShellTab.scan => l10n.navScan,
    ShellTab.brand => l10n.navBrand,
    ShellTab.admin => l10n.navAdmin,
    ShellTab.account => l10n.navAccount,
  };
}

List<ShellTab> visibleTabs({
  required bool isAdmin,
  required bool hasBrandPortal,
}) => [
  for (final tab in ShellTab.values)
    if (switch (tab.audience) {
      TabAudience.everyone => true,
      TabAudience.brandMembers => hasBrandPortal,
      TabAudience.admins => isAdmin,
    })
      tab,
];
