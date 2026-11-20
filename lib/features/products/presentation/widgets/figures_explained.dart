import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/shared/formatters/carbon_format.dart';

/// "What the figures mean": each number with its unit and a plain-language
/// explanation, then who stands behind them — the website's section.
class FiguresExplained extends StatelessWidget {
  const new({required this.brandName, this.info, super.key});

  final String brandName;
  final SustainabilityInfo? info;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final info = this.info;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.figuresTitle, style: context.text.headingMedium),
        ),
        if (info == null)
          _Muted(l10n.brandNoFigures(brandName))
        else ...[
          _Figure(
            title: l10n.figureCarbon(formatCarbon(info.carbonScoreGrams, l10n)),
            body: l10n.figureCarbonBody,
          ),
          _Figure(
            title: l10n.figureRecyclable(info.recyclabilityPercent),
            body: l10n.figureRecyclableBody,
          ),
          _Figure(
            icon: info.isVerified
                ? Icons.verified_rounded
                : Icons.info_outline_rounded,
            isVerified: info.isVerified,
            title: info.isVerified
                ? l10n.independentlyVerified
                : l10n.statedByBrandTitle,
            body: switch ((info.isVerified, info.certifierName)) {
              (true, final name?) when name.trim().isNotEmpty =>
                l10n.certifierChecked(name),
              (true, _) => l10n.thirdPartyChecked,
              (false, _) => l10n.noOneChecked,
            },
          ),
        ],
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const new({
    required this.title,
    required this.body,
    this.icon,
    this.isVerified = false,
  });

  final String title;
  final String body;
  final IconData? icon;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppSpacing.xs,
          children: [
            if (icon case final icon?)
              Icon(
                icon,
                size: AppSizes.iconInline,
                color: isVerified ? colors.success : colors.inkMuted,
              ),
            Expanded(child: Text(title, style: context.text.headingSmall)),
          ],
        ),
        _Muted(body),
      ],
    );
  }
}

class _Muted extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.text.bodyMedium.copyWith(color: context.colors.inkMuted),
  );
}
