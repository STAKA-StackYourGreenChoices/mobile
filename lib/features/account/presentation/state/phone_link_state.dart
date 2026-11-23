import 'package:staka/core/error/failure.dart';
import 'package:staka/features/auth/presentation/state/otp_request_state.dart';

/// Adding or changing the phone number in Account: number, then code.
sealed class PhoneLinkState {
  const new();
}

/// Nothing started: Account → Phone shows the current number, if any.
final class PhoneLinkIdle extends PhoneLinkState {
  const new();
}

/// Typing a number. [failure] is why the last "Send code" didn't go.
final class PhoneLinkEntering extends PhoneLinkState {
  const new({this.failure});

  final Failure? failure;
}

/// A code is being sent. [sent] is the earlier code on a resend.
final class PhoneLinkSending extends PhoneLinkState {
  const new({this.sent});

  final SentCode? sent;
}

/// The code step. [failure] is a wrong code or a resend that failed.
final class PhoneLinkCode extends PhoneLinkState {
  const new(this.sent, {this.failure, this.isVerifying = false});

  final SentCode sent;
  final Failure? failure;
  final bool isVerifying;
}

/// The number is on the account; the session has the new user.
final class PhoneLinkDone extends PhoneLinkState {
  const new();
}
