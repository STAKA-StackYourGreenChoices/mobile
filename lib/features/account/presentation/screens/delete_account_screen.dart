import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/account/presentation/state/account_data_controllers.dart';
import 'package:staka/features/account/presentation/state/delete_account_state.dart';
import 'package:staka/features/account/presentation/widgets/delete_account_consequences.dart';
import 'package:staka/features/account/presentation/widgets/delete_password_form.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/otp_code_form.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Account → Delete my account (V2-10): what goes, then the password or,
/// for an account without one, a texted code. Once deleted, the app signs
/// out to the welcome screen and says so.
class DeleteAccountScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(
      sessionControllerProvider.select(
        (session) => session is SignedIn ? session.user : null,
      ),
    );
    if (user == null) return const SizedBox.shrink();
    final delete = ref.watch(deleteAccountControllerProvider);
    final controller = ref.read(deleteAccountControllerProvider.notifier);

    ref.listen(deleteAccountControllerProvider, (previous, next) {
      if (next is DeleteDone) {
        // The app's messenger outlives this screen, so welcome shows it.
        AppSnackbar.show(context, message: l10n.accountDeleted);
        unawaited(
          ref
              .read(sessionControllerProvider.notifier)
              .signOutAfterAccountDeleted(),
        );
      } else if (next is DeleteCodeSent &&
          next.failure == null &&
          previous is DeleteSendingCode &&
          previous.sent != null) {
        AppSnackbar.show(context, message: l10n.codeResent);
      }
    });

    // Without a password, the account's number confirms it.
    final phone = user.hasPassword ? null : user.phone;
    final sent = delete.sent;

    final Widget confirm;
    if (phone == null) {
      final failure = switch (delete) {
        DeleteReady(:final failure) => failure,
        _ => null,
      };
      confirm = DeletePasswordForm(
        passwordError: failure is UnauthorizedFailure
            ? l10n.deleteAccountWrongPassword
            : null,
        alertMessage: failure == null || failure is UnauthorizedFailure
            ? null
            : messageForFailure(failure, l10n),
        isDeleting: delete is DeleteDeleting || delete is DeleteDone,
        onSubmitted: (password) => unawaited(controller.withPassword(password)),
      );
    } else if (sent == null) {
      confirm = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          if (delete case DeleteReady(:final failure?))
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
          Text(l10n.deleteAccountConfirmCode(PhoneNumber.display(phone))),
          AppButton(
            label: l10n.sendCode,
            loadingLabel: l10n.sendingCode,
            isLoading: delete is DeleteSendingCode,
            isExpanded: true,
            onPressed: () => unawaited(controller.sendCode(phone)),
          ),
        ],
      );
    } else {
      final failure = switch (delete) {
        DeleteCodeSent(:final failure) => failure,
        _ => null,
      };
      confirm = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Text(
            l10n.codeLede(
              PhoneNumber.display(sent.challenge.phone),
              sent.challenge.expiresIn.inMinutes,
            ),
          ),
          OtpCodeForm(
            // A new code clears the boxes.
            key: ValueKey(sent.sentAt),
            resendAvailableAt: sent.resendAt,
            now: ref.watch(clockProvider),
            alertMessage: failure == null
                ? null
                : codeFailureMessage(failure, l10n),
            isChecking: delete is DeleteDeleting || delete is DeleteDone,
            isResending: delete is DeleteSendingCode,
            submitLabel: l10n.deleteAccount,
            submittingLabel: l10n.deletingAccount,
            isDestructive: true,
            // Deleting can't be undone: the button, never the last digit.
            submitsOnLastDigit: false,
            onSubmitted: (code) => unawaited(controller.withCode(code)),
            onResendPressed: () => unawaited(controller.sendCode(phone)),
          ),
        ],
      );
    }

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthPageHeading(
            title: l10n.deleteAccountTitle,
            lede: l10n.deleteAccountLede,
          ),
          const DeleteAccountConsequences(),
          const SizedBox(height: AppSpacing.xl),
          confirm,
        ],
      ),
    );
  }
}
