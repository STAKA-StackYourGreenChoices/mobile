// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_application_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandApplicationDto _$BrandApplicationDtoFromJson(Map<String, dynamic> json) =>
    BrandApplicationDto(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      legalName: json['legalName'] as String?,
      statusReason: json['statusReason'] as String?,
      description: json['description'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      gstin: json['gstin'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      logoUrl: json['logoUrl'] as String?,
      existingBrandId: json['existingBrandId'] as String?,
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
    );
