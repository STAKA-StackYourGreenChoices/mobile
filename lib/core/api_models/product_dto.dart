import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/api_models/brand_dto.dart';
import 'package:staka/core/api_models/sustainability_info_dto.dart';

part 'product_dto.g.dart';

/// Wire format of a product (`presentProduct` in the API): absent fields
/// rather than nulls.
@JsonSerializable(createToJson: false)
class ProductDto {
  const new({
    required this.id,
    required this.gtin,
    required this.sku,
    required this.name,
    required this.brand,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.imageUrl,
    this.sustainabilityInfo,
  });

  factory fromJson(Map<String, dynamic> json) => _$ProductDtoFromJson(json);

  final String id;
  final String gtin;
  final String sku;
  final String name;
  final BrandDto brand;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final String? imageUrl;
  final SustainabilityInfoDto? sustainabilityInfo;
}
