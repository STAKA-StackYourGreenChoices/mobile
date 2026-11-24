import 'package:json_annotation/json_annotation.dart';

part 'product_variant_dto.g.dart';

/// Wire format of a product variant (V2-2).
@JsonSerializable(createToJson: false)
class ProductVariantDto {
  const new({
    required this.id,
    required this.gtin,
    required this.sku,
    this.size,
    this.colour,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$ProductVariantDtoFromJson(json);

  final String id;
  final String gtin;
  final String sku;
  final String? size;
  final String? colour;
}
