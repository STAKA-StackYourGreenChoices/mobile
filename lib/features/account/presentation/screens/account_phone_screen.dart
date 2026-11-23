import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/account/presentation/state/phone_link_controller.dart';
import 'package:staka/features/account/presentation/state/phone_link_state.dart';
import 'package:staka/features/account/presentation/widgets/current_phone_number.dart';
import 'package:staka/features/account/presentation/widgets/remove_phone_dialog.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/features/auth/presentation/widgets/otp_code_form.dart';
import 'package:staka/features/auth/presentation/widgets/phone_form.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Account → Phone number (V2-1): add a number, change it, or remove it.
/// Adding and changing text a code, like phone sign-in.
class AccountPhoneScreen extends ConsumerWidget {
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
    final link = ref.watch(phoneLinkControllerProvider);
    final controller = ref.read(phoneLinkControllerProvider.notifier);

    ref.listen(phoneLinkControllerProvider, (previous, next) {
      if (next is PhoneLinkDone) {
        AppSnackbar.show(context, message: l10n.accountPhoneSaved);
        context.pop();
      } else if (next is PhoneLinkCode &&
          next.failure == null &&
          previous is PhoneLinkSending &&
          previous.sent != null) {
        AppSnackbar.show(context, message: l10n.codeResent);
      }
    });

    Future<void> remove(String phone) async {
      final removed = await showRemovePhoneDialog(context, phone: phone);
      if (!removed || !context.mounted) return;
      AppSnackbar.show(context, message: l10n.accountPhoneRemoved);
      context.pop();
    }

    final sent = switch (link) {
      PhoneLinkCode(:final sent) => sent,
      PhoneLinkSending(:final sent?) => sent,
      _ => null,
    };

    final Widget step;
    final String title;
    final String lede;
    if (sent != null) {
      title = l10n.codeTitle;
      lede = l10n.codeLede(
        PhoneNumber.display(sent.challenge.phone),
        sent.challenge.expiresIn.inMinutes,
      );
      final failure = switch (link) {
        PhoneLinkCode(:final failure) => failure,
        _ => null,
      };
      step = OtpCodeForm(
        // A new code clears the boxes.
        key: ValueKey(sent.sentAt),
        resendAvailableAt: sent.resendAt,
        now: ref.watch(clockProvider),
        alertMessage: failure == null
            ? null
            : codeFailureMessage(failure, l10n),
        isChecking: link is PhoneLinkCode && link.isVerifying,
        isResending: link is PhoneLinkSending,
        onSubmitted: (code) => unawaited(controller.verify(code)),
        onResendPressed: () => unawaited(controller.send(sent.challenge.phone)),
        onChangeNumberPressed: controller.start,
      );
    } else if (user.phone case final phone? when link is PhoneLinkIdle) {
      title = l10n.accountPhoneRow;
      lede = l10n.accountPhoneLede(PhoneNumber.display(phone));
      step = CurrentPhoneNumber(
        // Phone codes, or email + password: keep at least one.
        canRemove: user.email != null && user.hasPassword,
        onChangePressed: controller.start,
        onRemovePressed: () => unawaited(remove(phone)),
      );
    } else {
      title = l10n.accountPhoneRow;
      lede = user.phone == null
          ? l10n.accountPhoneAddLede
          : l10n.accountPhoneLede(PhoneNumber.display(user.phone!));
      step = PhoneForm(
        alertMessage: switch (link) {
          PhoneLinkEntering(failure: ConflictFailure()) => l10n.phoneTaken,
          PhoneLinkEntering(:final failure?) => messageForFailure(
            failure,
            l10n,
          ),
          _ => null,
        },
        isSending: link is PhoneLinkSending,
        onSubmitted: (phone) => unawaited(controller.send(phone)),
      );
    }

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(title: title, lede: lede),
          step,
        ],
      ),
    );
  }
}
