import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// Account → Phone when there is a number: change it, or remove it when
/// the account has another way to sign in.
class CurrentPhoneNumber extends StatelessWidget {
  const new({
    required this.canRemove,
    required this.onChangePressed,
    required this.onRemovePressed,
    super.key,
  });

  final bool canRemove;
  final VoidCallback onChangePressed;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        AppButton(
          label: l10n.accountPhoneChange,
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          onPressed: onChangePressed,
        ),
        if (canRemove)
          AppButton(
            label: l10n.accountPhoneRemove,
            variant: AppButtonVariant.ghost,
            isExpanded: true,
            onPressed: onRemovePressed,
          )
        else
          Text(
            l10n.accountPhoneOnlyWay,
            style: context.text.bodyMedium.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
      ],
    );
  }
}
