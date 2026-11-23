@Tags(['live'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/manage/import/data/datasources/import_remote_data_source.dart';
import 'package:staka/features/manage/import/data/repositories/import_repository_impl.dart';
import 'package:staka/features/manage/import/domain/models/import_report.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import 'live_client.dart';

/// A 13-digit barcode unique to this run, with a valid check digit.
String _uniqueGtin() {
  // Other live tests run alongside this one: a prefix of its own, and the
  // fastest-changing digits of the clock.
  final micros = '${DateTime.now().microsecondsSinceEpoch}';
  final body = '4${micros.substring(micros.length - 11)}';
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    sum += int.parse(body[i]) * (i.isEven ? 1 : 3);
  }
  return '$body${(10 - sum % 10) % 10}';
}

/// CSV import as the seeded admin (see `liveAdminSkip`): one good row under
/// an existing brand and one without a barcode. Deletes what it imports.
void main() {
  test('template, check (nothing saved), import, clean up', () async {
    final admin = await signedInAdmin();
    final imports = ImportRepositoryImpl(
      ImportRemoteDataSource(admin.dio, const AdminScope()),
    );
    final products = admin.adminProducts;

    final template = await imports.fetchTemplate();
    final columns = utf8
        .decode((template as Ok<Uint8List>).value)
        .split('\n')
        .first
        .trim()
        .split(',');
    expect(columns, containsAll(['gtin', 'sku', 'name', 'brandName']));

    final brands = await products.fetchBrands();
    final brand = (brands as Ok<List<BrandSummary>>).value.first;
    final gtin = _uniqueGtin();
    String row(Map<String, String> values) =>
        [for (final column in columns) values[column] ?? ''].join(',');
    final file = PickedCsv(
      name: 'mobile-live.csv',
      bytes: utf8.encode(
        [
          columns.join(','),
          row({
            'gtin': gtin,
            'sku': 'MOBILE-IMPORT-$gtin',
            'name': 'Mobile Import Tee',
            'brandName': brand.name,
          }),
          row({
            'sku': 'MOBILE-NO-GTIN',
            'name': 'No barcode',
            'brandName': brand.name,
          }),
        ].join('\n'),
      ),
    );

    final check = await imports.check(file);
    final checked = (check as Ok<ImportReport>).value;
    expect((checked.isDryRun, checked.created, checked.failed), (true, 1, 1));
    expect(checked.errors.single.row, 3);
    expect(await _count(admin, gtin), 0); // a check saves nothing

    final run = await imports.importFile(file);
    final done = (run as Ok<ImportReport>).value;
    expect((done.isDryRun, done.created, done.failed), (false, 1, 1));

    final page = await products.fetchProducts(ProductFilter(search: gtin), 1);
    final imported = (page as Ok<ProductPage>).value.items.single;
    expect(imported.name, 'Mobile Import Tee');
    expect(await products.deleteProduct(imported.id), isA<Ok<void>>());
  }, skip: liveAdminSkip);
}

Future<int> _count(LiveClient admin, String gtin) async {
  final page = await admin.adminProducts.fetchProducts(
    ProductFilter(search: gtin),
    1,
  );
  return (page as Ok<ProductPage>).value.total;
}
