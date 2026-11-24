import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/presentation/state/brand_review_providers.dart';
import 'package:staka/features/manage/brand_review/presentation/widgets/brand_review_labels.dart';
import 'package:staka/features/manage/brand_review/presentation/widgets/review_brand_row.dart';
import 'package:staka/features/manage/shared/widgets/status_tabs.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The Admin tab's Brands (V2-12): applications waiting for a decision,
/// then active, paused and turned-down brands. Each opens to decide.
class AdminBrandsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AdminBrandsScreen> createState() => _AdminBrandsScreenState();
}

class _AdminBrandsScreenState extends ConsumerState<AdminBrandsScreen> {
  /// Kept while a brand is open above this page.
  BrandApplicationStatus _status = BrandApplicationStatus.pending;

  static const List<BrandApplicationStatus> _tabs = [
    BrandApplicationStatus.pending,
    BrandApplicationStatus.approved,
    BrandApplicationStatus.suspended,
    BrandApplicationStatus.rejected,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = reviewBrandsProvider(_status);
    final brands = ref.watch(provider);
    return AppScaffold(
      showAppBar: true,
      isScrollable: false,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(provider.future),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.adminBrands,
                      style: context.text.headingLarge,
                    ),
                  ),
                  Text(
                    l10n.adminBrandsReviewDescription,
                    style: context.text.bodyLarge.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: StatusTabs<BrandApplicationStatus>(
                  values: _tabs,
                  labelOf: l10n.brandReviewTabLabel,
                  selected: _status,
                  onSelected: (status) => setState(() => _status = status),
                  semanticsLabel: l10n.brandStatusLabel,
                  count: switch (brands) {
                    AsyncData(value: Ok(:final value)) => value.length,
                    _ => null,
                  },
                ),
              ),
            ),
            ...switch (brands) {
              AsyncData(value: Ok(:final value)) when value.isEmpty => [
                SliverToBoxAdapter(
                  child: FeedbackMessage(
                    icon: Icons.storefront_outlined,
                    iconColor: context.colors.brandPrimary,
                    message: l10n.noBrandsInStatus(_status.name),
                  ),
                ),
              ],
              AsyncData(value: Ok(:final value)) => [
                DecoratedSliver(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceRaised,
                    border: Border.all(color: context.colors.border),
                    borderRadius: AppRadius.allMd,
                  ),
                  sliver: SliverList.separated(
                    itemCount: value.length,
                    itemBuilder: (_, index) => ReviewBrandRow(
                      key: ValueKey(value[index].id),
                      brand: value[index],
                      onPressed: () => context.goNamed(
                        AppRoute.adminBrand.name,
                        pathParameters: {'id': value[index].id},
                      ),
                    ),
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: context.colors.border),
                  ),
                ),
              ],
              AsyncData(value: Err(:final failure)) => [
                SliverToBoxAdapter(
                  child: AppErrorState(
                    failure: failure,
                    onRetryPressed: () => ref.invalidate(provider),
                  ),
                ),
              ],
              _ => const [
                SliverFillRemaining(hasScrollBody: false, child: AppLoader()),
              ],
            },
          ],
        ),
      ),
    );
  }
}
