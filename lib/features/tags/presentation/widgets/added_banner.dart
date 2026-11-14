import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// "Organic Cotton Tee is in your wardrobe." right after adding it.
class AddedBanner extends StatelessWidget {
  const new({required this.productName, super.key});

  final String productName;

  @override
  Widget build(BuildContext context) {
    final success = context.colors.success;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: success.withValues(alpha: 0.08),
          border: Border.all(color: success.withValues(alpha: 0.35)),
          borderRadius: AppRadius.allSm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            spacing: AppSpacing.xs,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: success),
              Expanded(
                child: Text(
                  context.l10n.addedBanner(productName),
                  style: context.text.bodyMedium.copyWith(color: success),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
