import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/features/manage/claims/presentation/widgets/claim_row.dart';
import 'package:staka/features/products/presentation/widgets/ownership_action.dart';
import 'package:staka/features/rewards/presentation/widgets/points_widgets.dart';
import 'package:staka/shared/widgets/data_display/points_entry_row.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/points_fakes.dart';
import '../../helpers/pump_app.dart';

/// Rows and blocks that overflowed at 200% text on a 360 dp phone before
/// the 2026-11-27 sweep: a trailing amount or date that couldn't shrink, a
/// label that couldn't wrap, a message in a box that couldn't scroll.
void main() {
  Future<void> pumpLarge(WidgetTester tester, Widget child) async {
    usePhoneScreen(tester, height: 2000);
    await pumpThemed(
      tester,
      SingleChildScrollView(padding: AppSpacing.screenH, child: child),
      textScale: 2,
    );
  }

  testWidgets('points rows: the amount wraps instead of overflowing', (
    tester,
  ) async {
    await pumpLarge(
      tester,
      Column(
        children: [
          for (final entry in sampleEntries) PointsEntryRow(entry: entry),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('how to earn: the points wrap instead of overflowing', (
    tester,
  ) async {
    await pumpLarge(tester, const EarnRulesCard(rules: sampleRules));
    expect(tester.takeException(), isNull);
  });

  testWidgets('claim row: the date wraps instead of overflowing', (
    tester,
  ) async {
    await pumpLarge(
      tester,
      ClaimRow(
        claim: claimFor(1, score: 82, isDuplicate: true),
        onPressed: () {},
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('product already in the wardrobe: the label wraps', (
    tester,
  ) async {
    await pumpLarge(
      tester,
      OwnershipAction(onViewTagPressed: () {}, onAddPressed: () {}),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('an error in a short box scrolls instead of overflowing', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await pumpThemed(
      tester,
      SizedBox(
        height: 200,
        child: AppErrorState(
          failure: const NetworkFailure(),
          onRetryPressed: () {},
        ),
      ),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });
}
