import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/api_models/brand_dto.dart';
import 'package:staka/core/api_models/product_variant_dto.dart';
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
    this.hidden,
    this.category,
    this.styleCode,
    this.variants,
    this.matchedVariant,
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

  /// Admin lists only (V2-12).
  final bool? hidden;

  /// V2-2: `TOPS`, `BOTTOMS`, … or `OTHER`.
  final String? category;
  final String? styleCode;
  final List<ProductVariantDto>? variants;

  /// Product lookups by barcode only (V2-2).
  final ProductVariantDto? matchedVariant;
}
