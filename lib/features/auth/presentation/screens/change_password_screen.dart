import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/auth/presentation/state/change_password_controller.dart';
import 'package:staka/features/auth/presentation/state/request_state.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/change_password_form.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Change password, from the Account tab (decision 14: API-only feature the
/// user asked for). On success it confirms and returns to Account.
class ChangePasswordScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(changePasswordControllerProvider);

    ref.listen(changePasswordControllerProvider, (_, next) {
      if (next is! RequestDone) return;
      AppSnackbar.show(context, message: l10n.passwordChanged);
      context.pop();
    });

    final failure = request is RequestFailed ? request.failure : null;

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(
            title: l10n.changePassword,
            lede: l10n.changePasswordLede,
          ),
          ChangePasswordForm(
            currentPasswordError: failure is UnauthorizedFailure
                ? l10n.currentPasswordWrong
                : null,
            alertMessage: failure == null || failure is UnauthorizedFailure
                ? null
                : messageForFailure(failure, l10n),
            isSubmitting: request is RequestSending,
            onSubmitted: (current, next) => ref
                .read(changePasswordControllerProvider.notifier)
                .submit(currentPassword: current, newPassword: next),
          ),
        ],
      ),
    );
  }
}
