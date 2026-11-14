import 'package:staka/core/error/failure.dart';

/// The state of the sign-in or register form. On success there is no
/// state: the session changes and the router leaves the screen.
sealed class AuthFormState {
  const new();
}

final class AuthFormIdle extends AuthFormState {
  const new();
}

final class AuthFormSubmitting extends AuthFormState {
  const new();
}

/// The API refused. The form decides how to show it (a field error for a
/// taken email, an alert for wrong credentials), since only it has copy.
final class AuthFormFailed extends AuthFormState {
  const new(this.failure);

  final Failure failure;
}
