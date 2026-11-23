import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/auth/presentation/state/otp_request_controller.dart';
import 'package:staka/features/auth/presentation/state/otp_request_state.dart';
import 'package:staka/features/auth/presentation/state/otp_verify_controller.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/auth_switch_link.dart';
import 'package:staka/features/auth/presentation/widgets/phone_form.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Step 1 of phone sign-in (V2-1): the number. The same steps sign in and
/// create an account; the API tells us later which one it was.
class PhoneSignInScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(otpRequestControllerProvider);

    Future<void> send(String phone) async {
      final sent = await ref
          .read(otpRequestControllerProvider.notifier)
          .send(phone);
      if (!sent || !context.mounted) return;
      ref.read(otpVerifyControllerProvider.notifier).reset();
      await context.pushNamed(AppRoute.otpCode.name);
    }

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(title: l10n.phoneTitle, lede: l10n.phoneLede),
          PhoneForm(
            alertMessage: switch (request) {
              OtpRequestFailed(:final failure) => messageForFailure(
                failure,
                l10n,
              ),
              _ => null,
            },
            isSending: request is OtpRequestSending,
            onSubmitted: send,
          ),
          AuthSwitchLink(
            prompt: l10n.signInWithEmailPrompt,
            actionLabel: l10n.useEmailInstead,
            onPressed: () => context.pushReplacementNamed(AppRoute.login.name),
          ),
        ],
      ),
    );
  }
}
