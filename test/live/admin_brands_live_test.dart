@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/manage/brands/domain/models/brand_draft.dart';

import 'live_client.dart';

/// Brands as the seeded admin (see `liveAdminSkip`). Deletes what it adds;
/// the delete refused for a brand with products changes nothing.
void main() {
  test('add, refuse a taken name, edit, delete', () async {
    final brands = (await signedInAdmin()).adminBrands;
    final name = 'Mobile Live ${DateTime.now().microsecondsSinceEpoch}';

    final created = await brands.createBrand(
      BrandDraft(name: name, description: 'Made by the app test.'),
    );
    final brand = (created as Ok<BrandSummary>).value;
    expect((brand.name, brand.productCount), (name, 0));

    try {
      final clash = await brands.createBrand(BrandDraft(name: name));
      expect((clash as Err<BrandSummary>).failure, isA<ConflictFailure>());

      final updated = await brands.updateBrand(
        brand.id,
        BrandDraft(name: '$name II', logoUrl: 'https://example.com/logo.png'),
      );
      final edited = (updated as Ok<BrandSummary>).value;
      expect(edited.name, '$name II');
      expect(edited.description, isNull); // sent as null: cleared
      expect(edited.logoUrl, 'https://example.com/logo.png');
    } finally {
      expect(await brands.deleteBrand(brand.id), isA<Ok<void>>());
    }
  }, skip: liveAdminSkip);

  test('a brand with products is not deleted', () async {
    final brands = (await signedInAdmin()).adminBrands;
    final all = await brands.fetchBrands();
    final busy = (all as Ok<List<BrandSummary>>).value.firstWhere(
      (brand) => brand.productCount > 0,
    );

    final result = await brands.deleteBrand(busy.id);

    final failure = (result as Err<void>).failure;
    expect(failure, isA<ConflictFailure>());
    expect((failure as ConflictFailure).message, contains('still has'));
  }, skip: liveAdminSkip);
}
