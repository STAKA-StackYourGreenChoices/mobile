import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/brand_review/presentation/state/brand_review_providers.dart';
import 'package:staka/features/manage/disputes/presentation/state/dispute_providers.dart';
import 'package:staka/features/manage/hub/presentation/widgets/admin_section_tile.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Admin tab (V2-12): brands run their own catalogs and claims, so
/// STAKA admins approve and pause brands, settle disputes, and keep an eye
/// on every brand's claims and products (overrule, hide). The first two
/// say how many wait.
class AdminHomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final brands = ref.watch(pendingBrandCountProvider);
    final disputes = ref.watch(openDisputeCountProvider);
    // Admins who also run a brand have no Brand tab (five tabs at most).
    final hasBrand = ref.watch(
      sessionControllerProvider.select(
        (session) => session is SignedIn && session.user.hasBrandPortal,
      ),
    );
    final sections = [
      (
        AppRoute.adminBrands,
        Icons.storefront_outlined,
        l10n.adminBrands,
        switch (brands) {
          AsyncData(value: final count?) => l10n.adminBrandsWaiting(count),
          _ => l10n.adminBrandsReviewDescription,
        },
      ),
      (
        AppRoute.adminDisputes,
        Icons.balance_outlined,
        l10n.adminDisputes,
        switch (disputes) {
          AsyncData(value: final count?) => l10n.adminDisputesWaiting(count),
          _ => l10n.adminDisputesDescription,
        },
      ),
      (
        AppRoute.adminClaims,
        Icons.receipt_long_outlined,
        l10n.adminClaims,
        l10n.adminClaimsReadOnlyDescription,
      ),
      (
        AppRoute.adminProducts,
        Icons.inventory_2_outlined,
        l10n.adminProducts,
        l10n.adminProductsReadOnlyDescription,
      ),
      (
        AppRoute.adminRewards,
        Icons.redeem_outlined,
        l10n.brandRewardsTitle,
        l10n.adminRewardsHubDescription,
      ),
      (
        AppRoute.adminRewardRules,
        Icons.stars_outlined,
        l10n.rewardRulesTitle,
        l10n.rewardRulesHubDescription,
      ),
      (
        AppRoute.adminUsers,
        Icons.people_outline_rounded,
        l10n.adminUsersTitle,
        l10n.adminUsersHubDescription,
      ),
      (
        AppRoute.adminAnalytics,
        Icons.insights_outlined,
        l10n.analyticsTitle,
        l10n.adminAnalyticsDescription,
      ),
      if (hasBrand)
        (
          AppRoute.brandHome,
          Icons.storefront_outlined,
          l10n.adminBrandPortal,
          l10n.adminBrandPortalDescription,
        ),
    ];
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Semantics(
              header: true,
              child: Text(l10n.navAdmin, style: context.text.headingLarge),
            ),
          ),
          for (final (route, icon, title, description) in sections)
            AdminSectionTile(
              icon: icon,
              title: title,
              description: description,
              onPressed: () => context.goNamed(route.name),
            ),
        ],
      ),
    );
  }
}
