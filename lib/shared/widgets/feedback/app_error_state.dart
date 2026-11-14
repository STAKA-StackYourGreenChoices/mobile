import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/feedback_message.dart';

/// A screen or section that failed to load: what happened, in the app's
/// voice (`messageForFailure`), and a way to try again.
class AppErrorState extends StatelessWidget {
  const new({required this.failure, this.onRetryPressed, super.key});

  final Failure failure;
  final VoidCallback? onRetryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isOffline = failure is NetworkFailure;
    return FeedbackMessage(
      icon: isOffline ? Icons.cloud_off_rounded : Icons.error_outline_rounded,
      iconColor: context.colors.inkMuted,
      title: Text(
        isOffline ? l10n.errorOfflineTitle : l10n.errorTitle,
        style: context.text.headingMedium,
      ),
      message: messageForFailure(failure, l10n),
      action: switch (onRetryPressed) {
        final onPressed? => AppButton(
          label: l10n.tryAgain,
          icon: Icons.refresh_rounded,
          variant: AppButtonVariant.secondary,
          onPressed: onPressed,
        ),
        null => null,
      },
    );
  }
}
