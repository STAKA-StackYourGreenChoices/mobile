import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/layout/dashed_border.dart';

/// Shown instead of sharing until ownership is proven, so every tag people
/// see is backed by a real purchase — the website's locked share panel.
class ShareLocked extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = context.colors.inkMuted;
    return DashedBorder(
      color: context.colors.borderStrong,
      radius: AppRadius.md.x,
      child: Padding(
        padding: AppSpacing.card,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: AppSizes.iconInline,
              color: muted,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(l10n.shareLockedTitle, style: context.text.headingSmall),
                  Text(
                    l10n.shareLockedBody,
                    style: context.text.bodyMedium.copyWith(color: muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
