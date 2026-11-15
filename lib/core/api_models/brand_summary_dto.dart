import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/models/brand_summary.dart';

part 'brand_summary_dto.g.dart';

/// Wire format of `GET /brands` items (`BrandSummaryDto` in the API).
@JsonSerializable(createToJson: false)
class BrandSummaryDto {
  const new({
    required this.id,
    required this.name,
    required this.productCount,
    required this.createdAt,
    this.description,
    this.logoUrl,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$BrandSummaryDtoFromJson(json);

  final String id;
  final String name;
  final int productCount;
  final DateTime createdAt;
  final String? description;
  final String? logoUrl;

  BrandSummary toDomain() => BrandSummary(
    id: id,
    name: name,
    productCount: productCount,
    createdAt: createdAt,
    description: description,
    logoUrl: logoUrl,
  );
}
