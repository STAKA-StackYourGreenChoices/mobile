import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/auth/presentation/state/forgot_password_controller.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/auth_switch_link.dart';
import 'package:staka/features/auth/presentation/widgets/forgot_password_form.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// "Reset your password". The emailed link opens the website (decision 7),
/// where the new password is chosen; the confirmation says so.
class ForgotPasswordScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(forgotPasswordControllerProvider);

    final alert = switch (request) {
      RequestDone(value: final email) => (
        message: '${l10n.resetLinkSent(email)} ${l10n.resetLinkOpensWebsite}',
        tone: AlertTone.success,
      ),
      RequestFailed(:final failure) => (
        message: messageForFailure(failure, l10n),
        tone: AlertTone.error,
      ),
      _ => null,
    };

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(title: l10n.forgotTitle, lede: l10n.forgotLede),
          ForgotPasswordForm(
            alert: alert,
            isSending: request is RequestSending,
            hasSent: request is RequestDone,
            onSubmitted: ref
                .read(forgotPasswordControllerProvider.notifier)
                .submit,
          ),
          AuthSwitchLink(
            prompt: l10n.rememberedIt,
            actionLabel: l10n.backToSignIn,
            onPressed: context.pop,
          ),
        ],
      ),
    );
  }
}
