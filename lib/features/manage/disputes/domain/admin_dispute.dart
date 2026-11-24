import 'package:flutter/foundation.dart' show immutable;

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';

/// A shopper asked STAKA to look again at a brand's rejection (V2-12).
@immutable
class AdminDispute {
  const new({
    required this.id,
    required this.claimId,
    required this.status,
    required this.message,
    required this.createdAt,
    this.resolution,
    this.resolvedAt,
    this.claim,
  });

  final String id;
  final String claimId;
  final DisputeStatus status;

  /// What the shopper wrote (10–1000 characters).
  final String message;
  final DateTime createdAt;

  /// STAKA's note, once resolved.
  final String? resolution;
  final DateTime? resolvedAt;

  /// The disputed claim, when the list sends it along.
  final Claim? claim;
}

/// How an admin settles a dispute.
enum DisputeOutcome {
  /// The brand was right: the rejection stands.
  uphold('UPHOLD'),

  /// The brand was wrong: the receipt is approved.
  overturn('OVERTURN');

  new(this.apiName);

  final String apiName;
}

abstract interface class DisputeRepository {
  /// Oldest first, so the longest wait comes first.
  Future<Result<List<AdminDispute>>> fetchDisputes(DisputeStatus status);

  /// [note] (3–500) is shown to the shopper.
  Future<Result<void>> resolve(String id, DisputeOutcome outcome, String note);
}
