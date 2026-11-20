import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';

/// One bottom-bar tab. [branch] is its index in the router's shell route,
/// which is fixed; the visible order skips Admin for shoppers.
enum ShellTab {
  wardrobe(
    0,
    Icons.checkroom_outlined,
    Icons.checkroom_rounded,
    isAdminOnly: false,
  ),
  scan(
    1,
    Icons.qr_code_scanner_rounded,
    Icons.qr_code_scanner_rounded,
    isAdminOnly: false,
  ),
  admin(
    2,
    Icons.inventory_2_outlined,
    Icons.inventory_2_rounded,
    isAdminOnly: true,
  ),
  account(
    3,
    Icons.account_circle_outlined,
    Icons.account_circle_rounded,
    isAdminOnly: false,
  );

  new(this.branch, this.icon, this.selectedIcon, {required this.isAdminOnly});

  final int branch;
  final IconData icon;
  final IconData selectedIcon;
  final bool isAdminOnly;

  String label(AppLocalizations l10n) => switch (this) {
    ShellTab.wardrobe => l10n.navWardrobe,
    ShellTab.scan => l10n.navScan,
    ShellTab.admin => l10n.navAdmin,
    ShellTab.account => l10n.navAccount,
  };
}

List<ShellTab> visibleTabs({required bool isAdmin}) => [
  for (final tab in ShellTab.values)
    if (isAdmin || !tab.isAdminOnly) tab,
];
