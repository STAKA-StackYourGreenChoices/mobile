import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// Wire format of a user (`GET /auth/me`, and inside auth responses).
/// The API sends more fields (phone, status, ...); only these are read.
@JsonSerializable(createToJson: false)
class UserDto {
  const new({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.emailVerified,
  });

  factory fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  final String id;
  final String email;
  final String name;

  /// `USER` or `ADMIN`.
  final String role;
  final bool emailVerified;
}
