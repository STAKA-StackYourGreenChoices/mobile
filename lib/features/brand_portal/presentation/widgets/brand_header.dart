import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/shared/widgets/data_display/status_pill.dart';

/// The brand's name as the tab heading, the person's role, and Switch
/// brand when [onSwitchPressed] is given (several brands).
class BrandHeader extends StatelessWidget {
  const new({required this.brand, this.onSwitchPressed, super.key});

  final BrandMembership brand;
  final VoidCallback? onSwitchPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.navBrand,
          style: context.text.bodySmall.copyWith(color: colors.inkMuted),
        ),
        Semantics(
          header: true,
          child: Text(brand.name, style: context.text.headingLarge),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusPill(
              icon: brand.isOwner ? Icons.key_outlined : Icons.badge_outlined,
              label: brand.isOwner ? l10n.brandRoleOwner : l10n.brandRoleStaff,
              color: colors.inkMuted,
            ),
            if (onSwitchPressed case final onPressed?)
              TextButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.swap_horiz_rounded),
                label: Text(l10n.switchBrand),
              ),
          ],
        ),
      ],
    );
  }
}
