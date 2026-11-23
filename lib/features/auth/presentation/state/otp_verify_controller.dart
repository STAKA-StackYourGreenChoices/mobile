import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/otp_verification.dart';
import 'package:staka/features/auth/presentation/state/otp_verify_state.dart';

part 'otp_verify_controller.g.dart';

/// Checks the code, and creates the account when the number is new.
@riverpod
class OtpVerifyController extends _$OtpVerifyController {
  @override
  OtpVerifyState build() => const OtpVerifyIdle();

  /// Without [name] from the code screen; with it from the name screen.
  Future<void> verify({
    required String challengeId,
    required String code,
    String? name,
  }) async {
    if (state is OtpVerifying) return;
    state = const OtpVerifying();

    final result = await ref
        .read(authRepositoryProvider)
        .verifyOtp(challengeId: challengeId, code: code, name: name);
    if (!ref.mounted) return;

    switch (result) {
      case Ok(value: OtpSignedIn(:final session, :final isNewUser)):
        await ref
            .read(sessionControllerProvider.notifier)
            .signIn(
              tokens: session.tokens,
              user: session.user,
              isNewAccount: isNewUser,
            );
      case Ok(value: OtpNameRequired()):
        state = OtpNeedsName(code);
      case Err(:final failure):
        state = OtpVerifyFailed(failure, code: name == null ? null : code);
    }
  }

  /// A new code was sent: forget the old one's errors.
  void reset() => state = const OtpVerifyIdle();
}
