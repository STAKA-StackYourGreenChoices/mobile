@Tags(['live'])
library;

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';

import 'live_client.dart';

/// Claims review against a running API, as the seeded admin (see
/// `liveAdminSkip`). Only claims this run's throwaway shopper sends are
/// decided, so the real queue is never touched.
void main() {
  final skip = liveAdminSkip;

  final png = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA'
    '60e6kgAAAABJRU5ErkJggg==',
  );

  test(
    'queue, detail, receipt; reject with a reason, then approve the retry',
    () async {
      final shopper = await signedUpClient();
      final added = await shopper.products.addToWardrobe('8901234500019');
      final cardId = (added as Ok<DigitalCard>).value.id;
      Future<void> upload() => shopper.tags.uploadReceipt(
        cardId,
        PickedReceipt(name: 'receipt.png', bytes: png),
      );
      final admin = await signedInAdmin();
      final claims = admin.adminClaims;

      // The first receipt is in the queue, with its photo and product.
      await upload();
      final first = await _pendingClaimOf(claims, shopper.email);
      expect((first.method, first.receiptAttempt), (ClaimMethod.receipt, 1));

      final detail = await claims.fetchClaim(first.id);
      expect((detail as Ok<ClaimDetail>).value.history.map((c) => c.id), [
        first.id,
      ]);
      final receipt = await claims.fetchReceipt(first.id);
      expect((receipt as Ok<ClaimReceipt>).value.bytes, png);
      expect(receipt.value.mimeType, 'image/png');
      expect(await claims.fetchProduct(first.product.id), isA<Ok<Object>>());

      // Rejected with a reason the shopper sees; deciding twice conflicts.
      const reason = 'Part of the receipt is cut off';
      final rejected = await claims.reject(first.id, reason);
      expect(
        (rejected as Ok<ClaimDetail>).value.claim.status,
        ClaimStatus.rejected,
      );
      expect(rejected.value.claim.rejectionReason, reason);
      final again = await claims.approve(first.id);
      expect((again as Err<ClaimDetail>).failure, isA<ConflictFailure>());
      final tag = await shopper.tags.fetchTag(cardId);
      expect(
        (tag as Ok<DigitalCard>).value.ownership.status,
        OwnershipStatus.rejected,
      );

      // The retry is attempt 2; approving it makes them the verified owner.
      await upload();
      final second = await _pendingClaimOf(claims, shopper.email);
      expect(second.receiptAttempt, 2);
      final approved = await claims.approve(second.id);
      final decided = (approved as Ok<ClaimDetail>).value;
      expect(decided.claim.status, ClaimStatus.approved);
      expect(decided.history.map((c) => c.status), [
        ClaimStatus.rejected,
        ClaimStatus.approved,
      ]);
      final verified = await shopper.tags.fetchTag(cardId);
      expect(
        (verified as Ok<DigitalCard>).value.ownership.status,
        OwnershipStatus.verified,
      );
    },
    skip: skip,
  );
}

/// This run's shopper's pending claim, found by their unique email while
/// walking the queue page by page (earlier runs may leave others).
Future<Claim> _pendingClaimOf(
  AdminClaimRepositoryImpl claims,
  String email,
) async {
  for (var page = 1; ; page++) {
    final result = await claims.fetchClaims(ClaimStatus.pending, page);
    final items = (result as Ok<ClaimPage>).value.items;
    if (items.isEmpty) fail('No pending claim from $email');
    for (final claim in items) {
      if (claim.user.email == email) return claim;
    }
  }
}
