import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';

/// The API's `OWNER | STAFF`; unknown is staff (fewer rights).
BrandRole brandRoleFromJson(Object? role) =>
    role == 'OWNER' ? BrandRole.owner : BrandRole.staff;

String brandRoleToJson(BrandRole role) => switch (role) {
  BrandRole.owner => 'OWNER',
  BrandRole.staff => 'STAFF',
};

BrandStatus brandStatusFromJson(Object? status) => switch (status) {
  'ACTIVE' => BrandStatus.active,
  'REJECTED' => BrandStatus.rejected,
  'SUSPENDED' => BrandStatus.suspended,
  _ => BrandStatus.pending,
};

/// `GET /brand/:brandId` (the brand with its V2-12 fields).
BrandProfile brandProfileFromJson(Map<String, dynamic> json) => BrandProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  status: brandStatusFromJson(json['status']),
  legalName: json['legalName'] as String?,
  description: json['description'] as String?,
  websiteUrl: json['websiteUrl'] as String?,
  logoUrl: json['logoUrl'] as String?,
  contactEmail: json['contactEmail'] as String?,
  contactPhone: json['contactPhone'] as String?,
);

/// One of `GET /brand/:brandId/members`. The plan names the membership's
/// fields (`userId`, `role`) but not how the person is sent, so both a
/// flat answer (`name`, `email`, `phone`) and a nested `user` are read.
BrandMember brandMemberFromJson(Map<String, dynamic> json) {
  final user = json['user'] as Map<String, dynamic>? ?? const {};
  return BrandMember(
    userId: (json['userId'] ?? user['id']) as String,
    name: (json['name'] ?? user['name'] ?? '') as String,
    role: brandRoleFromJson(json['role']),
    email: (json['email'] ?? user['email']) as String?,
    phone: (json['phone'] ?? user['phone']) as String?,
  );
}
