import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/auth/presentation/screens/otp_code_screen.dart';
import 'package:staka/features/auth/presentation/state/otp_request_controller.dart';
import 'package:staka/features/auth/presentation/state/otp_verify_controller.dart';
import 'package:staka/features/auth/presentation/state/otp_verify_state.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/otp_name_form.dart';
import 'package:staka/features/auth/presentation/widgets/otp_start_again.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Step 3 of phone sign-in, only for a new number: the name. The same code
/// is sent again with it, which creates the account and signs in.
class OtpNameScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final challenge = ref.watch(otpRequestControllerProvider).sent?.challenge;
    final verify = ref.watch(otpVerifyControllerProvider);
    final code = switch (verify) {
      OtpNeedsName(:final code) => code,
      OtpVerifyFailed(:final code?) => code,
      _ => null,
    };

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(title: l10n.nameTitle, lede: l10n.nameLede),
          if (challenge == null || (code == null && verify is! OtpVerifying))
            const OtpStartAgain()
          else
            OtpNameForm(
              alertMessage: switch (verify) {
                OtpVerifyFailed(:final failure) => codeFailureMessage(
                  failure,
                  l10n,
                ),
                _ => null,
              },
              isSubmitting: verify is OtpVerifying,
              onSubmitted: (name) {
                if (code == null) return;
                unawaited(
                  ref
                      .read(otpVerifyControllerProvider.notifier)
                      .verify(
                        challengeId: challenge.id,
                        code: code,
                        name: name,
                      ),
                );
              },
            ),
        ],
      ),
    );
  }
}
