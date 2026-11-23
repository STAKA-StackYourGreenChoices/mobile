import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/state/claim_decision_controller.dart';
import 'package:staka/features/manage/claims/presentation/widgets/decided_claim_summary.dart';
import 'package:staka/features/manage/claims/presentation/widgets/reject_reason_form.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// "Your decision": Approve, or Reject with a reason the shopper will read
/// (the website's `ClaimDecision`). A decided claim shows the outcome.
class ClaimDecisionPanel extends ConsumerStatefulWidget {
  const new({required this.scope, required this.claim, super.key});

  final ManageScope scope;
  final Claim claim;

  @override
  ConsumerState<ClaimDecisionPanel> createState() => _ClaimDecisionPanelState();
}

class _ClaimDecisionPanelState extends ConsumerState<ClaimDecisionPanel> {
  bool _isRejecting = false;

  @override
  Widget build(BuildContext context) {
    final claim = widget.claim;
    if (claim.status != ClaimStatus.pending) {
      return DecidedClaimSummary(claim: claim);
    }
    final l10n = context.l10n;
    final provider = claimDecisionControllerProvider(widget.scope, claim.id);
    final request = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final error = switch (request) {
      RequestFailed(:final failure) => messageForFailure(failure, l10n),
      _ => null,
    };
    final isSending = request is RequestSending;

    return DecoratedBox(
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
              child: Text(l10n.yourDecision, style: context.text.label),
            ),
            if (_isRejecting)
              RejectReasonForm(
                receiptAttempt: claim.receiptAttempt,
                alertMessage: error,
                isSubmitting: isSending,
                onSubmitted: controller.reject,
                onBackPressed: () => setState(() => _isRejecting = false),
              )
            else ...[
              if (error != null)
                AppFormAlert(message: error, tone: AlertTone.error),
              AppButton(
                label: l10n.approve,
                loadingLabel: l10n.approving,
                icon: Icons.verified_outlined,
                isLoading: isSending,
                isExpanded: true,
                onPressed: controller.approve,
              ),
              AppButton(
                label: l10n.reject,
                icon: Icons.cancel_outlined,
                variant: AppButtonVariant.secondary,
                isExpanded: true,
                onPressed: isSending
                    ? null
                    : () => setState(() => _isRejecting = true),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
