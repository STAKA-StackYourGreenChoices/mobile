import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/presentation/state/auth_form_state.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  AuthFormState build() => const AuthFormIdle();

  Future<void> submit({required String email, required String password}) async {
    if (state is AuthFormSubmitting) return;
    state = const AuthFormSubmitting();

    final result = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    if (!ref.mounted) return;

    switch (result) {
      case Ok(:final value):
        await ref
            .read(sessionControllerProvider.notifier)
            .signIn(tokens: value.tokens, user: value.user);
      case Err(:final failure):
        state = AuthFormFailed(failure);
    }
  }
}
