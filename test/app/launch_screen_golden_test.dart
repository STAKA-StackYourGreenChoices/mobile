@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/app/launch/launch_screen.dart';

import '../helpers/golden.dart';
import '../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  // Carries on from the Android splash: the same green and mark in light
  // and dark mode (the spinner is stopped for the snapshot).
  for (final brightness in Brightness.values) {
    testWidgets('launch screen, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 800);
      await pumpThemed(
        tester,
        const TickerMode(enabled: false, child: LaunchScreen()),
        brightness: brightness,
      );
      await tester.pump();

      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/launch_screen_${brightness.name}.png'),
      );
    });
  }
}
