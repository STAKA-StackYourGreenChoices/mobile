import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// What deleting the account does, in the API plan's terms (V2-10): the
/// profile is removed, shares stop, receipts go after the retention period,
/// every session ends.
class DeleteAccountConsequences extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final points = [
      (Icons.person_off_outlined, l10n.deleteAccountRemovesProfile),
      (Icons.link_off_rounded, l10n.deleteAccountStopsShares),
      (Icons.receipt_long_outlined, l10n.deleteAccountDeletesReceipts),
      (Icons.devices_outlined, l10n.deleteAccountSignsOut),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        for (final (icon, text) in points)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              ExcludeSemantics(
                child: Icon(
                  icon,
                  size: AppSizes.iconInline,
                  color: context.colors.inkMuted,
                ),
              ),
              Expanded(child: Text(text, style: context.text.bodyMedium)),
            ],
          ),
      ],
    );
  }
}
