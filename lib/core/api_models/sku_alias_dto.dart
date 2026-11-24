import 'package:json_annotation/json_annotation.dart';

part 'sku_alias_dto.g.dart';

/// A code another shop uses for a variant (V2-2): `{ source, code }`.
@JsonSerializable(createToJson: false)
class SkuAliasDto {
  const new({required this.source, required this.code});

  factory fromJson(Map<String, dynamic> json) => _$SkuAliasDtoFromJson(json);

  final String source;
  final String code;
}
