// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariantDto _$ProductVariantDtoFromJson(Map<String, dynamic> json) =>
    ProductVariantDto(
      id: json['id'] as String,
      gtin: json['gtin'] as String,
      sku: json['sku'] as String,
      size: json['size'] as String?,
      colour: json['colour'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.map((e) => SkuAliasDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
