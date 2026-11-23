import 'package:staka/core/api_models/user_mapper.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/features/auth/data/dtos/otp_dtos.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';
import 'package:staka/features/auth/domain/models/otp_verification.dart';

extension OtpChallengeMapper on OtpChallengeDto {
  OtpChallenge toDomain({required String phone}) => OtpChallenge(
    id: challengeId,
    phone: phone,
    expiresIn: Duration(seconds: expiresInSeconds),
    resendIn: Duration(seconds: resendInSeconds),
  );
}

extension OtpVerifyMapper on OtpVerifyDto {
  /// Throws [FormatException] for an answer outside the contract, which
  /// `guardApi` turns into an `UnknownFailure`.
  OtpVerification toDomain() => switch (this) {
    OtpVerifyDto(result: 'NAME_REQUIRED') => const OtpNameRequired(),
    OtpVerifyDto(
      result: 'SIGNED_IN',
      :final String accessToken,
      :final String refreshToken,
      :final user?,
    ) =>
      OtpSignedIn(
        AuthSession(
          tokens: AuthTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
          user: user.toDomain(),
        ),
        isNewUser: isNewUser ?? false,
      ),
    _ => throw FormatException('Unexpected code check answer: $result'),
  };
}
