@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';
import 'package:staka/features/auth/domain/models/otp_verification.dart';
import 'package:staka/features/auth/presentation/screens/otp_code_screen.dart';
import 'package:staka/features/auth/presentation/screens/otp_name_screen.dart';
import 'package:staka/features/auth/presentation/screens/phone_sign_in_screen.dart';
import 'package:staka/features/auth/presentation/state/otp_request_controller.dart';
import 'package:staka/features/auth/presentation/state/otp_verify_controller.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/pump_full_app.dart';

final _now = DateTime.utc(2026, 11, 23, 10);

const _challenge = OtpChallenge(
  id: 'c1',
  phone: '+919876543210',
  expiresIn: Duration(minutes: 5),
  resendIn: Duration(seconds: 30),
);

/// Pumps [screen], then (for the code and name steps) sends a code, and
/// for the name step answers it with "name required", as the app would.
Future<void> _pumpStep(
  WidgetTester tester,
  Widget screen, {
  required Brightness brightness,
  bool sendCode = false,
  bool needsName = false,
}) async {
  await pumpThemed(
    tester,
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(() => _now),
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            [],
            codes: [const Ok(_challenge)],
            checks: [const Ok(OtpNameRequired())],
          ),
        ),
      ],
      child: screen,
    ),
    brightness: brightness,
  );
  final container = ProviderScope.containerOf(
    tester.element(find.byWidget(screen)),
  );
  if (sendCode) {
    await container
        .read(otpRequestControllerProvider.notifier)
        .send(_challenge.phone);
  }
  if (needsName) {
    await container
        .read(otpVerifyControllerProvider.notifier)
        .verify(challengeId: _challenge.id, code: '123456');
  }
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets('phone screen, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 760);
      await _pumpStep(
        tester,
        const PhoneSignInScreen(),
        brightness: brightness,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/phone_${brightness.name}.png'),
      );
    });

    testWidgets('code screen, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 760);
      await _pumpStep(
        tester,
        const OtpCodeScreen(),
        brightness: brightness,
        sendCode: true,
      );
      await tester.enterText(find.byType(EditableText), '1234');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/otp_code_${brightness.name}.png'),
      );
    });

    testWidgets('name screen, ${brightness.name}', (tester) async {
      usePhoneScreen(tester, height: 760);
      await _pumpStep(
        tester,
        const OtpNameScreen(),
        brightness: brightness,
        sendCode: true,
        needsName: true,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/otp_name_${brightness.name}.png'),
      );
    });
  }
}
