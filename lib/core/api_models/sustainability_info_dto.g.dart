// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sustainability_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SustainabilityInfoDto _$SustainabilityInfoDtoFromJson(
  Map<String, dynamic> json,
) => SustainabilityInfoDto(
  carbonScoreGrams: (json['carbonScoreGrams'] as num).toInt(),
  recyclabilityPercent: (json['recyclabilityPercent'] as num).toInt(),
  verified: json['verified'] as bool,
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  certifierName: json['certifierName'] as String?,
);
