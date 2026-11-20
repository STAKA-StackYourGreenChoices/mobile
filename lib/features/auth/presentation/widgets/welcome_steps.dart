import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The website's "How it works": three numbered steps. Numbering is used
/// because the content really is a sequence (web DESIGN.md).
class WelcomeSteps extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      (l10n.stepScanTitle, l10n.stepScanBody),
      (l10n.stepFootprintTitle, l10n.stepFootprintBody),
      (l10n.stepProveTitle, l10n.stepProveBody),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.howItWorks, style: context.text.headingMedium),
        const SizedBox(height: AppSpacing.md),
        for (final (index, (title, body)) in steps.indexed)
          _Step(number: index + 1, title: title, body: body),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const new({required this.number, required this.title, required this.body});

  final int number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: AppSizes.iconFeature / 2,
            backgroundColor: colors.brandPrimary,
            foregroundColor: colors.onBrandPrimary,
            child: Text(
              '$number',
              style: context.text.numeric.copyWith(
                color: colors.onBrandPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.headingSmall),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  body,
                  style: context.text.bodyMedium.copyWith(
                    color: colors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
