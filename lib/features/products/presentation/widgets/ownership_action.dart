import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// "In your wardrobe · View your tag" when the shopper already has this
/// piece, otherwise "Add to my wardrobe" — the website's product actions.
class OwnershipAction extends StatelessWidget {
  const new({
    required this.onAddPressed,
    this.onViewTagPressed,
    this.isAdding = false,
    this.errorMessage,
    super.key,
  });

  /// Set when the shopper already has this piece: opens their tag.
  final VoidCallback? onViewTagPressed;
  final VoidCallback onAddPressed;
  final bool isAdding;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    if (onViewTagPressed case final onViewTag?) {
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xs,
            children: [
              Icon(Icons.verified_rounded, color: colors.success),
              Flexible(
                child: Text(
                  l10n.productInWardrobe,
                  style: context.text.label.copyWith(color: colors.success),
                ),
              ),
            ],
          ),
          AppButton(
            label: l10n.viewYourTag,
            variant: AppButtonVariant.secondary,
            onPressed: onViewTag,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        if (errorMessage case final message?)
          AppFormAlert(message: message, tone: AlertTone.error),
        AppButton(
          label: l10n.addToMyWardrobe,
          loadingLabel: l10n.adding,
          icon: Icons.add_rounded,
          isLoading: isAdding,
          onPressed: onAddPressed,
        ),
      ],
    );
  }
}
