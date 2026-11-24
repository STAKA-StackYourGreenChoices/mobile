import 'package:flutter/foundation.dart';

/// Why points came or went (V2-6). The API's names are fixed: keep
/// [apiName] as is; anything else is [other].
enum PointsReason {
  pieceVerified('PIECE_VERIFIED'),
  firstShare('FIRST_SHARE'),
  wardrobeShared('WARDROBE_SHARED'),
  views('VIEWS_10'),
  phoneVerified('PHONE_VERIFIED'),
  redeemed('REDEEMED'),
  reversed('REVERSED'),
  expired('EXPIRED'),
  adjusted('ADJUSTMENT'),
  other('');

  new(this.apiName);

  final String apiName;

  static PointsReason fromApi(String? name) =>
      values.firstWhere((r) => r.apiName == name, orElse: () => other);
}

/// One line of the points history.
@immutable
class PointsEntry {
  const new({
    required this.delta,
    required this.reason,
    required this.at,
    this.expiresAt,
    this.productName,
    this.rewardTitle,
    this.note,
  });

  /// Positive when earned, negative when used, taken back or expired.
  final int delta;
  final PointsReason reason;
  final DateTime at;
  final DateTime? expiresAt;

  /// The piece it was for, if any.
  final String? productName;

  /// The reward it paid for, if any.
  final String? rewardTitle;

  /// An admin's note on an adjustment.
  final String? note;
}

/// `GET /me/points`: the balance, what expires next, and a page of entries.
@immutable
class PointsPage {
  const new({
    required this.balance,
    required this.entries,
    required this.total,
    this.expiringPoints = 0,
    this.expiringOn,
  });

  final int balance;
  final List<PointsEntry> entries;
  final int total;

  /// Points that expire next, on [expiringOn]; 0 when none soon.
  final int expiringPoints;
  final DateTime? expiringOn;
}

/// One way to earn points ("How to earn"), from the active rules.
@immutable
class EarnRule {
  const new({required this.reason, required this.points, this.dailyCap});

  final PointsReason reason;
  final int points;

  /// At most this many a day, e.g. for views.
  final int? dailyCap;
}
