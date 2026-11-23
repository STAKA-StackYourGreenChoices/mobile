import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_colors.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';

/// One application: brand, status, what it means, the reason when STAKA
/// said no, and "Edit and resubmit" for a rejected one.
class BrandApplicationCard extends StatelessWidget {
  const new({
    required this.application,
    required this.onEditPressed,
    super.key,
  });

  final BrandApplication application;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final muted = context.text.bodyMedium.copyWith(color: colors.inkMuted);
    final BrandApplication(:name, :legalName, :status, :statusReason) =
        application;
    final hasReason =
        statusReason != null &&
        (status == BrandApplicationStatus.rejected ||
            status == BrandApplicationStatus.suspended);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        border: Border.all(color: colors.border),
        borderRadius: AppRadius.allMd,
      ),
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(name, style: context.text.headingSmall),
            ),
            if (legalName != name) Text(legalName, style: muted),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                BrandApplicationStatusChip(status: status),
                if (application.appliedAt case final appliedAt?)
                  Text(
                    l10n.brandAppliedOn(formatDate(appliedAt)),
                    style: context.text.bodySmall.copyWith(
                      color: colors.inkMuted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(switch (status) {
              BrandApplicationStatus.pending => l10n.brandStatusPendingBody,
              BrandApplicationStatus.approved => l10n.brandStatusApprovedBody(
                name,
              ),
              BrandApplicationStatus.rejected => l10n.brandStatusRejectedBody,
              BrandApplicationStatus.suspended => l10n.brandStatusSuspendedBody(
                name,
              ),
            }, style: context.text.bodyMedium),
            if (hasReason) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.brandStatusReason(statusReason),
                style: context.text.bodyMedium.copyWith(
                  color: colors.dangerText,
                ),
              ),
            ],
            if (status == BrandApplicationStatus.rejected) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.brandEditAndResubmit,
                icon: Icons.edit_outlined,
                variant: AppButtonVariant.secondary,
                isExpanded: true,
                onPressed: onEditPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Being checked / Approved / Not approved / Paused.
class BrandApplicationStatusChip extends StatelessWidget {
  const new({required this.status, super.key});

  final BrandApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (icon, label, color) = _style(status, l10n, colors);
    return StatusPill(icon: icon, label: label, color: color);
  }

  static (IconData, String, Color) _style(
    BrandApplicationStatus status,
    AppLocalizations l10n,
    AppColors colors,
  ) => switch (status) {
    BrandApplicationStatus.pending => (
      Icons.schedule_rounded,
      l10n.brandStatusPending,
      colors.brandPrimary,
    ),
    BrandApplicationStatus.approved => (
      Icons.verified_rounded,
      l10n.brandStatusApproved,
      colors.success,
    ),
    BrandApplicationStatus.rejected => (
      Icons.error_outline_rounded,
      l10n.brandStatusRejected,
      colors.dangerText,
    ),
    BrandApplicationStatus.suspended => (
      Icons.pause_circle_outline_rounded,
      l10n.brandStatusSuspended,
      colors.inkMuted,
    ),
  };
}
