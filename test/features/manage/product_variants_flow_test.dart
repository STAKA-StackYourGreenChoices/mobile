import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/features/manage/products/presentation/widgets/variant_card.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');
const String _id = '11111111-2222-4333-8444-555555555555';

const _small = ProductVariant(
  id: 'v1',
  gtin: '08901234500019',
  sku: 'TT-TEE-S',
  size: 'S',
);
const _medium = ProductVariant(
  id: 'v2',
  gtin: '08901234500057',
  sku: 'TT-TEE-M',
  size: 'M',
  colour: 'Navy',
);

final Product _tee = productNamed('Organic Cotton Tee').copyWith(
  id: _id,
  category: ProductCategory.tops,
  styleCode: 'TT-TEE',
  variants: const [_small, _medium],
);

/// Brand → Products as Terra Threads' owner, with [_tee] listed.
Future<FakeAdminProductRepository> _openProducts(
  WidgetTester tester, {
  Map<String, Result<EditableProduct>> products = const {},
  List<Result<EditableProduct>> saves = const [],
  List<Result<void>> aliasChanges = const [],
}) async {
  usePhoneScreen(tester, height: 800);
  final repository = FakeAdminProductRepository(
    pages: (_) => Ok(pageOf([_tee])),
    brands: Ok([brandSummary('b1', 'Terra Threads')]),
    products: products,
    saves: saves,
    aliasChanges: aliasChanges,
  );
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(200, memberUserJson([membershipJson()])),
    ],
    adminProducts: repository,
  );
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Brand'),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Products'));
  await tester.pumpAndSettle();
  return repository;
}

/// Opens [_tee] for editing, with Myntra's code on the medium.
Future<FakeAdminProductRepository> _openTee(
  WidgetTester tester, {
  List<Result<EditableProduct>> saves = const [],
  List<Result<void>> aliasChanges = const [],
}) async {
  final repository = await _openProducts(
    tester,
    products: {
      _id: Ok(
        EditableProduct(
          product: _tee,
          aliases: const {
            'v2': [SkuAlias(source: 'Myntra', code: 'MY-2')],
          },
        ),
      ),
    },
    saves: saves,
    aliasChanges: aliasChanges,
  );
  await tester.tap(find.text('Organic Cotton Tee'));
  await tester.pumpAndSettle();
  return repository;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder _card(int index) => find.byType(VariantCard).at(index);

Finder _inCard(int index, Finder finder) =>
    find.descendant(of: _card(index), matching: finder);

/// The text field under [label]: inside size/colour card [card] when
/// given, else the first on the page.
Finder _field(String label, {int? card}) {
  final labelled = find.ancestor(
    of: find.text(label),
    matching: find.byType(AppTextField),
  );
  final field = find.descendant(
    of: card == null ? labelled.first : _inCard(card, labelled),
    matching: find.byType(TextField),
  );
  return field.first;
}

Future<void> _type(
  WidgetTester tester,
  String label,
  String text, {
  int? card,
}) async {
  final field = _field(label, card: card);
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await tester.pump();
}

void main() {
  testWidgets('add: two sizes, a kind and a style code are sent', (
    tester,
  ) async {
    final repository = await _openProducts(tester, saves: [editable(_tee)]);
    await _tap(tester, find.text('Add product'));

    expect(find.byType(VariantCard), findsOneWidget);
    expect(_inCard(0, find.text('Remove')), findsNothing);
    expect(
      find.text('Save the product first to add codes other shops use.'),
      findsOneWidget,
    );

    await _type(tester, 'Name', 'Hemp Cap');
    await _tap(tester, find.byType(DropdownButtonFormField<ProductCategory>));
    await tester.tap(find.text('Accessories').last);
    await tester.pumpAndSettle();
    await _type(tester, 'Style code', 'CAP');
    await _type(tester, 'Barcode number', '8901234500057', card: 0);
    await _type(tester, 'SKU', 'CAP-S', card: 0);
    await _type(tester, 'Size', 'S', card: 0);

    await _tap(tester, find.text('Add a size or colour'));
    expect(find.byType(VariantCard), findsNWidgets(2));
    expect(find.text('Size or colour 2'), findsOneWidget);
    await _type(tester, 'Barcode number', '08901234500057', card: 1);
    await _type(tester, 'SKU', 'CAP-M', card: 1);
    await _type(tester, 'Colour', 'Olive', card: 1);
    await _tap(tester, find.widgetWithText(FilledButton, 'Add product'));

    // The same digits as size 1: stopped on the phone.
    expect(
      find.text('Another size or colour already uses this barcode.'),
      findsOneWidget,
    );
    expect(repository.saved, isEmpty);

    await _type(tester, 'Barcode number', '8901234500064', card: 1);
    await _tap(tester, find.text('Include carbon and recyclability figures'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Add product'));

    final (id, draft) = repository.saved.single;
    expect(id, isNull);
    expect(draft.category, ProductCategory.accessories);
    expect(draft.styleCode, 'CAP');
    expect(
      [for (final v in draft.variants) (v.gtin, v.sku, v.size, v.colour)],
      [
        ('8901234500057', 'CAP-S', 'S', null),
        ('8901234500064', 'CAP-M', null, 'Olive'),
      ],
    );
  });

  testWidgets('remove a size; the last one cannot be removed', (tester) async {
    final repository = await _openTee(tester, saves: [editable(_tee)]);

    expect(find.byType(VariantCard), findsNWidgets(2));
    expect(find.bySemanticsLabel('Remove size or colour 2'), findsOneWidget);
    await _tap(tester, _inCard(1, find.text('Remove')));

    expect(find.byType(VariantCard), findsOneWidget);
    expect(find.text('Remove'), findsNothing);

    await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));
    final (_, draft) = repository.saved.single;
    expect([for (final v in draft.variants) v.id], ['v1']);
  });

  testWidgets('edit: each size as stored; a code in use lands on its row', (
    tester,
  ) async {
    await _openTee(
      tester,
      saves: [
        const Err(ConflictFailure(['SKU TT-TEE-M is already in use'])),
      ],
    );

    expect(
      tester.widget<TextField>(_field('Style code')).controller?.text,
      'TT-TEE',
    );
    expect(
      tester.widget<TextField>(_field('Colour', card: 1)).controller?.text,
      'Navy',
    );

    await _tap(tester, find.widgetWithText(FilledButton, 'Save changes'));

    expect(
      find.text('Another product already uses this code.'),
      findsOneWidget,
    );
    expect(
      _inCard(1, find.text('SKU TT-TEE-M is already in use')),
      findsOneWidget,
    );
    expect(
      _inCard(0, find.text('SKU TT-TEE-M is already in use')),
      findsNothing,
    );
  });

  testWidgets('other shop codes: add one, remove one, saved at once', (
    tester,
  ) async {
    final repository = await _openTee(
      tester,
      aliasChanges: [const Ok(null), const Ok(null)],
    );

    expect(_inCard(0, find.text('Other shop codes')), findsOneWidget);
    await _tap(tester, _inCard(1, find.text('Other shop codes (1)')));

    expect(
      find.text(
        'Codes other shops use for Size M · Navy, so their orders and '
        'receipts match it.',
      ),
      findsOneWidget,
    );
    expect(find.text('MY-2'), findsOneWidget);

    await _tap(tester, find.widgetWithText(FilledButton, 'Add code'));
    expect(find.text('Enter the shop name'), findsOneWidget);
    expect(repository.aliasesSent, isEmpty);

    await _type(tester, 'Shop', ' Ajio ');
    await _type(tester, 'Their code', 'AJ-77');
    await _tap(tester, find.widgetWithText(FilledButton, 'Add code'));

    expect(find.text('AJ-77'), findsOneWidget);
    await _tap(tester, find.byTooltip('Remove the Myntra code MY-2'));
    expect(find.text('MY-2'), findsNothing);

    expect(repository.aliasesSent, [
      ('add', _id, 'v2', const SkuAlias(source: 'Ajio', code: 'AJ-77')),
      ('remove', _id, 'v2', const SkuAlias(source: 'Myntra', code: 'MY-2')),
    ]);

    await tester.tapAt(const Offset(10, 10)); // close the sheet
    await tester.pumpAndSettle();
    expect(_inCard(1, find.text('Other shop codes (1)')), findsOneWidget);
  });

  testWidgets("a code refused: the API's reason in the sheet", (tester) async {
    await _openTee(
      tester,
      aliasChanges: [
        const Err(ConflictFailure(['Ajio already uses AJ-77'])),
      ],
    );
    await _tap(tester, _inCard(0, find.text('Other shop codes')));
    await _type(tester, 'Shop', 'Ajio');
    await _type(tester, 'Their code', 'AJ-77');
    await _tap(tester, find.widgetWithText(FilledButton, 'Add code'));

    expect(find.text('Ajio already uses AJ-77'), findsOneWidget);
    expect(find.text('No other shop codes yet.'), findsOneWidget);
  });
}
