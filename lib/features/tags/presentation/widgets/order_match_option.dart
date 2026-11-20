import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Option 1 of proving ownership: look for a paid order on the account.
class OrderMatchOption extends StatelessWidget {
  const new({
    required this.onFindPressed,
    this.isChecking = false,
    this.errorMessage,
    super.key,
  });

  final VoidCallback onFindPressed;
  final bool isChecking;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        _OptionHeading(title: l10n.orderTitle, body: l10n.orderBody),
        if (errorMessage case final message?)
          AppFormAlert(message: message, tone: AlertTone.error),
        AppButton(
          label: l10n.findInOrders,
          loadingLabel: l10n.checkingOrders,
          icon: Icons.manage_search_rounded,
          variant: AppButtonVariant.secondary,
          isLoading: isChecking,
          onPressed: onFindPressed,
        ),
      ],
    );
  }
}

/// Title and one line under it, for each way to prove ownership.
class _OptionHeading extends StatelessWidget {
  const new({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppSpacing.xxs,
    children: [
      Text(title, style: context.text.label),
      Text(
        body,
        style: context.text.bodySmall.copyWith(color: context.colors.inkMuted),
      ),
    ],
  );
}
