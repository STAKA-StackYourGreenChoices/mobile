// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
  id: json['id'] as String,
  gtin: json['gtin'] as String,
  sku: json['sku'] as String,
  name: json['name'] as String,
  brand: BrandDto.fromJson(json['brand'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  sustainabilityInfo: json['sustainabilityInfo'] == null
      ? null
      : SustainabilityInfoDto.fromJson(
          json['sustainabilityInfo'] as Map<String, dynamic>,
        ),
  hidden: json['hidden'] as bool?,
  category: json['category'] as String?,
  styleCode: json['styleCode'] as String?,
  variants: (json['variants'] as List<dynamic>?)
      ?.map((e) => ProductVariantDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  matchedVariant: json['matchedVariant'] == null
      ? null
      : ProductVariantDto.fromJson(
          json['matchedVariant'] as Map<String, dynamic>,
        ),
);
