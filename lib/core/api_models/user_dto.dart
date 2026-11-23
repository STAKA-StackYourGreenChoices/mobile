import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// Wire format of a user (`GET /auth/me`, and inside auth responses).
/// The API sends more fields (status, ...); only these are read.
///
/// V2 fields (`phone`, `phoneVerified`, `hasPassword`) are optional so the
/// app still works with an API that doesn't send them yet; a V1 account
/// always has an email and a password.
@JsonSerializable(createToJson: false)
class UserDto {
  const new({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.emailVerified,
    this.phone,
    this.phoneVerified,
    this.hasPassword,
    this.brands,
  });

  factory fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  final String id;

  /// Null for an account made with a phone number only.
  final String? email;
  final String name;

  /// `USER` or `ADMIN`.
  final String role;
  final bool emailVerified;

  /// E.164, e.g. `+919876543210`.
  final String? phone;
  final bool? phoneVerified;
  final bool? hasPassword;

  /// V2-12: `[{ id, name, logoUrl, role, status }]`; absent before V2-12.
  final List<BrandMembershipDto>? brands;
}

/// One of `brands[]` in `GET /auth/me`.
@JsonSerializable(createToJson: false)
class BrandMembershipDto {
  const new({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    this.logoUrl,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$BrandMembershipDtoFromJson(json);

  final String id;
  final String name;

  /// `OWNER | STAFF`.
  final String role;

  /// `PENDING | ACTIVE | REJECTED | SUSPENDED`.
  final String status;
  final String? logoUrl;
}
