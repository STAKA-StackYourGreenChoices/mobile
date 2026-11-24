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
  phoneSignIn('/phone'),
  otpCode('/phone/code'),
  otpName('/phone/name'),

  // Signed in: bottom-bar tabs.
  wardrobe('/wardrobe'),
  scan('/scan'),
  account('/account'),
  adminHome('/admin'),
  brandHome('/brand'),

  // Inside a tab (keep the bottom bar).
  changePassword('/account/change-password'),
  accountPhone('/account/phone'),
  addEmail('/account/email'),
  setPassword('/account/set-password'),
  deleteAccount('/account/delete'),
  brandApplications('/account/brand'),
  brandApply('/account/brand/apply'),
  brandApplicationEdit('/account/brand/:id/edit'),
  product('/scan/product/:gtin'),
  tag('/wardrobe/tag/:id'),
  adminProducts('/admin/products'),
  adminBrands('/admin/brands'),
  adminBrand('/admin/brands/:id'),
  adminBrandDocument('/admin/brands/:id/document'),
  adminDisputes('/admin/disputes'),
  adminDispute('/admin/disputes/:id'),
  adminDisputeReceipt('/admin/disputes/:id/receipt/:claimId'),
  adminClaims('/admin/claims'),
  adminClaim('/admin/claims/:id'),
  adminClaimReceipt('/admin/claims/:id/receipt'),
  brandProducts('/brand/products'),
  brandProductNew('/brand/products/new'),
  brandProductEdit('/brand/products/:id'),
  brandImport('/brand/import'),
  brandClaims('/brand/claims'),
  brandClaim('/brand/claims/:id'),
  brandClaimReceipt('/brand/claims/:id/receipt'),
  brandTeam('/brand/team'),
  brandSettings('/brand/settings');

  new(this.path);

  final String path;
}

/// Routes only signed-out people see; signed-in people are sent home.
const Set<AppRoute> guestRoutes = {
  AppRoute.welcome,
  AppRoute.login,
  AppRoute.register,
  AppRoute.forgotPassword,
  AppRoute.phoneSignIn,
  AppRoute.otpCode,
  AppRoute.otpName,
};

/// Where a signed-in person lands, like the website's `/wardrobe`.
const AppRoute homeRoute = AppRoute.wardrobe;
