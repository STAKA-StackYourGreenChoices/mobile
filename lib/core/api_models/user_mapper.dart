import 'package:staka/core/api_models/user_dto.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/core/models/user.dart';

extension UserDtoMapper on UserDto {
  /// An unknown role is treated as a shopper: the admin UI only appears for
  /// an explicit `ADMIN`, and the API checks the role on every call anyway.
  User toDomain() => User(
    id: id,
    email: email,
    name: name,
    role: role == 'ADMIN' ? Role.admin : Role.user,
    emailVerified: emailVerified,
    phone: phone,
    phoneVerified: phoneVerified ?? false,
    hasPassword: hasPassword ?? true,
    brands: [
      for (final brand in brands ?? const <BrandMembershipDto>[])
        brand.toDomain(),
    ],
  );
}

extension BrandMembershipDtoMapper on BrandMembershipDto {
  /// An unknown role is staff (fewer rights); an unknown status is pending
  /// (no Brand tab): the API checks both on every call anyway.
  BrandMembership toDomain() => BrandMembership(
    id: id,
    name: name,
    logoUrl: logoUrl,
    role: role == 'OWNER' ? BrandRole.owner : BrandRole.staff,
    status: switch (status) {
      'ACTIVE' => BrandStatus.active,
      'REJECTED' => BrandStatus.rejected,
      'SUSPENDED' => BrandStatus.suspended,
      _ => BrandStatus.pending,
    },
  );
}
