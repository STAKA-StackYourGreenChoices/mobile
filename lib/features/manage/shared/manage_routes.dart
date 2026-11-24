import 'package:staka/app/routes.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

/// Where the shared management screens go for each side: the Admin tab's
/// routes for [AdminScope], the Brand tab's for [BrandScope] (the brand
/// itself is the one chosen in the Brand tab).
extension ManageRoutes on ManageScope {
  AppRoute get productsRoute => switch (this) {
    AdminScope() => AppRoute.adminProducts,
    BrandScope() => AppRoute.brandProducts,
  };

  AppRoute get claimsRoute => switch (this) {
    AdminScope() => AppRoute.adminClaims,
    BrandScope() => AppRoute.brandClaims,
  };

  AppRoute get claimRoute => switch (this) {
    AdminScope() => AppRoute.adminClaim,
    BrandScope() => AppRoute.brandClaim,
  };

  AppRoute get claimReceiptRoute => switch (this) {
    AdminScope() => AppRoute.adminClaimReceipt,
    BrandScope() => AppRoute.brandClaimReceipt,
  };
}
