import 'package:staka/core/error/failure.dart';
import 'package:staka/features/auth/presentation/state/otp_request_state.dart';

/// Deleting the account (V2-10), confirmed with the password or, for an
/// account without one, with a texted code.
sealed class DeleteAccountState {
  const new();

  /// The code on its way or in use, if this deletion is confirmed by code.
  SentCode? get sent => null;
}

/// Waiting for the password, or for "Send code". [failure] is why the last
/// try didn't go (wrong password, offline, code not sent).
final class DeleteReady extends DeleteAccountState {
  const new({this.failure});

  final Failure? failure;
}

/// A code is being sent; [sent] is the earlier one on a resend.
final class DeleteSendingCode extends DeleteAccountState {
  const new({this.sent});

  @override
  final SentCode? sent;
}

/// Waiting for the code. [failure] is a wrong code or a failed resend.
final class DeleteCodeSent extends DeleteAccountState {
  const new(this.sent, {this.failure});

  @override
  final SentCode sent;
  final Failure? failure;
}

/// The API is deleting the account.
final class DeleteDeleting extends DeleteAccountState {
  const new({this.sent});

  @override
  final SentCode? sent;
}

/// Deleted. The screen says so and signs out.
final class DeleteDone extends DeleteAccountState {
  const new();
}
