@Tags(['live'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';

import 'live_client.dart';

/// The tag screen's calls against a running API (see auth_live_test).
/// Leaves one tiny test receipt in the API's uploads folder.
void main() {
  /// A real 1×1 PNG: the API checks file content, not the name.
  final pngBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA'
    '60e6kgAAAABJRU5ErkJggg==',
  );

  test('tag, order match, receipt upload and its limits', () async {
    final client = await signedUpClient();
    final added = await client.products.addToWardrobe('8901234500019');
    final cardId = (added as Ok<DigitalCard>).value.id;

    final tag = await client.tags.fetchTag(cardId);
    expect(
      (tag as Ok<DigitalCard>).value.ownership.status,
      OwnershipStatus.unverified,
    );

    // A new shopper has no paid orders.
    final match = await client.tags.matchOrder(cardId);
    expect((match as Err<Ownership>).failure, isA<NotFoundFailure>());

    // Text named .jpg: refused by content, with a reason for the file.
    final fake = await client.tags.uploadReceipt(
      cardId,
      PickedReceipt(
        name: 'receipt.jpg',
        bytes: Uint8List.fromList(utf8.encode('not an image')),
      ),
    );
    final refused = (fake as Err<Ownership>).failure;
    expect(refused, isA<BadRequestFailure>());
    expect((refused as ApiFailure).message, isNotEmpty);

    // A real image: under review, one upload used.
    final sent = await client.tags.uploadReceipt(
      cardId,
      PickedReceipt(name: 'receipt.png', bytes: pngBytes),
    );
    final pending = (sent as Ok<Ownership>).value;
    expect(pending.status, OwnershipStatus.pending);
    expect(pending.receiptAttemptsLeft, 4);
    expect(pending.pendingSince, isNotNull);

    // Another while one is under review: refused.
    final again = await client.tags.uploadReceipt(
      cardId,
      PickedReceipt(name: 'receipt.png', bytes: pngBytes),
    );
    expect((again as Err<Ownership>).failure, isA<ConflictFailure>());
  }, skip: liveSkip);

  test("someone else's tag is not found", () async {
    final owner = await signedUpClient();
    final added = await owner.products.addToWardrobe('8901234500019');
    final cardId = (added as Ok<DigitalCard>).value.id;

    final stranger = await signedUpClient();
    final result = await stranger.tags.fetchTag(cardId);
    expect((result as Err<DigitalCard>).failure, isA<NotFoundFailure>());
  }, skip: liveSkip);
}
