import 'package:json_annotation/json_annotation.dart';

part 'sustainability_info_dto.g.dart';

@JsonSerializable(createToJson: false)
class SustainabilityInfoDto {
  const new({
    required this.carbonScoreGrams,
    required this.recyclabilityPercent,
    required this.verified,
    this.verifiedAt,
    this.certifierName,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$SustainabilityInfoDtoFromJson(json);

  final int carbonScoreGrams;
  final int recyclabilityPercent;
  final bool verified;
  final DateTime? verifiedAt;
  final String? certifierName;
}
