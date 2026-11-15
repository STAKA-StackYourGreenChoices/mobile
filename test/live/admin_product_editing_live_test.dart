@Tags(['live'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/domain/models/editable_product.dart';
import 'package:staka/features/admin/products/domain/models/product_draft.dart';

import 'live_client.dart';

/// A 13-digit barcode unique to this run, with a valid check digit.
String _uniqueGtin({String prefix = '2'}) {
  final body = '$prefix${DateTime.now().millisecondsSinceEpoch}'.substring(
    0,
    12,
  );
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    sum += int.parse(body[i]) * (i.isEven ? 1 : 3);
  }
  return '$body${(10 - sum % 10) % 10}';
}

/// Adding, editing and deleting a product as the seeded admin (see
/// `liveAdminSkip`). Deletes what it adds.
void main() {
  test('add, edit, refuse a taken SKU, delete', () async {
    final admin = await signedInAdmin();
    final products = admin.adminProducts;
    final brands = await products.fetchBrands();
    final brand = (brands as Ok<List<BrandSummary>>).value.first;
    final gtin = _uniqueGtin();
    final sku = 'MOBILE-LIVE-$gtin';

    final created = await products.createProduct(
      ProductDraft(
        name: 'Mobile Live Cap',
        brandId: brand.id,
        gtin: gtin,
        sku: sku,
        figures: const FiguresDraft(
          carbonScoreGrams: 900,
          recyclabilityPercent: 70,
          isVerified: false,
        ),
      ),
    );
    final product = (created as Ok<EditableProduct>).value.product;
    expect(product.gtin, '0$gtin');
    expect(product.sustainabilityInfo?.isVerified, isFalse);

    try {
      final updated = await products.updateProduct(
        product.id,
        ProductDraft(
          name: 'Mobile Live Cap II',
          brandId: brand.id,
          gtin: gtin,
          sku: sku,
          description: 'Edited by the app.',
          figures: const FiguresDraft(
            carbonScoreGrams: 950,
            recyclabilityPercent: 75,
            isVerified: true,
            certifierName: 'OEKO-TEX',
          ),
        ),
      );
      final edited = (updated as Ok<EditableProduct>).value.product;
      expect(edited.name, 'Mobile Live Cap II');
      expect(edited.description, 'Edited by the app.');
      expect(edited.sustainabilityInfo?.certifierName, 'OEKO-TEX');

      // Same SKU, other barcode: the API names the SKU.
      final clash = await products.createProduct(
        ProductDraft(
          name: 'Clash',
          brandId: brand.id,
          gtin: _uniqueGtin(prefix: '3'),
          sku: sku,
        ),
      );
      final failure = (clash as Err<EditableProduct>).failure;
      expect(failure, isA<ConflictFailure>());
      expect((failure as ConflictFailure).message, contains('SKU'));
    } finally {
      expect(await products.deleteProduct(product.id), isA<Ok<void>>());
    }
    final gone = await products.fetchProduct(product.id);
    expect((gone as Err<EditableProduct>).failure, isA<NotFoundFailure>());
  }, skip: liveAdminSkip);
}
