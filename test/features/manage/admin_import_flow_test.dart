import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';
import '../../helpers/import_fakes.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

const _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

/// Signs in as Terra Threads' owner and opens Brand → Import on a
/// 360 × 800 phone (V2-12: brands import their own catalog).
Future<void> _openImport(
  WidgetTester tester, {
  FakeImportRepository? repository,
  FakeImportFileActions? actions,
  FakeAdminProductRepository? products,
}) async {
  usePhoneScreen(tester, height: 800);
  await pumpApp(
    tester,
    tokens: _tokens,
    replies: [
      json(200, memberUserJson([membershipJson()])),
    ],
    importRepository: repository,
    importFileActions: actions,
    adminProducts: products,
  );
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Brand'),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Import'));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

final Finder _checkButton = find.widgetWithText(FilledButton, 'Check file');

void main() {
  testWidgets('check, review, import: the website three steps', (tester) async {
    final repository = FakeImportRepository(
      checks: [Ok(importReport())],
      imports: [Ok(importReport(isDryRun: false))],
    );
    final products = FakeAdminProductRepository();
    await _openImport(
      tester,
      repository: repository,
      actions: FakeImportFileActions(picks: [csvFile('catalog.csv')]),
      products: products,
    );

    expect(find.text('Import products'), findsOneWidget);
    expect(find.text('Up to 2 MB and 5,000 rows.'), findsOneWidget);
    expect(tester.widget<FilledButton>(_checkButton).onPressed, isNull);

    await _tap(tester, find.text('Choose a CSV file'));
    expect(find.text('catalog.csv'), findsOneWidget);
    expect(
      find.text('0.0 KB. Choose another file to replace it.'),
      findsOneWidget,
    );

    await _tap(tester, _checkButton);
    expect(repository.checked, ['catalog.csv']);
    expect(find.text('Ready to import 3 products'), findsOneWidget);
    expect(
      find.text('Checked 4 rows in catalog.csv. Nothing has been saved yet.'),
      findsOneWidget,
    );
    expect(find.text('New brands: Hemp House'), findsOneWidget);
    expect(find.text('1 row will be skipped'), findsOneWidget);
    expect(find.text('Missing'), findsOneWidget); // its barcode
    expect(find.text('gtin is required'), findsOneWidget);

    await _tap(tester, find.text('Import 3 products'));
    expect(repository.imported, ['catalog.csv']);
    expect(find.text('Imported 3 products'), findsOneWidget);
    expect(
      find.text(
        '2 new products added, 1 product updated, 1 new brand created. '
        '1 row with problems was skipped.',
      ),
      findsOneWidget,
    );

    await _tap(tester, find.text('View products'));
    expect(find.text('No products yet'), findsOneWidget);
  });

  testWidgets('files the website would refuse are refused before sending', (
    tester,
  ) async {
    final repository = FakeImportRepository();
    await _openImport(
      tester,
      repository: repository,
      actions: FakeImportFileActions(
        picks: [
          csvFile('catalog.xlsx'),
          csvFile('big.csv', size: PickedCsv.maxBytes + 1),
          csvFile('empty.csv', text: ''),
        ],
      ),
    );

    await _tap(tester, find.text('Choose a CSV file'));
    await _tap(tester, _checkButton);
    expect(
      find.text(
        "catalog.xlsx isn't a CSV file. Save the sheet as .csv and try again.",
      ),
      findsOneWidget,
    );

    await _tap(tester, find.text('catalog.xlsx'));
    await _tap(tester, _checkButton);
    expect(
      find.text('The file is larger than 2 MB. Split it into smaller files.'),
      findsOneWidget,
    );

    await _tap(tester, find.text('big.csv'));
    await _tap(tester, _checkButton);
    expect(find.text('Choose a CSV file to import.'), findsOneWidget);
    expect(repository.checked, isEmpty);
  });

  testWidgets('nothing importable: no import button, choose another', (
    tester,
  ) async {
    await _openImport(
      tester,
      repository: FakeImportRepository(
        checks: [
          Ok(
            importReport(
              totalRows: 1,
              created: 0,
              updated: 0,
              brandsCreated: const [],
            ),
          ),
        ],
      ),
      actions: FakeImportFileActions(picks: [csvFile('bad.csv')]),
    );

    await _tap(tester, find.text('Choose a CSV file'));
    await _tap(tester, _checkButton);

    expect(find.text('Nothing in this file can be imported'), findsOneWidget);
    expect(find.textContaining(RegExp(r'^Import \d')), findsNothing);
    await _tap(tester, find.text('Choose a different file'));
    expect(find.text('Choose a CSV file'), findsOneWidget);
  });

  testWidgets('the API refuses the file: its reason above the step', (
    tester,
  ) async {
    const reason = 'The CSV has 6000 rows; the limit is 5000 per upload';
    await _openImport(
      tester,
      repository: FakeImportRepository(
        checks: [
          const Err(BadRequestFailure(400, [reason])),
        ],
      ),
      actions: FakeImportFileActions(picks: [csvFile('huge.csv')]),
    );

    await _tap(tester, find.text('Choose a CSV file'));
    await _tap(tester, _checkButton);

    expect(find.text(reason), findsOneWidget);
    expect(find.text('huge.csv'), findsOneWidget); // still chosen
  });

  testWidgets('the template goes to the share sheet', (tester) async {
    final actions = FakeImportFileActions();
    await _openImport(tester, actions: actions);

    await _tap(tester, find.text('Download the template'));

    expect(actions.sharedTemplates, hasLength(1));
  });

  testWidgets('no template: the website message', (tester) async {
    await _openImport(
      tester,
      repository: FakeImportRepository(
        template: const Err(ServerFailure(500, [])),
      ),
    );

    await _tap(tester, find.text('Download the template'));

    expect(
      find.text(
        "The template isn't available right now. Try again in a moment.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('what the file needs opens on tap', (tester) async {
    await _openImport(tester);

    await _tap(tester, find.text('What the file needs'));

    expect(
      find.textContaining(
        'Required columns: gtin, sku, name, brandName',
        findRichText: true,
      ),
      findsOneWidget,
    );
    // V2-2: the variant columns.
    expect(
      find.textContaining('Rows with the same style_code become sizes'),
      findsOneWidget,
    );
    expect(find.textContaining('category is one of TOPS'), findsOneWidget);
    expect(
      find.text("Brands that don't exist yet are created for you."),
      findsOneWidget,
    );
  });
}
