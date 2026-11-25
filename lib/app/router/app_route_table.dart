import 'package:flutter/foundation.dart' show ValueKey;
import 'package:go_router/go_router.dart';
import 'package:staka/app/launch/launch_screen.dart';
import 'package:staka/app/launch/unreachable_screen.dart';
import 'package:staka/app/routes.dart';
import 'package:staka/app/shell/app_navigation_shell.dart';
import 'package:staka/features/account/presentation/screens/account_phone_screen.dart';
import 'package:staka/features/account/presentation/screens/account_screen.dart';
import 'package:staka/features/account/presentation/screens/add_email_screen.dart';
import 'package:staka/features/account/presentation/screens/delete_account_screen.dart';
import 'package:staka/features/account/presentation/screens/set_password_screen.dart';
import 'package:staka/features/auth/presentation/screens/change_password_screen.dart';
import 'package:staka/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:staka/features/auth/presentation/screens/login_screen.dart';
import 'package:staka/features/auth/presentation/screens/otp_code_screen.dart';
import 'package:staka/features/auth/presentation/screens/otp_name_screen.dart';
import 'package:staka/features/auth/presentation/screens/phone_sign_in_screen.dart';
import 'package:staka/features/auth/presentation/screens/register_screen.dart';
import 'package:staka/features/auth/presentation/screens/welcome_screen.dart';
import 'package:staka/features/brand_apply/presentation/screens/brand_application_form_screen.dart';
import 'package:staka/features/brand_apply/presentation/screens/brand_applications_screen.dart';
import 'package:staka/features/brand_portal/presentation/screens/brand_home_screen.dart';
import 'package:staka/features/brand_portal/presentation/screens/brand_settings_screen.dart';
import 'package:staka/features/brand_portal/presentation/screens/brand_team_screen.dart';
import 'package:staka/features/brand_portal/presentation/widgets/current_brand_builder.dart';
import 'package:staka/features/manage/analytics/presentation/analytics_screen.dart';
import 'package:staka/features/manage/brand_review/presentation/screens/admin_brand_screen.dart';
import 'package:staka/features/manage/brand_review/presentation/screens/admin_brands_screen.dart';
import 'package:staka/features/manage/brand_review/presentation/screens/brand_document_screen.dart';
import 'package:staka/features/manage/claims/presentation/screens/admin_claim_screen.dart';
import 'package:staka/features/manage/claims/presentation/screens/admin_claims_screen.dart';
import 'package:staka/features/manage/claims/presentation/screens/claim_receipt_screen.dart';
import 'package:staka/features/manage/disputes/presentation/screens/admin_dispute_screen.dart';
import 'package:staka/features/manage/disputes/presentation/screens/admin_disputes_screen.dart';
import 'package:staka/features/manage/hub/presentation/screens/admin_home_screen.dart';
import 'package:staka/features/manage/import/presentation/screens/admin_import_screen.dart';
import 'package:staka/features/manage/products/presentation/screens/admin_product_form_screen.dart';
import 'package:staka/features/manage/products/presentation/screens/admin_products_screen.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/features/notifications/presentation/screens/notification_settings_screen.dart';
import 'package:staka/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:staka/features/products/presentation/screens/product_screen.dart';
import 'package:staka/features/rewards/presentation/screens/points_history_screen.dart';
import 'package:staka/features/rewards/presentation/screens/reward_detail_screen.dart';
import 'package:staka/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:staka/features/scan/presentation/screens/scan_screen.dart';
import 'package:staka/features/tags/presentation/screens/tag_screen.dart';
import 'package:staka/features/wardrobe/presentation/screens/activity_screen.dart';
import 'package:staka/features/wardrobe/presentation/screens/wardrobe_screen.dart';
import 'package:staka/features/wardrobe/presentation/screens/wardrobe_share_screen.dart';

/// The Admin tab works on every brand (V2-12 adds a Brand tab with
/// `BrandScope`).
const _admin = AdminScope();

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
GoRoute _child(
  AppRoute parent,
  AppRoute route,
  GoRouterWidgetBuilder builder, {
  List<RouteBase> children = const [],
}) {
  assert(
    route.path.startsWith('${parent.path}/'),
    '${route.name} under ${parent.name}',
  );
  return GoRoute(
    path: route.path.substring(parent.path.length + 1),
    name: route.name,
    builder: builder,
    routes: children,
  );
}

final appRouteTable = <RouteBase>[
  _route(AppRoute.launch, (_, _) => const LaunchScreen()),
  _route(AppRoute.unreachable, (_, _) => const UnreachableScreen()),
  _route(AppRoute.welcome, (_, _) => const WelcomeScreen()),
  _route(AppRoute.login, (_, _) => const LoginScreen()),
  _route(AppRoute.register, (_, _) => const RegisterScreen()),
  _route(AppRoute.forgotPassword, (_, _) => const ForgotPasswordScreen()),
  _route(AppRoute.phoneSignIn, (_, _) => const PhoneSignInScreen()),
  _route(AppRoute.otpCode, (_, _) => const OtpCodeScreen()),
  _route(AppRoute.otpName, (_, _) => const OtpNameScreen()),
  StatefulShellRoute.indexedStack(
    builder: (_, _, shell) => AppNavigationShell(shell: shell),
    branches: [
      StatefulShellBranch(
        routes: [
          _route(
            AppRoute.wardrobe,
            (_, _) => const WardrobeScreen(),
            children: [
              _child(
                AppRoute.wardrobe,
                AppRoute.tag,
                (_, state) => TagScreen(
                  cardId: state.pathParameters['id'] ?? '',
                  isJustAdded: state.uri.queryParameters['added'] == '1',
                ),
              ),
              _child(
                AppRoute.wardrobe,
                AppRoute.wardrobeShare,
                (_, _) => const WardrobeShareScreen(),
              ),
              _child(
                AppRoute.wardrobe,
                AppRoute.activity,
                (_, _) => const ActivityScreen(),
              ),
              _child(
                AppRoute.wardrobe,
                AppRoute.notifications,
                (_, _) => const NotificationsScreen(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          _route(
            AppRoute.scan,
            (_, _) => const ScanScreen(),
            children: [
              _child(
                AppRoute.scan,
                AppRoute.product,
                (_, state) => ProductScreen(
                  gtin: state.pathParameters['gtin'] ?? '',
                  isScan: state.uri.queryParameters['scan'] == '1',
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          _route(
            AppRoute.adminHome,
            (_, _) => const AdminHomeScreen(),
            children: [
              _child(
                AppRoute.adminHome,
                AppRoute.adminAnalytics,
                (_, _) => const AnalyticsScreen(scope: _admin),
              ),
              _child(
                AppRoute.adminHome,
                AppRoute.adminProducts,
                (_, state) => AdminProductsScreen(
                  key: ValueKey(state.uri.queryParameters['brand']),
                  scope: _admin,
                  brandId: state.uri.queryParameters['brand'],
                ),
              ),
              _child(
                AppRoute.adminHome,
                AppRoute.adminBrands,
                (_, _) => const AdminBrandsScreen(),
                children: [
                  _child(
                    AppRoute.adminBrands,
                    AppRoute.adminBrand,
                    (_, state) => AdminBrandScreen(
                      key: ValueKey(state.pathParameters['id']),
                      brandId: state.pathParameters['id'] ?? '',
                    ),
                    children: [
                      _child(
                        AppRoute.adminBrand,
                        AppRoute.adminBrandDocument,
                        (_, state) => BrandDocumentScreen(
                          brandId: state.pathParameters['id'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _child(
                AppRoute.adminHome,
                AppRoute.adminDisputes,
                (_, _) => const AdminDisputesScreen(),
                children: [
                  _child(
                    AppRoute.adminDisputes,
                    AppRoute.adminDispute,
                    (_, state) => AdminDisputeScreen(
                      key: ValueKey(state.pathParameters['id']),
                      disputeId: state.pathParameters['id'] ?? '',
                    ),
                    children: [
                      _child(
                        AppRoute.adminDispute,
                        AppRoute.adminDisputeReceipt,
                        (_, state) => ClaimReceiptScreen(
                          scope: _admin,
                          claimId: state.pathParameters['claimId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _child(
                AppRoute.adminHome,
                AppRoute.adminClaims,
                (_, _) => const AdminClaimsScreen(scope: _admin),
                children: [
                  _child(
                    AppRoute.adminClaims,
                    AppRoute.adminClaim,
                    (_, state) => AdminClaimScreen(
                      key: ValueKey(state.pathParameters['id']),
                      scope: _admin,
                      claimId: state.pathParameters['id'] ?? '',
                    ),
                    children: [
                      _child(
                        AppRoute.adminClaim,
                        AppRoute.adminClaimReceipt,
                        (_, state) => ClaimReceiptScreen(
                          scope: _admin,
                          claimId: state.pathParameters['id'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
              _child(
                AppRoute.account,
                AppRoute.accountPhone,
                (_, _) => const AccountPhoneScreen(),
              ),
              _child(
                AppRoute.account,
                AppRoute.addEmail,
                (_, _) => const AddEmailScreen(),
              ),
              _child(
                AppRoute.account,
                AppRoute.setPassword,
                (_, _) => const SetPasswordScreen(),
              ),
              _child(
                AppRoute.account,
                AppRoute.deleteAccount,
                (_, _) => const DeleteAccountScreen(),
              ),
              _child(
                AppRoute.account,
                AppRoute.notificationSettings,
                (_, _) => const NotificationSettingsScreen(),
              ),
              _child(
                AppRoute.account,
                AppRoute.brandApplications,
                (_, _) => const BrandApplicationsScreen(),
                children: [
                  _child(
                    AppRoute.brandApplications,
                    AppRoute.brandApply,
                    (_, _) => const BrandApplicationFormScreen(),
                  ),
                  _child(
                    AppRoute.brandApplications,
                    AppRoute.brandApplicationEdit,
                    (_, state) => BrandApplicationFormScreen(
                      key: ValueKey(state.pathParameters['id']),
                      applicationId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Branch 4 (ShellTab.brand): shown between Scan and Admin.
      StatefulShellBranch(
        routes: [
          _route(
            AppRoute.brandHome,
            (_, _) => const BrandHomeScreen(),
            children: [
              _child(
                AppRoute.brandHome,
                AppRoute.brandProducts,
                (_, _) => CurrentBrandBuilder(
                  builder: (_, scope) => AdminProductsScreen(scope: scope),
                ),
                children: [
                  // 'new' before ':id', or it would be read as an id.
                  _child(
                    AppRoute.brandProducts,
                    AppRoute.brandProductNew,
                    (_, _) => CurrentBrandBuilder(
                      builder: (_, scope) =>
                          AdminProductFormScreen(scope: scope),
                    ),
                  ),
                  _child(
                    AppRoute.brandProducts,
                    AppRoute.brandProductEdit,
                    (_, state) => CurrentBrandBuilder(
                      key: ValueKey(state.pathParameters['id']),
                      builder: (_, scope) => AdminProductFormScreen(
                        scope: scope,
                        productId: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
              _child(
                AppRoute.brandHome,
                AppRoute.brandClaims,
                (_, _) => CurrentBrandBuilder(
                  builder: (_, scope) => AdminClaimsScreen(scope: scope),
                ),
                children: [
                  _child(
                    AppRoute.brandClaims,
                    AppRoute.brandClaim,
                    (_, state) => CurrentBrandBuilder(
                      key: ValueKey(state.pathParameters['id']),
                      builder: (_, scope) => AdminClaimScreen(
                        scope: scope,
                        claimId: state.pathParameters['id'] ?? '',
                      ),
                    ),
                    children: [
                      _child(
                        AppRoute.brandClaim,
                        AppRoute.brandClaimReceipt,
                        (_, state) => CurrentBrandBuilder(
                          builder: (_, scope) => ClaimReceiptScreen(
                            scope: scope,
                            claimId: state.pathParameters['id'] ?? '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _child(
                AppRoute.brandHome,
                AppRoute.brandImport,
                (_, _) => CurrentBrandBuilder(
                  builder: (_, scope) => AdminImportScreen(scope: scope),
                ),
              ),
              _child(
                AppRoute.brandHome,
                AppRoute.brandAnalytics,
                (_, _) => CurrentBrandBuilder(
                  builder: (_, scope) => AnalyticsScreen(scope: scope),
                ),
              ),
              _child(
                AppRoute.brandHome,
                AppRoute.brandTeam,
                (_, _) => CurrentBrandBuilder(
                  builder: (brand, _) => BrandTeamScreen(brand: brand),
                ),
              ),
              _child(
                AppRoute.brandHome,
                AppRoute.brandSettings,
                (_, _) => CurrentBrandBuilder(
                  builder: (brand, _) => BrandSettingsScreen(brand: brand),
                ),
              ),
            ],
          ),
        ],
      ),
      // Branch 5 (V2-6), after the others so their indexes stay.
      StatefulShellBranch(
        routes: [
          _route(
            AppRoute.rewards,
            (_, _) => const RewardsScreen(),
            children: [
              _child(
                AppRoute.rewards,
                AppRoute.rewardsHistory,
                (_, _) => const PointsHistoryScreen(),
              ),
              _child(
                AppRoute.rewards,
                AppRoute.rewardVouchers,
                (_, _) => const PointsHistoryScreen(showVouchers: true),
              ),
              _child(
                AppRoute.rewards,
                AppRoute.rewardDetail,
                (_, state) => RewardDetailScreen(
                  rewardId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
