import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/app/router/app_route_table.dart';
import 'package:staka/app/router/session_redirect.dart';
import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';

part 'router.g.dart';

/// The app's single router. Every session change re-runs [redirectFor], so
/// signing in, signing out or an expired session moves the user at once.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final session = ValueNotifier<SessionState>(
    ref.read(sessionControllerProvider),
  );
  ref
    ..listen(sessionControllerProvider, (_, next) => session.value = next)
    ..onDispose(session.dispose);

  final router = GoRouter(
    initialLocation: AppRoute.launch.path,
    refreshListenable: session,
    redirect: (_, state) => redirectFor(session.value, state.uri.path),
    routes: appRouteTable,
  );
  ref.onDispose(router.dispose);
  return router;
}
