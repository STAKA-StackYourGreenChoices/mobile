import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/account/presentation/state/sign_in_method_controllers.dart';
import 'package:staka/features/account/presentation/widgets/set_password_form.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Account → Set a password, for an account that has none (V2-1).
class SetPasswordScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(setPasswordControllerProvider);
    final hasEmail = ref.watch(
      sessionControllerProvider.select(
        (session) => session is SignedIn && session.user.email != null,
      ),
    );

    ref.listen(setPasswordControllerProvider, (_, next) {
      if (next is! RequestDone) return;
      AppSnackbar.show(context, message: l10n.passwordSet);
      context.pop();
    });

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(
            title: l10n.setPasswordTitle,
            lede: hasEmail ? l10n.setPasswordLede : l10n.setPasswordLedeNoEmail,
          ),
          SetPasswordForm(
            alertMessage: switch (request) {
              RequestFailed(:final failure) => messageForFailure(failure, l10n),
              _ => null,
            },
            isSubmitting: request is RequestSending,
            onSubmitted: (password) => unawaited(
              ref.read(setPasswordControllerProvider.notifier).submit(password),
            ),
          ),
        ],
      ),
    );
  }
}
