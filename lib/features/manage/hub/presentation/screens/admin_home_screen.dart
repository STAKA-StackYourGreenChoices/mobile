import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/hub/presentation/widgets/admin_section_tile.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Admin tab: the website's admin nav (Products · Brands · Import ·
/// Claims) as a list, each with its page's description.
class AdminHomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sections = [
      (
        AppRoute.adminProducts,
        Icons.inventory_2_outlined,
        l10n.adminProducts,
        l10n.adminProductsDescription,
      ),
      (
        AppRoute.adminBrands,
        Icons.sell_outlined,
        l10n.adminBrands,
        l10n.adminBrandsDescription,
      ),
      (
        AppRoute.adminImport,
        Icons.upload_file_outlined,
        l10n.adminImport,
        l10n.adminImportDescription,
      ),
      (
        AppRoute.adminClaims,
        Icons.receipt_long_outlined,
        l10n.adminClaims,
        l10n.adminClaimsDescription,
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
