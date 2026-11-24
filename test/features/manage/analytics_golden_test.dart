@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/features/manage/analytics/domain/analytics_report.dart';
import 'package:staka/features/manage/analytics/presentation/analytics_controller.dart';
import 'package:staka/features/manage/analytics/presentation/analytics_screen.dart';

import '../../helpers/analytics_fakes.dart';
import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets(
      'analytics, ${brightness.name}',
      (tester) => withRealShadows(() async {
        usePhoneScreen(tester, height: 1500);
        await pumpThemed(
          tester,
          Padding(
            padding: AppSpacing.screenH,
            child: AnalyticsView(
              state: const AnalyticsState(body: AnalyticsLoaded(sampleReport)),
              description:
                  'How shoppers move from a scan to a shared tag, across '
                  'every brand.',
              brandLabel: 'All brands',
              onBrandPressed: () {},
              showBrands: true,
              onPeriodSelected: (_) {},
              onRefresh: () async {},
              onRetry: () {},
            ),
          ),
          brightness: brightness,
        );
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/analytics_${brightness.name}.png'),
        );
      }),
    );
  }

  test('the period chips cover 7, 30 and 90 days', () {
    expect(AnalyticsPeriod.values.map((p) => p.days), [7, 30, 90]);
  });
}
