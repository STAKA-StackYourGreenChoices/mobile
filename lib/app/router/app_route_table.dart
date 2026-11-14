import 'package:go_router/go_router.dart';

import 'package:staka/app/launch/launch_screen.dart';
import 'package:staka/app/launch/unreachable_screen.dart';
import 'package:staka/app/pending/pending_screen.dart';
import 'package:staka/app/routes.dart';
import 'package:staka/app/shell/app_navigation_shell.dart';
import 'package:staka/features/auth/presentation/screens/login_screen.dart';
import 'package:staka/features/auth/presentation/screens/register_screen.dart';
import 'package:staka/features/auth/presentation/screens/welcome_screen.dart';

GoRoute _route(AppRoute route, GoRouterWidgetBuilder builder) =>
    GoRoute(path: route.path, name: route.name, builder: builder);

/// Stand-in for a destination whose screen lands in a later slice
/// (PHASE2_PLAN.md §9). PROGRESS.md tracks them; none may remain at Phase 5.
GoRoute _pending(AppRoute route) =>
    _route(route, (_, _) => PendingScreen(route: route));

final appRouteTable = <RouteBase>[
  _route(AppRoute.launch, (_, _) => const LaunchScreen()),
  _route(AppRoute.unreachable, (_, _) => const UnreachableScreen()),
  _route(AppRoute.welcome, (_, _) => const WelcomeScreen()),
  _route(AppRoute.login, (_, _) => const LoginScreen()),
  _route(AppRoute.register, (_, _) => const RegisterScreen()),
  _pending(AppRoute.forgotPassword),
  StatefulShellRoute.indexedStack(
    builder: (_, _, shell) => AppNavigationShell(shell: shell),
    branches: [
      for (final tab in [
        AppRoute.wardrobe,
        AppRoute.scan,
        AppRoute.adminHome,
        AppRoute.account,
      ])
        StatefulShellBranch(routes: [_pending(tab)]),
    ],
  ),
];
