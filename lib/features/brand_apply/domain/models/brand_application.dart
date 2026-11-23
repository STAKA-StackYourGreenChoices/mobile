import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_application.freezed.dart';

/// Where a brand's application stands (the brand's `status` in the API).
enum BrandApplicationStatus {
  /// Sent; a STAKA admin hasn't checked it yet.
  pending,

  /// Approved (`ACTIVE`): the brand runs itself on STAKA.
  approved,

  /// Refused, with a reason; the owner can edit and send it again.
  rejected,

  /// Was approved, now paused by STAKA, with a reason.
  suspended,
}

/// A brand the signed-in person applied to bring to STAKA (V2-12), from
/// `GET /me/brand-applications`.
@freezed
abstract class BrandApplication with _$BrandApplication {
  const factory({
    required String id,
    required String name,
    required String legalName,
    required BrandApplicationStatus status,

    /// Why STAKA rejected or paused the brand.
    String? statusReason,
    String? description,
    String? websiteUrl,
    String? gstin,
    String? contactEmail,

    /// E.164.
    String? contactPhone,
    String? logoUrl,

    /// The listed brand this application claims ("My brand is already on
    /// STAKA").
    String? existingBrandId,
    DateTime? appliedAt,
  }) = _BrandApplication;
}
