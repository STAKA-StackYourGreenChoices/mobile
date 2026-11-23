import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// What a brand gets on STAKA and what to have ready, before the form.
/// Shown while the person has no application yet.
class BrandApplyIntro extends StatelessWidget {
  const new({required this.onStartPressed, super.key});

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.storefront_outlined,
          size: AppSizes.iconEmptyState,
          color: colors.brandPrimary,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.brandApplyIntroBody, style: context.text.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        for (final benefit in [
          l10n.brandApplyBenefitCatalog,
          l10n.brandApplyBenefitClaims,
          l10n.brandApplyBenefitRewards,
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: AppSizes.iconInline,
                  color: colors.success,
                ),
                Expanded(child: Text(benefit, style: context.text.bodyMedium)),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(
            l10n.brandApplyNeedsTitle,
            style: context.text.headingSmall,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.brandApplyNeedsBody,
          style: context.text.bodyMedium.copyWith(color: colors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: l10n.brandApplyStart,
          icon: Icons.arrow_forward_rounded,
          isExpanded: true,
          onPressed: onStartPressed,
        ),
      ],
    );
  }
}
