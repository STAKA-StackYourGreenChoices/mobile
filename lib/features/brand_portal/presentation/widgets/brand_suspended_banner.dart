import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// A paused brand: what that means, and See why (the reason is on the
/// brand's application, in Account → For brands).
class BrandSuspendedBanner extends StatelessWidget {
  const new({
    required this.brandName,
    required this.onSeeWhyPressed,
    super.key,
  });

  final String brandName;
  final VoidCallback onSeeWhyPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.12),
        border: Border.all(color: colors.warning.withValues(alpha: 0.5)),
        borderRadius: AppRadius.allMd,
      ),
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Icon(Icons.pause_circle_outline_rounded, color: colors.ink),
                Expanded(
                  child: Text(
                    l10n.brandSuspendedBanner(brandName),
                    style: context.text.bodyMedium,
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: onSeeWhyPressed,
                child: Text(l10n.seeWhy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
