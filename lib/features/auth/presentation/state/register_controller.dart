import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/presentation/state/auth_form_state.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  AuthFormState build() => const AuthFormIdle();

  /// Like the website, a new account is signed in straight away; the API
  /// has already emailed a confirmation link.
  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is AuthFormSubmitting) return;
    state = const AuthFormSubmitting();

    final result = await ref
        .read(authRepositoryProvider)
        .register(name: name, email: email, password: password);
    if (!ref.mounted) return;

    switch (result) {
      case Ok(:final value):
        await ref
            .read(sessionControllerProvider.notifier)
            .signIn(tokens: value.tokens, user: value.user, isNewAccount: true);
      case Err(:final failure):
        state = AuthFormFailed(failure);
    }
  }
}
