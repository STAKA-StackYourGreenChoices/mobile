import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/auth/presentation/state/otp_request_controller.dart';
import 'package:staka/features/auth/presentation/state/otp_request_state.dart';
import 'package:staka/features/auth/presentation/state/otp_verify_controller.dart';
import 'package:staka/features/auth/presentation/state/otp_verify_state.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/otp_code_form.dart';
import 'package:staka/features/auth/presentation/widgets/otp_start_again.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Step 2 of phone sign-in: the code from the text message. A right code
/// signs in (the router leaves), or opens the name step for a new number.
class OtpCodeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(otpRequestControllerProvider);
    final verify = ref.watch(otpVerifyControllerProvider);

    ref
      ..listen(otpVerifyControllerProvider, (previous, next) {
        if (next is OtpNeedsName && previous is! OtpNeedsName) {
          unawaited(context.pushNamed(AppRoute.otpName.name));
        }
      })
      ..listen(otpRequestControllerProvider, (previous, next) {
        // Only a second code is news; the first one opened this screen.
        if (next is OtpRequestSent &&
            previous is OtpRequestSending &&
            previous.sent != null) {
          ref.read(otpVerifyControllerProvider.notifier).reset();
          AppSnackbar.show(context, message: l10n.codeResent);
        }
      });

    final sent = request.sent;
    if (sent == null) {
      return const AppScaffold(showAppBar: true, body: OtpStartAgain());
    }
    final challenge = sent.challenge;

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(
            title: l10n.codeTitle,
            lede: l10n.codeLede(
              PhoneNumber.display(challenge.phone),
              challenge.expiresIn.inMinutes,
            ),
          ),
          OtpCodeForm(
            // A new code clears the boxes.
            key: ValueKey(sent.sentAt),
            resendAvailableAt: sent.resendAt,
            now: ref.watch(clockProvider),
            alertMessage: switch ((verify, request)) {
              (OtpVerifyFailed(:final failure), _) => codeFailureMessage(
                failure,
                l10n,
              ),
              (_, OtpRequestFailed(:final failure)) => messageForFailure(
                failure,
                l10n,
              ),
              _ => null,
            },
            isChecking: verify is OtpVerifying,
            isResending: request is OtpRequestSending,
            onSubmitted: (code) => ref
                .read(otpVerifyControllerProvider.notifier)
                .verify(challengeId: challenge.id, code: code),
            onResendPressed: () => ref
                .read(otpRequestControllerProvider.notifier)
                .send(challenge.phone),
            onChangeNumberPressed: context.pop,
          ),
        ],
      ),
    );
  }
}

/// A wrong or expired code gets its own words; anything else is worded
/// like every other request.
String codeFailureMessage(Failure failure, AppLocalizations l10n) =>
    switch (failure) {
      UnauthorizedFailure() => l10n.codeWrong,
      BadRequestFailure(statusCode: 410) => l10n.codeExpired,
      _ => messageForFailure(failure, l10n),
    };
