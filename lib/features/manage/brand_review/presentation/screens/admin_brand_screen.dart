import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/features/manage/brand_review/presentation/state/brand_review_providers.dart';
import 'package:staka/features/manage/brand_review/presentation/widgets/brand_review_actions.dart';
import 'package:staka/features/manage/brand_review/presentation/widgets/brand_review_facts.dart';
import 'package:staka/features/manage/brand_review/presentation/widgets/review_brand_status_pill.dart';
import 'package:staka/features/manage/shared/widgets/admin_not_found.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// One brand for a STAKA admin: what it sent, its business document, and
/// the decision its status allows (approve or reject an application,
/// suspend an active brand, reinstate a paused one).
class AdminBrandScreen extends ConsumerWidget {
  const new({required this.brandId, super.key});

  final String brandId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final brand = ref.watch(reviewBrandProvider(brandId));
    void back() => context.goNamed(AppRoute.adminBrands.name);
    return AppScaffold(
      showAppBar: true,
      isScrollable: brand is AsyncData,
      body: switch (brand) {
        AsyncData(value: Ok(:final value)) => _BrandReview(brand: value),
        AsyncData(value: Err(failure: NotFoundFailure())) => AdminNotFound(
          backLabel: l10n.adminBrands,
          onBackPressed: back,
        ),
        AsyncData(value: Err(:final failure)) => AppErrorState(
          failure: failure,
          onRetryPressed: () => ref.invalidate(reviewBrandProvider(brandId)),
        ),
        _ => const AppLoader(),
      },
    );
  }
}

class _BrandReview extends StatelessWidget {
  const new({required this.brand});

  final ReviewBrand brand;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reason = brand.application.statusReason;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xl,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xs,
          children: [
            Semantics(
              header: true,
              child: Text(brand.name, style: context.text.headingLarge),
            ),
            ReviewBrandStatusPill(status: brand.status),
            if (reason != null && reason.trim().isNotEmpty)
              Text(
                l10n.brandStatusReason(reason),
                style: context.text.bodyMedium.copyWith(
                  color: context.colors.inkMuted,
                ),
              ),
          ],
        ),
        BrandReviewFacts(brand: brand),
        if (brand.hasDocument)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton(
              label: l10n.viewBusinessDocument,
              icon: Icons.description_outlined,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.goNamed(
                AppRoute.adminBrandDocument.name,
                pathParameters: {'id': brand.id},
              ),
            ),
          )
        else
          Text(
            l10n.noBusinessDocument,
            style: context.text.bodyMedium.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
        BrandReviewActions(brand: brand),
      ],
    );
  }
}
