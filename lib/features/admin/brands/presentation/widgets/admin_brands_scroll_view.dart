import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/brands/presentation/state/admin_brands_state.dart';
import 'package:staka/features/admin/brands/presentation/widgets/brand_tile.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// The brands page as one scroll: heading with Add brand, then the brands
/// in one card, or the empty invitation. Pull down to refresh.
class AdminBrandsScrollView extends StatelessWidget {
  const new({
    required this.state,
    required this.onRefresh,
    required this.onRetry,
    required this.onAddPressed,
    required this.onProductsPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final AdminBrandsState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onAddPressed;
  final ValueChanged<BrandSummary> onProductsPressed;
  final ValueChanged<BrandSummary> onEditPressed;
  final ValueChanged<BrandSummary> onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.adminBrands,
                    style: context.text.headingLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.adminBrandsDescription,
                  style: context.text.bodyLarge.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: l10n.addBrand,
                  icon: Icons.add_rounded,
                  onPressed: onAddPressed,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          ...switch (state) {
            BrandsLoading() => const [
              SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
            ],
            BrandsFailed(:final failure) => [
              SliverToBoxAdapter(
                child: AppErrorState(failure: failure, onRetryPressed: onRetry),
              ),
            ],
            BrandsEmpty() => [
              SliverToBoxAdapter(
                child: FeedbackMessage(
                  icon: Icons.storefront_outlined,
                  iconColor: context.colors.brandPrimary,
                  title: Text(
                    l10n.noBrandsTitle,
                    style: context.text.headingMedium,
                  ),
                  message: l10n.noBrandsBody,
                  action: AppButton(
                    label: l10n.addBrand,
                    icon: Icons.add_rounded,
                    onPressed: onAddPressed,
                  ),
                ),
              ),
            ],
            BrandsLoaded(:final brands) => [_rows(context, brands)],
          },
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        ],
      ),
    );
  }

  Widget _rows(BuildContext context, List<BrandSummary> brands) =>
      DecoratedSliver(
        decoration: BoxDecoration(
          color: context.colors.surfaceRaised,
          border: Border.all(color: context.colors.border),
          borderRadius: AppRadius.allMd,
        ),
        sliver: SliverList.separated(
          itemCount: brands.length,
          itemBuilder: (_, index) {
            final brand = brands[index];
            return BrandTile(
              key: ValueKey(brand.id),
              brand: brand,
              onProductsPressed: () => onProductsPressed(brand),
              onEditPressed: () => onEditPressed(brand),
              onDeletePressed: () => onDeletePressed(brand),
            );
          },
          separatorBuilder: (_, _) =>
              Divider(height: 1, color: context.colors.border),
        ),
      );
}
