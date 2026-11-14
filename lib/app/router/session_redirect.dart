import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_state.dart';

/// Where to send someone at [path] given their [session], or null to let
/// them through. The app's version of the website's `proxy.ts` guards;
/// the API stays the real authority (it re-checks the role on every call).
String? redirectFor(SessionState session, String path) {
  bool at(AppRoute route) => path == route.path;
  bool under(AppRoute route) => at(route) || path.startsWith('${route.path}/');
  final atGuestRoute = guestRoutes.any(at);

  String? goTo(AppRoute route) => at(route) ? null : route.path;

  return switch (session) {
    SessionRestoring() => goTo(AppRoute.launch),
    SessionUnreachable() => goTo(AppRoute.unreachable),
    // An ended session goes straight to sign-in, which explains why.
    SignedOut(sessionExpired: true) when !atGuestRoute => AppRoute.login.path,
    SignedOut() => atGuestRoute ? null : AppRoute.welcome.path,
    SignedIn()
        when atGuestRoute || at(AppRoute.launch) || at(AppRoute.unreachable) =>
      homeRoute.path,
    SignedIn(:final user) when under(AppRoute.adminHome) && !user.isAdmin =>
      homeRoute.path,
    SignedIn() => null,
  };
}
