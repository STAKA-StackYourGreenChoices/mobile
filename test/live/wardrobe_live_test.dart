@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';

import 'live_client.dart';

/// The wardrobe against a running API (see auth_live_test). Uses the
/// seeded "Organic Cotton Tee" (GTIN 08901234500019).
void main() {
  test('a new shopper: empty wardrobe, then the real card JSON maps', () async {
    final client = await signedUpClient();

    final empty = await client.wardrobe.fetchMyCards();
    expect((empty as Ok<List<DigitalCard>>).value, isEmpty);

    // Add a piece the way the product screen will (slice 12).
    await client.dio.post<Object?>(
      '/digital-cards',
      data: {'gtin': '08901234500019'},
    );

    final result = await client.wardrobe.fetchMyCards();
    final card = (result as Ok<List<DigitalCard>>).value.single;
    expect(card.ownerName, 'Mobile Live Test');
    expect(card.product.name, 'Organic Cotton Tee');
    expect(card.product.brand.name, isNotEmpty);
    expect(card.product.sustainabilityInfo, isNotNull);
    expect(card.ownership.status, OwnershipStatus.unverified);
    expect(card.ownership.receiptAttemptsLeft, 5);
    expect(card.share, isNull);
    expect(
      card.product.imageUrl,
      endsWith('/catalog-images/organic-cotton-tee.svg'),
    );
  }, skip: liveSkip);

  test('resending the confirmation email', () async {
    final client = await signedUpClient();

    final resent = await client.wardrobe.resendVerification();
    expect((resent as Ok<ResendOutcome>).value, ResendOutcome.sent);
  }, skip: liveSkip);
}
