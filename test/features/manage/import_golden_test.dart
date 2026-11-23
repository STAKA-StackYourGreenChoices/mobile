@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/import/data/repositories/import_repository_impl.dart';
import 'package:staka/features/manage/import/domain/models/import_report.dart';
import 'package:staka/features/manage/import/presentation/screens/admin_import_screen.dart';
import 'package:staka/features/manage/import/presentation/state/import_file_actions.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/golden.dart';
import '../../helpers/import_fakes.dart';
import '../../helpers/pump_app.dart';

/// How far into the flow to go before the snapshot.
enum _Step { choose, review, done }

Future<void> _goTo(WidgetTester tester, _Step step) async {
  Future<void> tap(String text) async {
    await tester.ensureVisible(find.text(text).first);
    await tester.tap(find.text(text).first);
    await tester.pumpAndSettle();
  }

  if (step == _Step.choose) return;
  await tap('Choose a CSV file');
  await tap('Check file');
  if (step == _Step.done) await tap('Import 3 products');
  // Back to the top for the snapshot.
  await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 4000));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  final report = importReport(
    errors: const [
      ImportRowError(row: 5, messages: ['gtin is required']),
      ImportRowError(
        row: 9,
        gtin: '8901234500018',
        messages: ['Invalid check digit (expected 9)'],
      ),
    ],
  );

  for (final step in _Step.values) {
    for (final brightness in Brightness.values) {
      testWidgets('import ${step.name}, ${brightness.name}', (tester) async {
        usePhoneScreen(tester, height: step == _Step.review ? 1500 : 1000);
        await pumpThemed(
          tester,
          ProviderScope(
            overrides: [
              importRepositoryProvider.overrideWith(
                (_, _) => FakeImportRepository(
                  checks: [Ok(report)],
                  imports: [Ok(report)],
                ),
              ),
              importFileActionsProvider.overrideWithValue(
                FakeImportFileActions(
                  picks: [csvFile('catalog.csv', size: 18 * 1024)],
                ),
              ),
            ],
            child: const AdminImportScreen(scope: AdminScope()),
          ),
          brightness: brightness,
        );
        await tester.pumpAndSettle();
        await _goTo(tester, step);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/import_${step.name}_${brightness.name}.png',
          ),
        );
      });
    }
  }
}
