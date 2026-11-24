import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// "Share your wardrobe" (V2-3): opens the wardrobe share screen. Shown
/// once at least one piece is verified, since only those are public.
class WardrobeShareCard extends StatelessWidget {
  const new({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: MergeSemantics(
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: AppSpacing.card,
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  Icons.checkroom_rounded,
                  size: AppSizes.iconDefault,
                  color: colors.success,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xxs,
                    children: [
                      Text(
                        l10n.wardrobeShareCardTitle,
                        style: context.text.label,
                      ),
                      Text(
                        l10n.wardrobeShareCardBody,
                        style: context.text.bodySmall.copyWith(
                          color: colors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.inkMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
