import 'dart:typed_data';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';

/// The ways a signed-in person signs in (V2-1): their phone number, an
/// email for a phone-only account, and a first password.
abstract interface class AccountRepository {
  /// Texts a code to [phone] (E.164) to add it, or to replace the current
  /// number. 409 when the number is on another account.
  Future<Result<OtpChallenge>> requestPhoneCode({required String phone});

  /// The code from that text. Returns the user with the number on it.
  Future<Result<User>> verifyPhone({
    required String challengeId,
    required String code,
  });

  /// Refused (400) when the number is the account's only way to sign in.
  Future<Result<void>> removePhone();

  /// Adds an email to a phone-only account; the API sends the confirm link.
  Future<Result<void>> addEmail({required String email});

  /// Sets a first password (only when the account has none).
  Future<Result<void>> setPassword({required String newPassword});

  /// Everything STAKA holds about the user, as the API's JSON file.
  Future<Result<Uint8List>> exportData();

  /// Deletes the account for good, confirmed with the password. 401 when
  /// the password is wrong.
  Future<Result<void>> deleteWithPassword({required String password});

  /// Deletes the account for good, confirmed with a texted code. 401 when
  /// the code is wrong, 410 when it has expired.
  Future<Result<void>> deleteWithCode({
    required String challengeId,
    required String code,
  });
}
