import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_labels.dart';

/// To review · Approved · Rejected, the selected one with its count (the
/// website's claim status tabs).
class ClaimStatusTabs extends StatelessWidget {
  const new({
    required this.selected,
    required this.onSelected,
    this.count,
    super.key,
  });

  final ClaimStatus selected;
  final ValueChanged<ClaimStatus> onSelected;

  /// How many claims the selected tab holds, once known.
  final int? count;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Semantics(
      label: l10n.claimStatusLabel,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final status in ClaimStatus.values)
                _Tab(
                  label: l10n.claimTabLabel(status),
                  count: status == selected ? count : null,
                  isSelected: status == selected,
                  onPressed: () => onSelected(status),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const new({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.count,
  });

  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isSelected ? colors.brandPrimary : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            spacing: AppSpacing.xs,
            children: [
              Text(
                label,
                style: context.text.label.copyWith(
                  color: isSelected ? colors.ink : colors.inkMuted,
                ),
              ),
              if (count case final value?)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: AppRadius.allFull,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    child: Text('$value', style: context.text.bodySmall),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
