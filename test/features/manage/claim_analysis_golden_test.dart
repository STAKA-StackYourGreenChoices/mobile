@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/widgets/automatic_check_card.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets(
      'automatic check, ${brightness.name}',
      (tester) => withRealShadows(() async {
        usePhoneScreen(tester, height: 1040);
        await pumpThemed(
          tester,
          SingleChildScrollView(
            padding: AppSpacing.screenH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                AutomaticCheckCard(
                  analysis: sampleAnalysis,
                  onEarlierClaimPressed: (_) {},
                ),
                const AutomaticCheckCard(
                  analysis: ReceiptAnalysis(status: AnalysisStatus.pending),
                ),
                const AutomaticCheckCard(
                  analysis: ReceiptAnalysis(status: AnalysisStatus.failed),
                ),
              ],
            ),
          ),
          brightness: brightness,
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/automatic_check_${brightness.name}.png'),
        );
      }),
    );
  }
}
