import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';

part 'verify_email_controller.g.dart';

/// "Send a new link" on the confirm-your-email banner.
@riverpod
class VerifyEmailController extends _$VerifyEmailController {
  @override
  RequestState<ResendOutcome> build() => const RequestIdle();

  Future<void> resend() async {
    if (state is RequestSending) return;
    final session = ref.read(sessionControllerProvider.notifier);
    state = const RequestSending();
    final result = await ref
        .read(wardrobeRepositoryProvider)
        .resendVerification();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
    // Confirmed already, on the website: re-read the user so the banner goes.
    if (result case Ok(value: ResendOutcome.alreadyConfirmed)) {
      await session.refreshUser();
    }
  }
}
