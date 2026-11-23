import 'package:staka/core/error/failure.dart';

/// Checking the code. On success there is no state: the session changes
/// and the router leaves the sign-in screens.
sealed class OtpVerifyState {
  const new();
}

final class OtpVerifyIdle extends OtpVerifyState {
  const new();
}

final class OtpVerifying extends OtpVerifyState {
  const new();
}

/// The code was right but the number is new: ask for a name, then send the
/// same [code] again with it.
final class OtpNeedsName extends OtpVerifyState {
  const new(this.code);

  final String code;
}

/// [code] is kept when the failure happened on the name step, so the name
/// screen can try again.
final class OtpVerifyFailed extends OtpVerifyState {
  const new(this.failure, {this.code});

  final Failure failure;
  final String? code;
}
