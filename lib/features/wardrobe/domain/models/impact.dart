import 'package:flutter/foundation.dart';

import 'package:staka/core/sharing/share_target.dart';

/// The shopper's impact summary, `GET /me/impact` (V2-5).
@immutable
class Impact {
  const new({
    required this.pieces,
    required this.verifiedPieces,
    required this.sharedPieces,
    required this.totalViews,
    required this.carbonGramsOwned,
    required this.points,
  });

  final int pieces;
  final int verifiedPieces;
  final int sharedPieces;

  /// Views of the shopper's public tags and wardrobe.
  final int totalViews;

  /// The footprint of the pieces they own.
  final int carbonGramsOwned;
  final int points;
}

/// What an activity entry is about. The API's names are fixed: keep
/// [apiName] as is; a type the app doesn't know is [other].
enum ActivityType {
  scan('SCAN'),
  scanUnknown('SCAN_UNKNOWN'),
  cardAdded('CARD_ADDED'),
  ownershipVerified('OWNERSHIP_VERIFIED'),
  ownershipRejected('OWNERSHIP_REJECTED'),
  shareCreated('SHARE_CREATED'),
  shareStopped('SHARE_STOPPED'),
  shareClicked('SHARE_CLICKED'),
  tagViewed('TAG_VIEWED'),
  wardrobeViewed('WARDROBE_VIEWED'),
  embedViewed('EMBED_VIEWED'),
  brandLinkClicked('BRAND_LINK_CLICKED'),
  pointsEarned('POINTS_EARNED'),
  voucherRedeemed('VOUCHER_REDEEMED'),
  other('');

  new(this.apiName);

  final String apiName;

  static ActivityType fromApi(String? name) =>
      values.firstWhere((t) => t.apiName == name, orElse: () => other);
}

/// One entry of `GET /me/activity`.
@immutable
class ActivityItem {
  const new({
    required this.type,
    required this.at,
    this.cardId,
    this.productName,
    this.points,
    this.channel,
  });

  final ActivityType type;
  final DateTime at;

  /// The tag it's about, if any; opens it.
  final String? cardId;
  final String? productName;

  /// Points earned (positive) or spent (negative), if any.
  final int? points;
  final ShareChannel? channel;
}

/// One page of the activity list.
@immutable
class ActivityPage {
  const new({required this.items, required this.total});

  final List<ActivityItem> items;
  final int total;
}
