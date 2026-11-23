import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';

part 'change_password_controller.g.dart';

@riverpod
class ChangePasswordController extends _$ChangePasswordController {
  @override
  RequestState<void> build() => const RequestIdle();

  /// Changing the password makes the API revoke every session, this phone's
  /// included. So this phone signs straight back in with the new password;
  /// other devices have to sign in again, which is the point. If signing
  /// back in fails, sign-in asks for the new password.
  Future<void> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (state is RequestSending) return;
    final user = switch (ref.read(sessionControllerProvider)) {
      SignedIn(:final user) => user,
      _ => null,
    };
    if (user == null) return;

    // Read up front: this provider may be disposed while awaiting.
    final repository = ref.read(authRepositoryProvider);
    final session = ref.read(sessionControllerProvider.notifier);
    state = const RequestSending();

    final changed = await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (changed case Err(:final failure)) {
      if (ref.mounted) state = RequestFailed(failure);
      return;
    }

    // An account without an email can't sign back in with a password here;
    // it signs in again with a text-message code.
    final email = user.email;
    if (email == null) {
      await session.signOutAfterPasswordChange();
      return;
    }
    switch (await repository.login(email: email, password: newPassword)) {
      case Ok(:final value):
        await session.signIn(tokens: value.tokens, user: value.user);
        if (ref.mounted) state = const RequestDone(null);
      case Err():
        await session.signOutAfterPasswordChange();
    }
  }
}
