/// Every route's name and path (guide §9: named routes only).
/// Navigate with `context.goNamed(AppRoute.wardrobe.name)`.
enum AppRoute {
  // App states, not destinations.
  launch('/launch'),
  unreachable('/unreachable'),

  // Signed out only.
  welcome('/welcome'),
  login('/login'),
  register('/register'),
  forgotPassword('/forgot-password'),

  // Signed in: bottom-bar tabs.
  wardrobe('/wardrobe'),
  scan('/scan'),
  account('/account'),
  adminHome('/admin');

  new(this.path);

  final String path;
}

/// Routes only signed-out people see; signed-in people are sent home.
const Set<AppRoute> guestRoutes = {
  AppRoute.welcome,
  AppRoute.login,
  AppRoute.register,
  AppRoute.forgotPassword,
};

/// Where a signed-in person lands, like the website's `/wardrobe`.
const AppRoute homeRoute = AppRoute.wardrobe;
