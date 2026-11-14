import 'package:go_router/go_router.dart';

import 'package:staka/app/launch/launch_screen.dart';
import 'package:staka/app/launch/unreachable_screen.dart';
import 'package:staka/app/pending/pending_screen.dart';
import 'package:staka/app/routes.dart';
import 'package:staka/app/shell/app_navigation_shell.dart';
import 'package:staka/features/account/presentation/screens/account_screen.dart';
import 'package:staka/features/auth/presentation/screens/change_password_screen.dart';
import 'package:staka/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:staka/features/auth/presentation/screens/login_screen.dart';
import 'package:staka/features/auth/presentation/screens/register_screen.dart';
import 'package:staka/features/auth/presentation/screens/welcome_screen.dart';
import 'package:staka/features/scan/presentation/screens/scan_screen.dart';
import 'package:staka/features/wardrobe/presentation/screens/wardrobe_screen.dart';

GoRoute _route(
  AppRoute route,
  GoRouterWidgetBuilder builder, {
  List<RouteBase> children = const [],
}) => GoRoute(
  path: route.path,
  name: route.name,
  builder: builder,
  routes: children,
);

/// A screen inside a tab: its path is relative to the tab's route, so
/// `AppRoute.changePassword.path` ('/account/change-password') becomes
/// 'change-password' under `AppRoute.account`.
GoRoute _child(AppRoute parent, AppRoute route, GoRouterWidgetBuilder builder) {
  assert(
    route.path.startsWith('${parent.path}/'),
    '${route.name} under ${parent.name}',
  );
  return GoRoute(
    path: route.path.substring(parent.path.length + 1),
    name: route.name,
    builder: builder,
  );
}

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
  _route(AppRoute.forgotPassword, (_, _) => const ForgotPasswordScreen()),
  StatefulShellRoute.indexedStack(
    builder: (_, _, shell) => AppNavigationShell(shell: shell),
    branches: [
      StatefulShellBranch(
        routes: [_route(AppRoute.wardrobe, (_, _) => const WardrobeScreen())],
      ),
      StatefulShellBranch(
        routes: [
          _route(
            AppRoute.scan,
            (_, _) => const ScanScreen(),
            children: [
              // Slice 12 replaces this with the product screen.
              _child(
                AppRoute.scan,
                AppRoute.product,
                (_, _) => const PendingScreen(route: AppRoute.product),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(routes: [_pending(AppRoute.adminHome)]),
      StatefulShellBranch(
        routes: [
          _route(
            AppRoute.account,
            (_, _) => const AccountScreen(),
            children: [
              _child(
                AppRoute.account,
                AppRoute.changePassword,
                (_, _) => const ChangePasswordScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
