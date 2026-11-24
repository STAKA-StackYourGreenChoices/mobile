import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_review_controller.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_review_state.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_facts.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_receipt_preview.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';
import 'package:staka/features/manage/disputes/presentation/state/dispute_providers.dart';
import 'package:staka/features/manage/disputes/presentation/widgets/dispute_decision_panel.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/features/manage/shared/widgets/admin_not_found.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// One dispute: what the shopper wrote, why the brand turned the receipt
/// down, the receipt itself, then Keep the decision or Approve the
/// receipt, each with a note the shopper reads.
class AdminDisputeScreen extends ConsumerWidget {
  const new({required this.disputeId, super.key});

  final String disputeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dispute = ref.watch(adminDisputeProvider(disputeId));
    return AppScaffold(
      showAppBar: true,
      isScrollable: dispute is AsyncData,
      body: switch (dispute) {
        AsyncData(value: Ok(:final value)) => _Dispute(dispute: value),
        AsyncData(value: Err(failure: NotFoundFailure())) => AdminNotFound(
          backLabel: l10n.adminDisputes,
          onBackPressed: () => context.goNamed(AppRoute.adminDisputes.name),
        ),
        AsyncData(value: Err(:final failure)) => AppErrorState(
          failure: failure,
          onRetryPressed: () => ref.invalidate(disputesProvider),
        ),
        _ => const AppLoader(),
      },
    );
  }
}

class _Dispute extends ConsumerWidget {
  const new({required this.dispute});

  final AdminDispute dispute;

  static const _scope = AdminScope();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final review = ref.watch(
      claimReviewControllerProvider(_scope, dispute.claimId),
    );
    final claim = switch (review) {
      ClaimReviewReady(:final detail) => detail.claim,
      _ => dispute.claim,
    };
    final muted = context.text.bodyLarge.copyWith(
      color: context.colors.inkMuted,
    );
    final brand = claim?.product.brandName ?? l10n.theBrand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xl,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            Semantics(
              header: true,
              child: Text(
                claim?.product.name ?? l10n.adminDisputes,
                style: context.text.headingLarge,
              ),
            ),
            Text(
              l10n.disputeAsked(
                claim?.user.name ?? l10n.aShopper,
                formatDate(dispute.createdAt),
              ),
              style: muted,
            ),
          ],
        ),
        _Section(
          title: l10n.shopperWrote,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceRaised,
              border: Border(
                left: BorderSide(color: context.colors.brandPrimary, width: 3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SelectableText(
                dispute.message,
                style: context.text.bodyLarge,
              ),
            ),
          ),
        ),
        _Section(
          title: l10n.brandReasonHeading(brand),
          child: Text(
            claim?.rejectionReason ?? l10n.noReasonGiven,
            style: muted,
          ),
        ),
        switch (review) {
          ClaimReviewReady(:final detail) => _Receipt(
            dispute: dispute,
            claim: detail.claim,
          ),
          ClaimReviewFailed(:final failure) => AppErrorState(
            failure: failure,
            onRetryPressed: ref
                .read(
                  claimReviewControllerProvider(
                    _scope,
                    dispute.claimId,
                  ).notifier,
                )
                .retry,
          ),
          ClaimReviewNotFound() => Text(l10n.receiptUnavailable, style: muted),
          ClaimReviewLoading() => const AppLoader(),
        },
        if (claim != null) ClaimFacts(claim: claim),
        DisputeDecisionPanel(dispute: dispute, brandName: brand),
      ],
    );
  }
}

class _Receipt extends StatelessWidget {
  const new({required this.dispute, required this.claim});

  final AdminDispute dispute;
  final Claim claim;

  @override
  Widget build(BuildContext context) => ClaimReceiptPreview(
    scope: const AdminScope(),
    claim: claim,
    onOpenPressed: () => context.goNamed(
      AppRoute.adminDisputeReceipt.name,
      pathParameters: {'id': dispute.id, 'claimId': claim.id},
    ),
  );
}

class _Section extends StatelessWidget {
  const new({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.xs,
    children: [
      Semantics(header: true, child: Text(title, style: context.text.label)),
      child,
    ],
  );
}
