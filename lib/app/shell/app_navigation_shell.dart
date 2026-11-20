import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/shell/shell_tab.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The bottom bar for signed-in screens: Wardrobe, Scan, Admin (admins
/// only), Account — the website's main menu (`web/lib/nav.ts`). Each tab
/// keeps its own back stack.
class AppNavigationShell extends ConsumerWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(
      sessionControllerProvider.select(
        (session) => session is SignedIn && session.user.isAdmin,
      ),
    );
    final tabs = visibleTabs(isAdmin: isAdmin);
    final selected = tabs.indexWhere((tab) => tab.branch == shell.currentIndex);

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected < 0 ? 0 : selected,
        onDestinationSelected: (index) => shell.goBranch(
          tabs[index].branch,
          // Tapping the current tab again returns to its first screen.
          initialLocation: tabs[index].branch == shell.currentIndex,
        ),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label(context.l10n),
            ),
        ],
      ),
    );
  }
}
