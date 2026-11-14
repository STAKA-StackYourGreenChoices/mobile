import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';

/// "New to STAKA? Create an account" under the form. Wraps at large text.
class AuthSwitchLink extends StatelessWidget {
  const new({
    required this.prompt,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg),
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          prompt,
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        AppButton(
          label: actionLabel,
          variant: AppButtonVariant.ghost,
          onPressed: onPressed,
        ),
      ],
    ),
  );
}
