import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/api_models/user_dto.dart';

part 'otp_dtos.g.dart';

/// `POST /auth/otp/request` (and `/me/phone`) answer.
@JsonSerializable(createToJson: false)
class OtpChallengeDto {
  const new({
    required this.challengeId,
    required this.expiresInSeconds,
    required this.resendInSeconds,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$OtpChallengeDtoFromJson(json);

  final String challengeId;
  final int expiresInSeconds;
  final int resendInSeconds;
}

/// `POST /auth/otp/verify` answer: `result` is `SIGNED_IN` (tokens, user,
/// isNewUser present) or `NAME_REQUIRED` (nothing else).
@JsonSerializable(createToJson: false)
class OtpVerifyDto {
  const new({
    required this.result,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isNewUser,
  });

  factory fromJson(Map<String, dynamic> json) => _$OtpVerifyDtoFromJson(json);

  final String result;
  final String? accessToken;
  final String? refreshToken;
  final UserDto? user;
  final bool? isNewUser;
}
