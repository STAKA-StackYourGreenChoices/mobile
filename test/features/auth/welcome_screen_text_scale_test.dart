import 'package:flutter_test/flutter_test.dart';
import 'package:staka/features/auth/presentation/screens/welcome_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('welcome screen survives 200% text on a 360 dp phone', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await pumpThemed(tester, const WelcomeScreen(), textScale: 2);
    expect(tester.takeException(), isNull);
  });
}
