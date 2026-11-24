import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';
import 'package:staka/shared/formatters/carbon_format.dart';

/// "Your impact" at the top of the wardrobe (V2-5): six figures, and the
/// way to the activity timeline.
class WardrobeImpactCard extends StatelessWidget {
  const new({required this.impact, required this.onActivityPressed, super.key});

  final Impact impact;
  final VoidCallback onActivityPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final number = NumberFormat.decimalPattern();
    final carbon = carbonParts(impact.carbonGramsOwned, l10n);
    final figures = [
      (number.format(impact.pieces), null, l10n.impactPieces),
      (number.format(impact.verifiedPieces), null, l10n.impactVerified),
      (number.format(impact.sharedPieces), null, l10n.impactShared),
      (number.format(impact.totalViews), null, l10n.impactViews),
      (carbon.value, carbon.unit, l10n.impactFootprint),
      (number.format(impact.points), null, l10n.impactPoints),
    ];
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.impactTitle,
                    style: context.text.headingSmall,
                  ),
                ),
                for (var row = 0; row < figures.length; row += 3)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (value, unit, label) in figures.sublist(
                        row,
                        row + 3,
                      ))
                        Expanded(
                          child: _Figure(
                            value: value,
                            unit: unit,
                            label: label,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          MergeSemantics(
            child: InkWell(
              onTap: onActivityPressed,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTapTarget,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.seeYourActivity,
                          style: context.text.label.copyWith(
                            color: context.colors.brandPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.colors.brandPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A large number with its unit, and what it counts underneath.
class _Figure extends StatelessWidget {
  const new({required this.value, required this.unit, required this.label});

  final String value;
  final String? unit;
  final String label;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: value, style: context.text.headingMedium),
              if (unit case final unit?)
                TextSpan(text: ' $unit', style: context.text.bodySmall),
            ],
          ),
        ),
        Text(
          label,
          style: context.text.bodySmall.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
      ],
    ),
  );
}
