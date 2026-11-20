import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/auth/presentation/state/auth_form_state.dart';
import 'package:staka/features/auth/presentation/state/login_controller.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/auth_switch_link.dart';
import 'package:staka/features/auth/presentation/widgets/login_form.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Sign in. Success needs no handling here: the session changes and the
/// router moves to the wardrobe.
class LoginScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final form = ref.watch(loginControllerProvider);
    final signedOutBy = ref.watch(
      sessionControllerProvider.select(
        (session) => session is SignedOut ? session.reason : null,
      ),
    );

    final alert = switch (form) {
      AuthFormFailed(failure: UnauthorizedFailure()) => (
        message: l10n.loginWrongCredentials,
        tone: AlertTone.error,
      ),
      AuthFormFailed(:final failure) => (
        message: messageForFailure(failure, l10n),
        tone: AlertTone.error,
      ),
      _ => switch (signedOutBy) {
        SignedOutReason.sessionExpired => (
          message: l10n.errorSessionEnded,
          tone: AlertTone.error,
        ),
        SignedOutReason.passwordChanged => (
          message: l10n.passwordChangedSignIn,
          tone: AlertTone.success,
        ),
        null => null,
      },
    };

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(title: l10n.loginTitle, lede: l10n.loginLede),
          LoginForm(
            alert: alert,
            isSubmitting: form is AuthFormSubmitting,
            onSubmitted: (email, password) => ref
                .read(loginControllerProvider.notifier)
                .submit(email: email, password: password),
            onForgotPasswordPressed: () =>
                context.pushNamed(AppRoute.forgotPassword.name),
          ),
          AuthSwitchLink(
            prompt: l10n.newToStaka,
            actionLabel: l10n.createAccount,
            onPressed: () =>
                context.pushReplacementNamed(AppRoute.register.name),
          ),
        ],
      ),
    );
  }
}
