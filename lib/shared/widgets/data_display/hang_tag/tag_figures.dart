import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/shared/formatters/carbon_format.dart';
import 'package:staka/shared/widgets/layout/dashed_border.dart';

/// Footprint and recyclability, then who stands behind the figures. A
/// verified figure names its certifier; a brand-stated one says so plainly,
/// with a different icon (web DESIGN.md principle 3; never colour alone).
class TagFigures extends StatelessWidget {
  const new({required this.info, required this.isCompact, super.key});

  /// Null: the brand hasn't shared figures yet.
  final SustainabilityInfo? info;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rule = DashedDivider(color: context.colors.borderStrong);
    final info = this.info;
    if (info == null) {
      return Column(
        spacing: AppSpacing.sm,
        children: [
          rule,
          _Provenance(
            icon: Icons.info_outline_rounded,
            text: l10n.noFiguresYet,
          ),
        ],
      );
    }

    final carbon = carbonParts(info.carbonScoreGrams, l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: _Figure(
                label: l10n.tagFootprint,
                value: carbon.value,
                unit: carbon.unit,
                isCompact: isCompact,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 5,
              child: _Figure(
                label: l10n.tagRecyclable,
                value: '${info.recyclabilityPercent}',
                unit: '%',
                isCompact: isCompact,
              ),
            ),
          ],
        ),
        rule,
        if (info.isVerified)
          _Provenance(
            icon: Icons.verified_rounded,
            text: switch (info.certifierName) {
              final name? when name.trim().isNotEmpty => l10n.verifiedBy(name),
              _ => l10n.verifiedByThirdParty,
            },
            isVerified: true,
          )
        else
          _Provenance(
            icon: Icons.info_outline_rounded,
            text: l10n.statedByBrand,
          ),
      ],
    );
  }
}

/// "Footprint / 2.1 kg CO₂e": a big Manrope number with a small unit that
/// never wraps away from it (guide §6.2: Manrope for data numerals).
class _Figure extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.unit,
    required this.isCompact,
  });

  final String label;
  final String value;
  final String unit;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final muted = context.colors.inkMuted;
    final size = (isCompact ? text.headingSmall : text.headingMedium).fontSize;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.bodySmall.copyWith(color: muted)),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: text.numeric.copyWith(fontSize: size),
              ),
              TextSpan(
                text: ' $unit',
                style: text.bodySmall.copyWith(color: muted),
              ),
            ],
          ),
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}

class _Provenance extends StatelessWidget {
  const new({required this.icon, required this.text, this.isVerified = false});

  final IconData icon;
  final String text;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Icon(
          icon,
          size: AppSizes.iconInline - AppSpacing.xxs,
          color: isVerified ? colors.success : colors.inkMuted,
        ),
        Expanded(
          child: Text(
            text,
            style: context.text.bodyMedium.copyWith(
              color: isVerified ? colors.ink : colors.inkMuted,
            ),
          ),
        ),
      ],
    );
  }
}
