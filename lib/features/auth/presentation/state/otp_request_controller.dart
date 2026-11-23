import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/presentation/state/otp_request_state.dart';

part 'otp_request_controller.g.dart';

/// Sends (and resends) the sign-in code. Lives while the phone sign-in
/// screens are on the stack.
@riverpod
class OtpRequestController extends _$OtpRequestController {
  @override
  OtpRequestState build() => const OtpRequestIdle();

  /// Texts a code to [phone] (E.164). True when it went out, so the phone
  /// screen knows to open the code screen.
  Future<bool> send(String phone) async {
    if (state is OtpRequestSending) return false;
    final previous = state.sent;
    state = OtpRequestSending(sent: previous);

    final result = await ref
        .read(authRepositoryProvider)
        .requestOtp(phone: phone);
    if (!ref.mounted) return false;

    switch (result) {
      case Ok(:final value):
        final sentAt = ref.read(clockProvider)();
        state = OtpRequestSent(SentCode(value, sentAt: sentAt));
        return true;
      case Err(:final failure):
        state = OtpRequestFailed(failure, sent: previous);
        return false;
    }
  }
}
