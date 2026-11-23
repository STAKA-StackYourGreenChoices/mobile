// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as String,
  email: json['email'] as String?,
  name: json['name'] as String,
  role: json['role'] as String,
  emailVerified: json['emailVerified'] as bool,
  phone: json['phone'] as String?,
  phoneVerified: json['phoneVerified'] as bool?,
  hasPassword: json['hasPassword'] as bool?,
  brands: (json['brands'] as List<dynamic>?)
      ?.map((e) => BrandMembershipDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

BrandMembershipDto _$BrandMembershipDtoFromJson(Map<String, dynamic> json) =>
    BrandMembershipDto(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      logoUrl: json['logoUrl'] as String?,
    );
