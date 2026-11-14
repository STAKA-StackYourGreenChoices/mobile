@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';

import 'live_client.dart';

/// Product lookup and "add to my wardrobe" against a running API (see
/// auth_live_test). Uses the seeded "Organic Cotton Tee".
void main() {
  const seededTee = '8901234500019';

  test('lookups: found, misread and not on STAKA yet', () async {
    final client = await signedUpClient();

    final found = await client.products.lookUp(seededTee);
    final product = (found as Ok<ProductLookup>).value as ProductFound;
    expect(product.product.name, 'Organic Cotton Tee');
    expect(product.ownedCardId, isNull);

    // Wrong check digit: the API explains, the screen shows it.
    final misread = await client.products.lookUp('8901234500018');
    final invalid = (misread as Ok<ProductLookup>).value;
    expect(invalid, isA<InvalidBarcode>());
    expect((invalid as InvalidBarcode).message, isNotEmpty);

    // A valid EAN-13 no partner brand has added.
    final unknown = await client.products.lookUp('4006381333931');
    expect((unknown as Ok<ProductLookup>).value, isA<UnknownProduct>());
  }, skip: liveSkip);

  test('add to wardrobe creates the tag once; the product then shows it '
      'as owned', () async {
    final client = await signedUpClient();

    final added = await client.products.addToWardrobe(seededTee);
    final card = (added as Ok<DigitalCard>).value;
    expect(card.product.name, 'Organic Cotton Tee');

    final again = await client.products.addToWardrobe(seededTee);
    expect((again as Ok<DigitalCard>).value.id, card.id);

    final lookup = await client.products.lookUp(seededTee);
    final found = (lookup as Ok<ProductLookup>).value as ProductFound;
    expect(found.ownedCardId, card.id);
  }, skip: liveSkip);
}
