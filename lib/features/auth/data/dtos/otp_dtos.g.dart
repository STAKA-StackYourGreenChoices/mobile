// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpChallengeDto _$OtpChallengeDtoFromJson(Map<String, dynamic> json) =>
    OtpChallengeDto(
      challengeId: json['challengeId'] as String,
      expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
      resendInSeconds: (json['resendInSeconds'] as num).toInt(),
    );

OtpVerifyDto _$OtpVerifyDtoFromJson(Map<String, dynamic> json) => OtpVerifyDto(
  result: json['result'] as String,
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
  user: json['user'] == null
      ? null
      : UserDto.fromJson(json['user'] as Map<String, dynamic>),
  isNewUser: json['isNewUser'] as bool?,
);
