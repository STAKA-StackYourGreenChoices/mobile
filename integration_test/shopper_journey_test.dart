import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/device.dart';

/// A new shopper's whole journey on a real phone against the real API:
/// sign up, confirm-email banner, scan by typed number, product, add to
/// wardrobe, prove ownership by order (none), wardrobe, change password,
/// sign out, sign in, forgot password.
///
/// Run on a device (see HANDOFF "Phase 5"): `flutter test
/// integration_test/shopper_journey_test.dart -d DEVICE_ID
/// --dart-define-from-file=env/dev.json`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a new shopper, start to finish', (tester) async {
    final email = throwawayEmail();
    final password = randomPassword();
    final newPassword = randomPassword();

    // Sign up.
    await launchSignedOut(tester);
    await tapText(tester, 'Create an account');
    await waitFor(tester, field('Your name'));
    await fill(tester, 'Your name', 'Device Test');
    await fill(tester, 'Email', email);
    await fill(tester, 'Password', password);
    await tapButton(tester, 'Create account');
    await waitFor(tester, find.text('Your wardrobe is empty'));

    // Unconfirmed email: the banner, and a new link.
    await tapText(tester, 'Send a new link');
    await waitFor(tester, find.text("We've sent a new confirmation link."));

    // Scan by typing the number, then the product.
    await tapText(tester, 'Scan your first piece');
    await waitFor(tester, find.text('Scan a product'));
    await tester.enterText(find.byType(EditableText), seededGtin);
    // The keyboard's search key looks it up, as a shopper would press it.
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await waitFor(tester, find.text('Terra Threads'));
    await scrollTo(tester, find.text('About Terra Threads'));
    await scrollTo(tester, find.text('Add to my wardrobe'));

    // Add to wardrobe: the new tag opens.
    await tapText(tester, 'Add to my wardrobe');
    await waitFor(tester, find.text('Organic Cotton Tee is in your wardrobe.'));
    expect(find.text('Prove you own it'), findsOneWidget);

    // No paid order for a new account: says so.
    await tapText(tester, 'Find it in my orders');
    await waitFor(
      tester,
      find.text(
        'No paid order on your account includes this piece. Upload a '
        'receipt instead.',
      ),
    );

    // The wardrobe lists it as waiting for proof.
    await tapText(tester, 'Wardrobe');
    await waitFor(tester, find.text('Waiting for proof (1)'));
    expect(find.text('Organic Cotton Tee'), findsWidgets);

    // Change password: this phone stays signed in.
    await tapText(tester, 'Account');
    await waitFor(tester, find.text(email));
    await tapText(tester, 'Change password');
    await waitFor(tester, field('Current password'));
    await fill(tester, 'Current password', password);
    await fill(tester, 'New password', newPassword);
    await fill(tester, 'Confirm new password', newPassword);
    await tapButton(tester, 'Change password');
    await waitFor(
      tester,
      find.text('Password changed. Other devices will need to sign in again.'),
    );

    // Sign out, then back in with the new password.
    await tapText(tester, 'Sign out');
    await waitFor(tester, find.text('Create an account'));
    await tapText(tester, 'Sign in');
    await waitFor(tester, field('Email'));
    await fill(tester, 'Email', email);
    await fill(tester, 'Password', newPassword);
    await tapButton(tester, 'Sign in');
    await waitFor(tester, find.text('Waiting for proof (1)'));

    // Forgot password: the same answer whoever asks.
    await tapText(tester, 'Account');
    await waitFor(tester, find.text('Sign out'));
    await tapText(tester, 'Sign out');
    await waitFor(tester, find.text('Create an account'));
    await tapText(tester, 'Sign in');
    await waitFor(tester, find.text('Forgot your password?'));
    await tapText(tester, 'Forgot your password?');
    await waitFor(tester, field('Email'));
    await fill(tester, 'Email', email);
    await tapButton(tester, 'Send reset link');
    await waitFor(tester, find.textContaining('a reset link is on its way'));
  });
}
