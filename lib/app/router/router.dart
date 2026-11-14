import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/app/router/app_route_table.dart';
import 'package:staka/app/router/session_redirect.dart';
import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';

part 'router.g.dart';

/// The app's single router. A session change that matters for navigation
/// re-runs [redirectFor], so signing in, signing out or an expired session
/// moves the user at once.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final session = ref.read(sessionControllerProvider);
  final routing = ValueNotifier(routingKeyOf(session));
  ref
    ..listen(
      sessionControllerProvider,
      (_, next) => routing.value = routingKeyOf(next),
    )
    ..onDispose(routing.dispose);

  final router = GoRouter(
    initialLocation: AppRoute.launch.path,
    refreshListenable: routing,
    redirect: (_, state) =>
        redirectFor(ref.read(sessionControllerProvider), state.uri.path),
    routes: appRouteTable,
  );
  ref.onDispose(router.dispose);
  return router;
}

/// The parts of a session the redirect rules depend on. Re-reading the user
/// or rotating tokens keeps the same key, so the router is not refreshed:
/// a needless refresh can land after a `pop()` and redraw the old screen.
@visibleForTesting
Object routingKeyOf(SessionState session) => switch (session) {
  SignedIn(:final user) => (SignedIn, user.isAdmin),
  SignedOut(:final reason) => (SignedOut, reason),
  _ => session.runtimeType,
};
