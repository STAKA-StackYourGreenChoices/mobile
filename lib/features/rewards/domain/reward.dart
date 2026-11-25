import 'package:flutter/foundation.dart';

/// A brand's voucher to swap points for (V2-7).
@immutable
class Reward {
  const new({
    required this.id,
    required this.title,
    required this.valueText,
    required this.pointsCost,
    required this.brandName,
    this.description,
    this.terms,
    this.endsAt,
    this.brandLogoUrl,
    this.inStock = true,
    this.canAfford = false,
  });

  final String id;
  final String title;

  /// What it's worth, as the brand wrote it ("₹200 off").
  final String valueText;
  final int pointsCost;
  final String brandName;
  final String? brandLogoUrl;
  final String? description;
  final String? terms;
  final DateTime? endsAt;

  /// Codes are left to hand out.
  final bool inStock;

  /// The shopper has enough points.
  final bool canAfford;
}

/// A redeemed reward with its code (My vouchers, and right after a redeem).
@immutable
class Voucher {
  const new({
    required this.id,
    required this.code,
    required this.rewardTitle,
    required this.valueText,
    required this.brandName,
    required this.points,
    required this.redeemedAt,
    this.expiresAt,
  });

  final String id;
  final String code;
  final String rewardTitle;
  final String valueText;
  final String brandName;
  final int points;
  final DateTime redeemedAt;
  final DateTime? expiresAt;
}

@immutable
class VoucherPage {
  const new({required this.items, required this.total});

  final List<Voucher> items;
  final int total;
}
