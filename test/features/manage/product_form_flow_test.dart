import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_form_header.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
const String _id = '11111111-2222-4333-8444-555555555555';
const String _newId = '99999999-2222-4333-8444-555555555555';

final Product _tee = productNamed('Organic Cotton Tee').copyWith(id: _id);

final Result<List<BrandSummary>> _brands = Ok([
  brandSummary('b1', 'Terra Threads'),
  brandSummary('b2', 'Nordic Loom'),
]);

/// Admin → Products, with [_tee] in the list and the given scripts.
Future<FakeAdminProductRepository> _openProducts(
  WidgetTester tester, {
  Map<String, Result<EditableProduct>> products = const {},
  List<Result<EditableProduct>> saves = const [],
  List<Result<void>> deletes = const [],
}) async {
  usePhoneScreen(tester, height: 800);
  final repository = FakeAdminProductRepository(
    pages: (_) => Ok(pageOf([_tee])),
    brands: _brands,
    products: products,
    saves: saves,
    deletes: deletes,
  );
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [json(200, userJson(role: 'ADMIN'))],
    adminProducts: repository,
  );
  await tester.tap(find.text('Admin'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Products'));
  await tester.pumpAndSettle();
  return repository;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String label, String text) async {
  final field = find.descendant(
    of: find.ancestor(of: find.text(label), matching: find.byType(Column)),
    matching: find.byType(TextField),
  );
  await tester.ensureVisible(field.first);
  await tester.enterText(field.first, text);
  await tester.pump();
}

Future<void> _chooseBrand(WidgetTester tester, String name) async {
  await _tap(tester, find.byType(DropdownButtonFormField<String>));
  await tester.tap(find.text(name).last);
  await tester.pumpAndSettle();
}

Future<FakeAdminProductRepository> _openTee(
  WidgetTester tester, {
  String? storedImageUrl,
  List<Result<EditableProduct>> saves = const [],
  List<Result<void>> deletes = const [],
}) async {
  final repository = await _openProducts(
    tester,
    products: {_id: editable(_tee, storedImageUrl: storedImageUrl)},
    saves: saves,
    deletes: deletes,
  );
  await tester.tap(find.text('Organic Cotton Tee'));
  await tester.pumpAndSettle();
  return repository;
}

final Finder _saveButton = find.widgetWithText(FilledButton, 'Save changes');

void main() {
  testWidgets('add: nothing typed, every rule speaks, nothing is sent', (
    tester,
  ) async {
    final repository = await _openProducts(tester);
    await tester.tap(find.text('Add product'));
    await tester.pumpAndSettle();

    await _tap(tester, find.widgetWithText(FilledButton, 'Add product'));

    expect(
      find.text('Some details need fixing before this product can be saved.'),
      findsOneWidget,
    );
    for (final message in [
      'Enter the product name',
      'Enter the 8, 12, 13 or 14 digits printed under the barcode',
      'Enter the SKU',
    ]) {
      expect(find.text(message), findsOneWidget);
    }
    expect(find.text('Required when figures are included'), findsNWidgets(2));
    expect(find.text('Choose a brand'), findsWidgets);
    expect(repository.saved, isEmpty);
  });

  testWidgets('add without figures: sent, then the new product opens', (
    tester,
  ) async {
    final created = productNamed(
      'Hemp Cap',
      gtin: '08901234500057',
    ).copyWith(id: _newId);
    final repository = await _openProducts(
      tester,
      saves: [editable(created)],
      products: {_newId: editable(created)},
    );
    await tester.tap(find.text('Add product'));
    await tester.pumpAndSettle();

    await _type(tester, 'Name', 'Hemp Cap');
    expect(find.text('Hemp Cap'), findsWidgets); // the preview follows
    await _chooseBrand(tester, 'Nordic Loom');
    await _type(tester, 'Barcode number', '8901234500057');
    await _type(tester, 'SKU', 'NL-CAP-01');
    await _tap(
      tester,
      find.widgetWithText(
        SwitchListTile,
        'Include carbon and recyclability figures',
      ),
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Add product'));

    final (id, draft) = repository.saved.single;
    expect(id, isNull);
    expect(
      (draft.name, draft.brandId, draft.gtin, draft.sku),
      ('Hemp Cap', 'b2', '8901234500057', 'NL-CAP-01'),
    );
    expect(
      (draft.description, draft.imageUrl, draft.figures),
      (null, null, null),
    );
    expect(find.text('Product added'), findsOneWidget);
    expect(find.text('Delete product'), findsOneWidget);
  });

  testWidgets('figures: website rules and the "Shown as" hint', (tester) async {
    await _openProducts(tester);
    await tester.tap(find.text('Add product'));
    await tester.pumpAndSettle();

    await _type(tester, 'Carbon footprint (grams CO₂e)', '2100');
    expect(find.text('Shown as 2.1 kg CO₂e'), findsOneWidget);
    await _type(tester, 'Recyclable (%)', '150');
    await _tap(
      tester,
      find.widgetWithText(SwitchListTile, 'Verified by a third party'),
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Add product'));

    expect(find.text('Recyclability must be 100 or less'), findsOneWidget);
    expect(find.text('Name who verified the figures'), findsOneWidget);
  });

  testWidgets('edit: filled in as stored; saving keeps the stored photo link', (
    tester,
  ) async {
    const stored = 'http://localhost:3000/catalog-images/none.png';
    final renamed = _tee.copyWith(name: 'Organic Cotton Tee II');
    final repository = await _openTee(
      tester,
      storedImageUrl: stored,
      saves: [editable(renamed, storedImageUrl: stored)],
    );

    expect(find.text('Last updated 14 Nov 2026.'), findsOneWidget);
    expect(find.text('8901234500019'), findsOneWidget);
    expect(find.text(stored), findsOneWidget);
    // Saved figures can't be removed: no switch for them.
    expect(find.text('Include carbon and recyclability figures'), findsNothing);

    await _type(tester, 'Name', 'Organic Cotton Tee II');
    await _tap(tester, _saveButton);

    final (id, draft) = repository.saved.single;
    expect(id, _id);
    expect(draft.imageUrl, stored);
    expect(draft.figures?.certifierName, 'Global Organic Textile Standard');
    expect(find.text('Changes saved'), findsOneWidget);
    // The heading shows what the API now holds.
    expect(
      find.descendant(
        of: find.byType(ProductFormHeader),
        matching: find.text('Organic Cotton Tee II', skipOffstage: false),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a code already in use: alert, and the API words on the SKU', (
    tester,
  ) async {
    await _openTee(
      tester,
      saves: [
        const Err(ConflictFailure(['Another product already uses this SKU'])),
      ],
    );

    await _tap(tester, _saveButton);

    expect(
      find.text('Another product already uses this code.'),
      findsOneWidget,
    );
    expect(find.text('Another product already uses this SKU'), findsOneWidget);
  });

  testWidgets('a bad check digit: alert, and the reason on the barcode', (
    tester,
  ) async {
    await _openTee(
      tester,
      saves: [
        const Err(BadRequestFailure(400, ['Invalid check digit (expected 8)'])),
      ],
    );

    await _tap(tester, _saveButton);

    expect(find.text("The barcode number isn't valid."), findsOneWidget);
    expect(
      find.text(
        'Invalid check digit (expected 8). Check the digits under the barcode.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('delete refused: the reason stays in the dialog', (tester) async {
    const reason =
        "1 user card(s) reference this product, so it can't be deleted";
    await _openTee(
      tester,
      deletes: [
        const Err(ConflictFailure([reason])),
      ],
    );

    await _tap(tester, find.text('Delete product'));
    expect(find.text('Delete Organic Cotton Tee?'), findsOneWidget);
    expect(
      find.text(
        "Shoppers will no longer find it by scanning. This can't be undone.",
      ),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Delete product').last);
    await tester.pumpAndSettle();

    expect(find.text(reason), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Delete product').last,
    );
    expect(button.onPressed, isNull);

    await tester.tap(find.text('Keep product'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Organic Cotton Tee?'), findsNothing);
  });

  testWidgets('delete: confirmed, then back to the list', (tester) async {
    final repository = await _openTee(tester, deletes: [const Ok(null)]);

    await _tap(tester, find.text('Delete product'));
    await tester.tap(find.widgetWithText(FilledButton, 'Delete product').last);
    await tester.pumpAndSettle();

    expect(find.text('Organic Cotton Tee deleted'), findsOneWidget);
    expect(find.text('Showing 1–1 of 1 product'), findsOneWidget);
    expect(repository.deleted, [_id]);
    // The list was asked again after the delete.
    expect(repository.requests, hasLength(2));
  });

  testWidgets('a product that does not exist', (tester) async {
    await _openProducts(tester);
    await tester.tap(find.text('Organic Cotton Tee'));
    await tester.pumpAndSettle();

    expect(find.text('This page could not be found.'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Products'));
    await tester.pumpAndSettle();
    expect(find.text('Showing 1–1 of 1 product'), findsOneWidget);
  });
}
