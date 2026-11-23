import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:staka/core/models/brand_membership.dart';

part 'user.freezed.dart';

enum Role { user, admin }

/// The signed-in person, as `GET /auth/me` describes them.
///
/// Since V2 an account may have only a phone number (`email` null) and no
/// password (`hasPassword` false), when it was made with a text-message code.
@freezed
abstract class User with _$User {
  const factory({
    required String id,
    required String? email,
    required String name,
    required Role role,
    required bool emailVerified,
    String? phone,
    @Default(false) bool phoneVerified,
    @Default(true) bool hasPassword,

    /// Brands the person belongs to (V2-12), any status.
    @Default(<BrandMembership>[]) List<BrandMembership> brands,
  }) = _User;

  const new _();

  bool get isAdmin => role == Role.admin;

  /// The brands shown in the Brand tab (approved or paused), in the API's
  /// order.
  List<BrandMembership> get portalBrands => [
    for (final brand in brands)
      if (brand.hasPortal) brand,
  ];

  /// Whether the Brand tab shows.
  bool get hasBrandPortal => brands.any((brand) => brand.hasPortal);

  /// "Ada" from "Ada Lovelace", as the website greets people.
  String get firstName => name.trim().split(' ').first;
}
