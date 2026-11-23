import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_membership.freezed.dart';

/// What a member may do in a brand: owners also run the team and the
/// brand's settings.
enum BrandRole { owner, staff }

/// A brand's standing on STAKA (V2-12).
enum BrandStatus { pending, active, rejected, suspended }

/// A brand the signed-in person belongs to, from `GET /auth/me` →
/// `brands[]` (V2-12).
@freezed
abstract class BrandMembership with _$BrandMembership {
  const factory({
    required String id,
    required String name,
    required BrandRole role,
    required BrandStatus status,
    String? logoUrl,
  }) = _BrandMembership;

  const new _();

  bool get isOwner => role == BrandRole.owner;

  /// Approved brands run themselves in the Brand tab; a paused one still
  /// shows there, locked, so its team can see why.
  bool get hasPortal =>
      status == BrandStatus.active || status == BrandStatus.suspended;

  bool get isSuspended => status == BrandStatus.suspended;
}
