import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_decision_controller.dart';
import 'package:staka/features/manage/claims/presentation/widgets/decided_claim_summary.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/features/manage/shared/widgets/reason_sheet.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// The Admin tab's claims are read-only (V2-12): brands check their own.
/// An admin can still overrule, approving or rejecting with a reason that
/// is recorded, when a brand got it wrong or can't check it.
class ClaimOverrulePanel extends ConsumerWidget {
  const new({required this.claim, super.key});

  final Claim claim;

  static const _scope = AdminScope();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = claimDecisionControllerProvider(_scope, claim.id);
    // Watched so the controller outlives the sheet that drives it.
    ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final brand = claim.product.brandName;

    Future<void> overrule(ClaimStatus decision) => showReasonSheet(
      context,
      title: decision == ClaimStatus.approved
          ? l10n.overruleApproveTitle
          : l10n.overruleRejectTitle,
      body: l10n.overruleBody(brand),
      fieldLabel: l10n.overruleReason,
      submitLabel: decision == ClaimStatus.approved
          ? l10n.approve
          : l10n.reject,
      submittingLabel: l10n.saving,
      request: provider,
      onSubmitted: (reason) => controller.overrule(decision, reason),
      onClosed: controller.reset,
      isDestructive: decision == ClaimStatus.rejected,
    );

    final offers = switch (claim.status) {
      ClaimStatus.pending => [ClaimStatus.approved, ClaimStatus.rejected],
      ClaimStatus.approved => [ClaimStatus.rejected],
      ClaimStatus.rejected => [ClaimStatus.approved],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        if (claim.status != ClaimStatus.pending)
          DecidedClaimSummary(claim: claim),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surfaceRaised,
            border: Border.all(color: context.colors.border),
            borderRadius: AppRadius.allMd,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg - AppSpacing.xxs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.overruleHeading(brand),
                    style: context.text.label,
                  ),
                ),
                Text(
                  claim.status == ClaimStatus.pending
                      ? l10n.overrulePendingHint(brand)
                      : l10n.overruleDecidedHint(brand),
                  style: context.text.bodyMedium.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                for (final decision in offers)
                  AppButton(
                    label: decision == ClaimStatus.approved
                        ? l10n.overruleApprove
                        : l10n.overruleReject,
                    icon: decision == ClaimStatus.approved
                        ? Icons.verified_outlined
                        : Icons.cancel_outlined,
                    variant: AppButtonVariant.secondary,
                    isExpanded: true,
                    onPressed: () => overrule(decision),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
