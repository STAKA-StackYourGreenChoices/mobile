import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/shared/widgets/inputs/app_otp_field.dart';

import 'helpers/device.dart';

/// A phone-only shopper on a real phone against the V2 API (V2-1, V2-10):
/// sign up with a number, name, the wardrobe, Account's sign-in methods,
/// then delete the account with a texted code, back on the welcome screen.
///
/// Needs a person: the API's console SMS driver prints each code in the
/// API terminal (no real SMS yet). Type it on the phone when the code
/// screen shows; the test waits up to 3 minutes each time.
/// Needs `LIVE_TEST_PHONE`: a 10-digit mobile number on no account. Never
/// run this against an API that sends real SMS.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const forPerson = Duration(minutes: 3);

  testWidgets('a phone-only shopper signs up, then deletes the account', (
    tester,
  ) async {
    // Number, code (typed by the person), name.
    await launchSignedOut(tester);
    await tapText(tester, 'Continue with phone number');
    await waitFor(tester, field('Mobile number'));
    await fill(tester, 'Mobile number', testPhone);
    await tapButton(tester, 'Send code');
    await waitFor(tester, find.text('Enter the code'));
    // Six digits submit on their own.
    await waitFor(
      tester,
      find.text('What should we call you?'),
      timeout: forPerson,
    );
    await tester.enterText(find.byType(EditableText), 'Device Phone');
    await tapButton(tester, 'Create account');
    await waitFor(tester, find.text('Welcome, Device'));
    expect(find.text('Your wardrobe is empty'), findsOneWidget);

    // Account: signed in by phone, no email or password yet.
    await tapOn(tester, navTab('Account'));
    await waitFor(tester, find.text('How you sign in'));
    await scrollTo(tester, find.text('Your data'));

    // Delete with a texted code (typed by the person), then the button.
    await tapText(tester, 'Delete my account');
    await waitFor(tester, find.textContaining("We'll text a code to"));
    await tapButton(tester, 'Send code');
    await _waitForTypedCode(tester, forPerson);
    await tapButton(tester, 'Delete my account');
    await waitFor(tester, find.text('Your account has been deleted.'));
    expect(find.text('Continue with phone number'), findsOneWidget);
  }, skip: testPhone.isEmpty);
}

/// Waits until the person has typed all six digits into the code field
/// (here six digits alone don't delete anything; the button does).
Future<void> _waitForTypedCode(WidgetTester tester, Duration timeout) async {
  final code = find.descendant(
    of: find.byType(AppOtpField),
    matching: find.byType(EditableText),
  );
  await waitFor(tester, code);
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 300));
    if (tester.widget<EditableText>(code).controller.text.length == 6) {
      await closeKeyboard(tester);
      return;
    }
  }
  throw TestFailure('No code typed within $timeout.');
}
