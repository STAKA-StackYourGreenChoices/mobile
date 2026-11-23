import 'package:flutter/foundation.dart';

/// A text-message code the API has just sent to [phone] (E.164).
@immutable
class OtpChallenge {
  const new({
    required this.id,
    required this.phone,
    required this.expiresIn,
    required this.resendIn,
  });

  /// Sent back with the code.
  final String id;
  final String phone;

  /// How long the code works for (5 minutes).
  final Duration expiresIn;

  /// How long before another code may be asked for (30 seconds).
  final Duration resendIn;
}
