import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_decision_controller.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_review_controller.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_review_state.dart';
import 'package:staka/features/manage/claims/presentation/widgets/automatic_check_card.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_decision_panel.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_facts.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_history.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_overrule_panel.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_receipt_preview.dart';
import 'package:staka/features/manage/claims/presentation/widgets/disputed_pill.dart';
import 'package:staka/features/manage/shared/manage_routes.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/features/manage/shared/widgets/admin_not_found.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/tag_image.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/claims/[id]`: the receipt, the decision, what to
/// check, the shopper, every claim for the piece, and its tag.
class AdminClaimScreen extends ConsumerWidget {
  const new({required this.scope, required this.claimId, super.key});

  /// Admin (every brand) or one brand's team.
  final ManageScope scope;
  final String claimId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final review = ref.watch(claimReviewControllerProvider(scope, claimId));

    ref.listen(claimDecisionControllerProvider(scope, claimId), (_, next) {
      if (next is! RequestDone<ClaimStatus>) return;
      AppSnackbar.show(
        context,
        message: next.value == ClaimStatus.approved
            ? l10n.claimApproved
            : l10n.claimRejected,
      );
      context.goNamed(scope.claimsRoute.name);
    });

    return AppScaffold(
      showAppBar: true,
      isScrollable: review is ClaimReviewReady,
      body: switch (review) {
        ClaimReviewLoading() => const AppLoader(),
        ClaimReviewNotFound() => AdminNotFound(
          backLabel: l10n.adminClaims,
          onBackPressed: () => context.goNamed(scope.claimsRoute.name),
        ),
        ClaimReviewFailed(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: ref
              .read(claimReviewControllerProvider(scope, claimId).notifier)
              .retry,
        ),
        ClaimReviewReady(:final detail, :final product) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.xl,
          children: [
            _Heading(claim: detail.claim),
            ClaimReceiptPreview(
              scope: scope,
              claim: detail.claim,
              onOpenPressed: () => context.goNamed(
                scope.claimReceiptRoute.name,
                pathParameters: {'id': claimId},
              ),
            ),
            if (detail.analysis case final analysis?)
              AutomaticCheckCard(
                analysis: analysis,
                onEarlierClaimPressed: switch (scope) {
                  AdminScope() => (id) => context.goNamed(
                    scope.claimRoute.name,
                    pathParameters: {'id': id},
                  ),
                  BrandScope() => null,
                },
              ),
            switch (scope) {
              BrandScope() => ClaimDecisionPanel(
                scope: scope,
                claim: detail.claim,
              ),
              AdminScope() => ClaimOverrulePanel(claim: detail.claim),
            },
            ClaimFacts(claim: detail.claim),
            if (detail.history.length > 1)
              ClaimHistory(history: detail.history, currentId: claimId),
            if (product != null)
              Center(
                child: HangTag(
                  productName: product.name,
                  brandName: product.brand.name,
                  sustainability: product.sustainabilityInfo,
                  image: switch (product.imageUrl) {
                    final url? => TagImage(url),
                    null => null,
                  },
                  gtin: product.gtin,
                  size: HangTagSize.sm,
                ),
              ),
          ],
        ),
      },
    );
  }
}

class _Heading extends StatelessWidget {
  const new({required this.claim});

  final Claim claim;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sent = formatDate(claim.createdAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xxs,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.claimTitle(claim.user.name, claim.product.name),
            style: context.text.headingLarge,
          ),
        ),
        Text(
          claim.method == ClaimMethod.orderMatch
              ? l10n.claimOrderMatched(sent)
              : l10n.claimReceiptSent(
                  claim.receiptAttempt?.toString() ?? '?',
                  sent,
                ),
          style: context.text.bodyLarge.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        if (claim.isDisputed) const DisputedPill(),
      ],
    );
  }
}
