@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/features/auth/presentation/screens/welcome_screen.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('welcome screen, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 1180);
      await pumpThemed(tester, const WelcomeScreen(), brightness: brightness);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/welcome_${brightness.name}.png'),
      );
    });
  }
}
