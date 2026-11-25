import 'package:flutter/foundation.dart';

/// One of the brand's own rewards (V2-7, run by the brand since V2-12).
@immutable
class BrandReward {
  const new({
    required this.id,
    required this.title,
    required this.valueText,
    required this.pointsCost,
    required this.startsAt,
    this.description,
    this.terms,
    this.endsAt,
    this.isActive = true,
  });

  final String id;
  final String title;
  final String valueText;
  final int pointsCost;
  final String? description;
  final String? terms;
  final DateTime startsAt;
  final DateTime? endsAt;

  /// Switched on by the brand (and not switched off by STAKA).
  final bool isActive;

  bool hasEnded(DateTime now) => endsAt?.isBefore(now) ?? false;

  /// On, not ended: shoppers see it now or from [startsAt].
  bool isRunning(DateTime now) => isActive && !hasEnded(now);

  bool startsLater(DateTime now) => startsAt.isAfter(now);
}

/// What the brand fills in to create or change a reward.
@immutable
class BrandRewardDraft {
  const new({
    required this.title,
    required this.valueText,
    required this.pointsCost,
    required this.startsAt,
    this.description,
    this.terms,
    this.endsAt,
    this.isActive = true,
  });

  final String title;
  final String valueText;
  final int pointsCost;
  final String? description;
  final String? terms;
  final DateTime startsAt;
  final DateTime? endsAt;
  final bool isActive;

  /// Empty texts and no end date go as null, so an edit can clear them.
  Map<String, Object?> toJson() => {
    'title': title,
    'valueText': valueText,
    'pointsCost': pointsCost,
    'description': description,
    'terms': terms,
    'startsAt': startsAt.toUtc().toIso8601String(),
    'endsAt': endsAt?.toUtc().toIso8601String(),
    'active': isActive,
  };
}

/// Voucher codes behind a reward.
@immutable
class RewardStats {
  const new({
    required this.codesTotal,
    required this.codesLeft,
    required this.redeemed,
  });

  final int codesTotal;
  final int codesLeft;
  final int redeemed;
}

/// What a codes upload did.
@immutable
class CodesUploadReport {
  const new({required this.added, required this.duplicates});

  final int added;
  final int duplicates;
}
