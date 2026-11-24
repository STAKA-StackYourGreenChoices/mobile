import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/tags/presentation/widgets/status_panel.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// After a brand turned the receipt down: "Ask STAKA to look again", or
/// where that request stands. Nothing when neither applies.
class LookAgainSection extends StatelessWidget {
  const new({required this.ownership, required this.onAskPressed, super.key});

  final Ownership ownership;
  final VoidCallback? onAskPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brand = ownership.brandName ?? l10n.theBrand;
    return switch (ownership.dispute) {
      OwnershipDispute(status: DisputeStatus.open) => StatusPanel(
        tone: PanelTone.info,
        icon: Icons.manage_search_rounded,
        title: l10n.lookAgainOpenTitle,
        body: l10n.lookAgainOpenBody(brand),
      ),
      OwnershipDispute(status: DisputeStatus.upheld, :final resolution) =>
        StatusPanel(
          tone: PanelTone.muted,
          icon: Icons.gavel_rounded,
          title: l10n.lookAgainUpheldTitle,
          body: switch (resolution?.trim()) {
            final note? when note.isNotEmpty => l10n.lookAgainUpheld(
              brand,
              note,
            ),
            _ => l10n.lookAgainUpheldNoNote(brand),
          },
        ),
      // Overturned means verified; the verified panel says so.
      OwnershipDispute(status: DisputeStatus.overturned) =>
        const SizedBox.shrink(),
      null when ownership.canAskToLookAgain && onAskPressed != null => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Text(
            l10n.lookAgainLede(brand),
            style: context.text.bodySmall.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          AppButton(
            label: l10n.askStakaToLookAgain,
            icon: Icons.support_agent_rounded,
            variant: AppButtonVariant.secondary,
            onPressed: onAskPressed,
          ),
        ],
      ),
      null => const SizedBox.shrink(),
    };
  }

  /// Whether [build] shows anything, so callers don't leave a gap.
  static bool showsFor(Ownership ownership, {required bool canAsk}) =>
      switch (ownership.dispute) {
        OwnershipDispute(status: DisputeStatus.overturned) => false,
        _? => true,
        null => ownership.canAskToLookAgain && canAsk,
      };
}
