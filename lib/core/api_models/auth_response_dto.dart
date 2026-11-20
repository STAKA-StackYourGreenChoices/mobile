import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/api_models/user_dto.dart';

part 'auth_response_dto.g.dart';

/// Returned by `/auth/login`, `/auth/register` and `/auth/refresh`.
@JsonSerializable(createToJson: false)
class AuthResponseDto {
  const new({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  final String accessToken;

  /// Opaque and single-use: the API rotates it on every refresh.
  final String refreshToken;
  final UserDto user;
}
