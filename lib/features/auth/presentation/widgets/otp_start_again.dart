import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Shown when a code or name step opens without a code on the way (the app
/// was restarted mid-way): back to the phone number.
class OtpStartAgain extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        AppFormAlert(message: l10n.codeExpired, tone: AlertTone.error),
        AppButton(
          label: l10n.startAgain,
          isExpanded: true,
          onPressed: () => context.goNamed(AppRoute.phoneSignIn.name),
        ),
      ],
    );
  }
}
