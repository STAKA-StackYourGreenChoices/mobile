import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/account/data/repositories/account_repository_impl.dart';
import 'package:staka/features/account/domain/repositories/account_repository.dart';

part 'sign_in_method_controllers.g.dart';

/// Account → Phone → "Remove number".
@riverpod
class RemovePhoneController extends _$RemovePhoneController {
  @override
  RequestState<void> build() => const RequestIdle();

  Future<void> submit() => _send(
    ref,
    setState: (next) => state = next,
    isSending: state is RequestSending,
    call: (repository) => repository.removePhone(),
    change: (user) => user.copyWith(phone: null, phoneVerified: false),
    done: null,
  );
}

/// Account → Email, for an account without one.
@riverpod
class AddEmailController extends _$AddEmailController {
  @override
  RequestState<String> build() => const RequestIdle();

  Future<void> submit(String email) {
    final trimmed = email.trim();
    return _send(
      ref,
      setState: (next) => state = next,
      isSending: state is RequestSending,
      call: (repository) => repository.addEmail(email: trimmed),
      change: (user) => user.copyWith(email: trimmed, emailVerified: false),
      done: trimmed,
    );
  }
}

/// Account → Password, for an account without one.
@riverpod
class SetPasswordController extends _$SetPasswordController {
  @override
  RequestState<void> build() => const RequestIdle();

  Future<void> submit(String newPassword) => _send(
    ref,
    setState: (next) => state = next,
    isSending: state is RequestSending,
    call: (repository) => repository.setPassword(newPassword: newPassword),
    change: (user) => user.copyWith(hasPassword: true),
    done: null,
  );
}

/// One request, then the session's user gets the [change] the API just
/// made, so Account shows it without reloading.
Future<void> _send<T>(
  Ref ref, {
  required void Function(RequestState<T>) setState,
  required bool isSending,
  required Future<Result<void>> Function(AccountRepository) call,
  required User Function(User) change,
  required T done,
}) async {
  if (isSending) return;
  final user = switch (ref.read(sessionControllerProvider)) {
    SignedIn(:final user) => user,
    _ => null,
  };
  if (user == null) return;
  // Read up front: the controller may be disposed while awaiting.
  final repository = ref.read(accountRepositoryProvider);
  final session = ref.read(sessionControllerProvider.notifier);
  setState(RequestSending<T>());

  final result = await call(repository);
  switch (result) {
    case Ok():
      session.updateUser(change(user));
      if (ref.mounted) setState(RequestDone<T>(done));
    case Err(:final failure):
      if (ref.mounted) setState(RequestFailed<T>(failure));
  }
}
