import 'package:json_annotation/json_annotation.dart';

part 'share_link_dto.g.dart';

@JsonSerializable(createToJson: false)
class ShareLinkDto {
  const new({required this.slug, required this.createdAt});

  factory fromJson(Map<String, dynamic> json) => _$ShareLinkDtoFromJson(json);

  final String slug;
  final DateTime createdAt;
}
