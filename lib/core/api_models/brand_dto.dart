import 'package:json_annotation/json_annotation.dart';

part 'brand_dto.g.dart';

@JsonSerializable(createToJson: false)
class BrandDto {
  const new({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
  });

  factory fromJson(Map<String, dynamic> json) => _$BrandDtoFromJson(json);

  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
}
