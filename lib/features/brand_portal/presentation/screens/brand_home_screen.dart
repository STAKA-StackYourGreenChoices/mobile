import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/presentation/state/current_brand.dart';
import 'package:staka/features/brand_portal/presentation/widgets/brand_header.dart';
import 'package:staka/features/brand_portal/presentation/widgets/brand_suspended_banner.dart';
import 'package:staka/features/brand_portal/presentation/widgets/brand_switcher_sheet.dart';
import 'package:staka/features/manage/hub/presentation/widgets/admin_section_tile.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Brand tab (V2-12): the current brand, a switcher when the person
/// belongs to several, and what its team can do there. Team and Settings
/// are owners-only changes; a paused brand shows why and nothing else.
class BrandHomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final brand = ref.watch(currentBrandProvider);
    // The router keeps people without a brand out; this covers the frame
    // in which it is leaving.
    if (brand == null) return const SizedBox.shrink();
    final brands = ref.watch(portalBrandsProvider);

    Future<void> switchBrand() async {
      final picked = await showBrandSwitcherSheet(
        context,
        brands: brands,
        selectedId: brand.id,
      );
      if (picked == null) return;
      ref.read(selectedBrandIdProvider.notifier).select(picked.id);
    }

    final sections = [
      (
        AppRoute.brandProducts,
        Icons.inventory_2_outlined,
        l10n.adminProducts,
        l10n.brandProductsDescription,
      ),
      (
        AppRoute.brandImport,
        Icons.upload_file_outlined,
        l10n.adminImport,
        l10n.brandImportDescription,
      ),
      (
        AppRoute.brandTeam,
        Icons.group_outlined,
        l10n.brandTeam,
        l10n.brandTeamDescription(brand.name),
      ),
      if (brand.isOwner)
        (
          AppRoute.brandSettings,
          Icons.tune_rounded,
          l10n.brandSettings,
          l10n.brandSettingsDescription,
        ),
    ];

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          BrandHeader(
            brand: brand,
            onSwitchPressed: brands.length > 1 ? switchBrand : null,
          ),
          const SizedBox(height: AppSpacing.xs),
          if (brand.status == BrandStatus.suspended)
            BrandSuspendedBanner(
              brandName: brand.name,
              onSeeWhyPressed: () =>
                  context.goNamed(AppRoute.brandApplications.name),
            )
          else
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
