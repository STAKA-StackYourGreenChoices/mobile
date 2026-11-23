import 'package:flutter/foundation.dart';

import 'package:staka/features/brand_apply/domain/models/brand_file.dart';

/// What the application form sends: trimmed text, optional fields null when
/// left empty, [contactPhone] in E.164. Files are null when none was picked
/// (on a resubmit: keep the one already sent).
@immutable
class BrandApplicationDraft {
  const new({
    required this.name,
    required this.legalName,
    required this.contactEmail,
    this.contactPhone,
    this.websiteUrl,
    this.gstin,
    this.description,
    this.existingBrandId,
    this.logo,
    this.document,
  });

  final String name;
  final String legalName;
  final String contactEmail;
  final String? contactPhone;
  final String? websiteUrl;
  final String? gstin;
  final String? description;
  final String? existingBrandId;
  final BrandFile? logo;
  final BrandFile? document;
}
