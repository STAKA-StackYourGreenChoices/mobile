import 'package:flutter/foundation.dart';

import 'package:staka/core/models/brand_membership.dart';

/// Someone on a brand's team (`GET /brand/:brandId/members`).
@immutable
class BrandMember {
  const new({
    required this.userId,
    required this.name,
    required this.role,
    this.email,
    this.phone,
  });

  final String userId;
  final String name;
  final BrandRole role;
  final String? email;

  /// E.164.
  final String? phone;

  @override
  bool operator ==(Object other) =>
      other is BrandMember &&
      other.userId == userId &&
      other.name == name &&
      other.role == role &&
      other.email == email &&
      other.phone == phone;

  @override
  int get hashCode => Object.hash(userId, name, role, email, phone);
}
