import 'package:flutter/foundation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';

/// A code that was sent, and when.
@immutable
class SentCode {
  const new(this.challenge, {required this.sentAt});

  final OtpChallenge challenge;
  final DateTime sentAt;

  /// When "Resend code" becomes available.
  DateTime get resendAt => sentAt.add(challenge.resendIn);
}

/// Asking the API to text a code. [sent] is the latest code that went out:
/// kept while a new one is being asked for, so the code screen keeps its
/// number and countdown.
sealed class OtpRequestState {
  const new();

  SentCode? get sent;
}

final class OtpRequestIdle extends OtpRequestState {
  const new();

  @override
  SentCode? get sent => null;
}

final class OtpRequestSending extends OtpRequestState {
  const new({this.sent});

  @override
  final SentCode? sent;
}

final class OtpRequestSent extends OtpRequestState {
  const new(this.code);

  final SentCode code;

  @override
  SentCode get sent => code;
}

final class OtpRequestFailed extends OtpRequestState {
  const new(this.failure, {this.sent});

  final Failure failure;

  @override
  final SentCode? sent;
}
