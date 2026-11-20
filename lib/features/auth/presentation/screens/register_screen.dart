import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/auth/presentation/state/auth_form_state.dart';
import 'package:staka/features/auth/presentation/state/register_controller.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/auth_switch_link.dart';
import 'package:staka/features/auth/presentation/widgets/register_form.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Create an account. On success the user is signed in and the router
/// moves to the wardrobe, which greets them (`SignedIn.isNewAccount`).
class RegisterScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final form = ref.watch(registerControllerProvider);
    final failure = form is AuthFormFailed ? form.failure : null;

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(title: l10n.registerTitle, lede: l10n.registerLede),
          RegisterForm(
            // A taken email belongs on the email field, as on the website.
            emailError: failure is ConflictFailure
                ? l10n.registerEmailTaken
                : null,
            alertMessage: failure == null || failure is ConflictFailure
                ? null
                : messageForFailure(failure, l10n),
            isSubmitting: form is AuthFormSubmitting,
            onSubmitted: (name, email, password) => ref
                .read(registerControllerProvider.notifier)
                .submit(name: name, email: email, password: password),
          ),
          AuthSwitchLink(
            prompt: l10n.alreadyHaveAccount,
            actionLabel: l10n.signIn,
            onPressed: () => context.pushReplacementNamed(AppRoute.login.name),
          ),
        ],
      ),
    );
  }
}
