import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_colors.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership_status.dart';

/// Ownership status as a pill: icon + label + colour, never colour alone
/// (guide §6.1 law 3). The website's `OwnershipChip`, same labels.
class OwnershipChip extends StatelessWidget {
  const new({required this.status, super.key});

  final OwnershipStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (icon, label, color) = _style(status, l10n, context.colors);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: AppRadius.allFull,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm - AppSpacing.xxs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xxs,
          children: [
            Icon(icon, size: AppSpacing.md, color: color),
            Flexible(
              child: Text(
                label,
                style: context.text.bodySmall.copyWith(
                  color: color,
                  fontWeight: context.text.label.fontWeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static (IconData, String, Color) _style(
    OwnershipStatus status,
    AppLocalizations l10n,
    AppColors colors,
  ) => switch (status) {
    OwnershipStatus.verified => (
      Icons.verified_rounded,
      l10n.ownershipVerified,
      colors.success,
    ),
    OwnershipStatus.pending => (
      Icons.schedule_rounded,
      l10n.ownershipPending,
      colors.brandPrimary,
    ),
    OwnershipStatus.rejected => (
      Icons.error_outline_rounded,
      l10n.ownershipRejected,
      colors.dangerText,
    ),
    OwnershipStatus.blocked => (
      Icons.block_rounded,
      l10n.ownershipBlocked,
      // inkSubtle is large-text only (3.72:1); chip text needs inkMuted.
      colors.inkMuted,
    ),
    OwnershipStatus.unverified => (
      Icons.help_outline_rounded,
      l10n.ownershipUnverified,
      colors.inkMuted,
    ),
  };
}
