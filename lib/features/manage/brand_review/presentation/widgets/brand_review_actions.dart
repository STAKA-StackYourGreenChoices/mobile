import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/manage/brand_review/domain/models/review_brand.dart';
import 'package:staka/features/manage/brand_review/presentation/state/brand_review_providers.dart';
import 'package:staka/features/manage/shared/widgets/reason_sheet.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';

/// "Your decision" for one brand, as its status allows: an application is
/// approved or turned down (with a reason), an active brand paused (with a
/// reason), a paused one made active again. A turned-down application
/// waits for the brand to send it again.
class BrandReviewActions extends ConsumerWidget {
  const new({required this.brand, super.key});

  final ReviewBrand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = brandDecisionControllerProvider(brand.id);
    final request = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final isSending = request is RequestSending;
    // Sheets show their own errors; this shows approve's and reinstate's.
    final error = switch (request) {
      RequestFailed(:final failure) => messageForFailure(failure, l10n),
      _ => null,
    };
    final name = brand.name;

    void done(String message) {
      if (context.mounted) AppSnackbar.show(context, message: message);
    }

    Future<void> withReason({
      required String title,
      required String body,
      required String submitLabel,
      required Future<void> Function(String reason) onSubmitted,
      required String doneMessage,
    }) async {
      controller.reset();
      final sent = await showReasonSheet(
        context,
        title: title,
        body: body,
        fieldLabel: l10n.reasonForBrand,
        submitLabel: submitLabel,
        submittingLabel: l10n.saving,
        request: provider,
        onSubmitted: onSubmitted,
        onClosed: controller.reset,
        isDestructive: true,
      );
      if (sent) done(doneMessage);
    }

    Future<void> direct(Future<void> Function() call, String message) async {
      await call();
      if (ref.read(provider) is RequestDone) {
        controller.reset();
        done(message);
      }
    }

    final children = switch (brand.status) {
      BrandApplicationStatus.pending => [
        AppButton(
          label: l10n.approveBrand,
          loadingLabel: l10n.approving,
          icon: Icons.verified_outlined,
          isLoading: isSending,
          isExpanded: true,
          onPressed: () => direct(controller.approve, l10n.brandApproved(name)),
        ),
        AppButton(
          label: l10n.rejectBrand,
          icon: Icons.cancel_outlined,
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          onPressed: isSending
              ? null
              : () => withReason(
                  title: l10n.rejectBrandTitle(name),
                  body: l10n.rejectBrandBody,
                  submitLabel: l10n.rejectBrand,
                  onSubmitted: controller.reject,
                  doneMessage: l10n.brandRejected(name),
                ),
        ),
      ],
      BrandApplicationStatus.approved => [
        AppButton(
          label: l10n.suspendBrand,
          icon: Icons.pause_circle_outline_rounded,
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          onPressed: isSending
              ? null
              : () => withReason(
                  title: l10n.suspendBrandTitle(name),
                  body: l10n.suspendBrandBody,
                  submitLabel: l10n.suspendBrand,
                  onSubmitted: controller.suspend,
                  doneMessage: l10n.brandSuspended(name),
                ),
        ),
      ],
      BrandApplicationStatus.suspended => [
        AppButton(
          label: l10n.reinstateBrand,
          loadingLabel: l10n.saving,
          icon: Icons.play_circle_outline_rounded,
          isLoading: isSending,
          isExpanded: true,
          onPressed: () =>
              direct(controller.reinstate, l10n.brandReinstated(name)),
        ),
      ],
      BrandApplicationStatus.rejected => [
        Text(
          l10n.rejectedBrandWaits,
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
      ],
    };

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
            if (error != null)
              AppFormAlert(message: error, tone: AlertTone.error),
            ...children,
          ],
        ),
      ),
    );
  }
}
