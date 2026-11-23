import 'package:json_annotation/json_annotation.dart';

import 'package:staka/features/brand_apply/domain/models/brand_application.dart';

part 'brand_application_dto.g.dart';

/// Wire format of a brand application: the brand itself with its V2-12
/// fields (`POST /brand-applications`, `GET /me/brand-applications`).
/// Only `id`, `name` and `status` are required, so a slimmer answer still
/// reads.
@JsonSerializable(createToJson: false)
class BrandApplicationDto {
  const new({
    required this.id,
    required this.name,
    required this.status,
    this.legalName,
    this.statusReason,
    this.description,
    this.websiteUrl,
    this.gstin,
    this.contactEmail,
    this.contactPhone,
    this.logoUrl,
    this.existingBrandId,
    this.appliedAt,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$BrandApplicationDtoFromJson(json);

  final String id;
  final String name;

  /// `PENDING | ACTIVE | REJECTED | SUSPENDED`.
  final String status;
  final String? legalName;
  final String? statusReason;
  final String? description;
  final String? websiteUrl;
  final String? gstin;
  final String? contactEmail;
  final String? contactPhone;
  final String? logoUrl;
  final String? existingBrandId;
  final DateTime? appliedAt;

  BrandApplication toDomain() => BrandApplication(
    id: id,
    name: name,
    legalName: legalName ?? name,
    status: switch (status) {
      'ACTIVE' => BrandApplicationStatus.approved,
      'REJECTED' => BrandApplicationStatus.rejected,
      'SUSPENDED' => BrandApplicationStatus.suspended,
      // PENDING, or a status this app doesn't know yet: still being checked.
      _ => BrandApplicationStatus.pending,
    },
    statusReason: statusReason,
    description: description,
    websiteUrl: websiteUrl,
    gstin: gstin,
    contactEmail: contactEmail,
    contactPhone: contactPhone,
    logoUrl: logoUrl,
    existingBrandId: existingBrandId,
    appliedAt: appliedAt,
  );
}
