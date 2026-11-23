import 'package:flutter/foundation.dart';

import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_apply/domain/models/brand_file.dart';

/// A brand as its owners edit it in Settings (`GET /brand/:brandId`).
@immutable
class BrandProfile {
  const new({
    required this.id,
    required this.name,
    required this.status,
    this.legalName,
    this.description,
    this.websiteUrl,
    this.logoUrl,
    this.contactEmail,
    this.contactPhone,
  });

  final String id;
  final String name;
  final BrandStatus status;
  final String? legalName;
  final String? description;
  final String? websiteUrl;
  final String? logoUrl;
  final String? contactEmail;

  /// E.164.
  final String? contactPhone;
}

/// What Settings sends (`PATCH /brand/:brandId`): trimmed text, empty
/// optional fields null, [contactPhone] in E.164, [logo] null to keep the
/// current one.
@immutable
class BrandProfileDraft {
  const new({
    required this.name,
    required this.contactEmail,
    this.description,
    this.websiteUrl,
    this.contactPhone,
    this.logo,
  });

  final String name;
  final String contactEmail;
  final String? description;
  final String? websiteUrl;
  final String? contactPhone;
  final BrandFile? logo;
}
