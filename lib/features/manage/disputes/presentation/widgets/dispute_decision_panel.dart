import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/manage/disputes/domain/admin_dispute.dart';
import 'package:staka/features/manage/disputes/presentation/state/dispute_providers.dart';
import 'package:staka/features/manage/shared/widgets/reason_sheet.dart';
import 'package:staka/shared/formatters/date_format.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';

/// "Your decision" on a dispute: approve the receipt (overturn) or keep
/// the brand's decision (uphold), each with a note the shopper reads. A
/// settled dispute shows how and when, with the note.
class DisputeDecisionPanel extends ConsumerWidget {
  const new({required this.dispute, required this.brandName, super.key});

  final AdminDispute dispute;
  final String brandName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = disputeResolveControllerProvider(dispute.id);
    // Watched so the controller outlives the sheet that drives it.
    ref.watch(provider);
    final controller = ref.read(provider.notifier);

    Future<void> decide(DisputeOutcome outcome) async {
      final overturn = outcome == DisputeOutcome.overturn;
      final done = await showReasonSheet(
        context,
        title: overturn ? l10n.overturnTitle : l10n.upholdTitle(brandName),
        body: overturn ? l10n.overturnBody(brandName) : l10n.upholdBody,
        fieldLabel: l10n.noteForShopper,
        submitLabel: overturn ? l10n.overturn : l10n.uphold,
        submittingLabel: l10n.saving,
        request: provider,
        onSubmitted: (note) => controller.resolve(outcome, note),
        onClosed: controller.reset,
      );
      if (done && context.mounted) {
        AppSnackbar.show(
          context,
          message: overturn
              ? l10n.disputeOverturnedDone
              : l10n.disputeUpheldDone,
        );
      }
    }

    final muted = context.text.bodyMedium.copyWith(
      color: context.colors.inkMuted,
    );
    final children = switch (dispute.status) {
      DisputeStatus.open => [
        AppButton(
          label: l10n.overturn,
          icon: Icons.verified_outlined,
          isExpanded: true,
          onPressed: () => decide(DisputeOutcome.overturn),
        ),
        AppButton(
          label: l10n.uphold,
          icon: Icons.gavel_rounded,
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          onPressed: () => decide(DisputeOutcome.uphold),
        ),
      ],
      final status => [
        Text(switch ((status, dispute.resolvedAt)) {
          (DisputeStatus.overturned, final at?) => l10n.overturnedOn(
            formatDate(at),
          ),
          (DisputeStatus.overturned, null) => l10n.overturnedUndated,
          (_, final at?) => l10n.upheldOn(formatDate(at)),
          (_, null) => l10n.upheldUndated,
        }, style: context.text.bodyLarge),
        if (dispute.resolution case final note?)
          Text(l10n.noteSaid(note), style: muted),
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
            ...children,
          ],
        ),
      ),
    );
  }
}
