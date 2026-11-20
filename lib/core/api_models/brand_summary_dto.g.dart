// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandSummaryDto _$BrandSummaryDtoFromJson(Map<String, dynamic> json) =>
    BrandSummaryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      productCount: (json['productCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
