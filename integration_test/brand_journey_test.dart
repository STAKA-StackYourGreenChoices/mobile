import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/device.dart';

/// A brand reviewer on a real phone against the V2 API (V2-12, V2-8,
/// V2-6): a throwaway shopper sends a receipt for the seeded tee through
/// the API; a Terra Threads team member signs in, finds it on the Brand
/// tab, opens it (receipt, Automatic check) and approves it; then the
/// shopper signs in, reads who approved it, and sees the points for it.
///
/// Only touches what it creates: a throwaway shopper and their claim.
/// Needs `LIVE_BRAND_EMAIL` / `LIVE_BRAND_PASSWORD` (a member of Terra
/// Threads in the API's V2 seed). Run like the other journeys (see
/// HANDOFF "Device journeys").
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'brand: approve a receipt; the shopper sees who did and the points',
    (tester) async {
      final stamp = DateTime.now().microsecondsSinceEpoch;
      final shopperName = 'Device Shopper $stamp';
      final shopper = await shopperWithPendingReceipt(shopperName);

      // Sign in as the brand's team member; the Brand tab shows.
      await launchSignedOut(tester);
      await signInWithEmail(tester, brandEmail, brandPassword);
      await waitFor(tester, navTab('Brand'));
      await tapOn(tester, navTab('Brand'));

      // Claims: this run's receipt is in the brand's own queue.
      await waitFor(tester, find.text('Claims'));
      await tapText(tester, 'Claims');
      await waitFor(
        tester,
        find.textContaining('Shoppers who bought your products'),
      );
      final row = find.text('$shopperName (${shopper.email})');
      await scrollTo(tester, row);
      await tapOn(tester, row);
      await waitFor(tester, find.text('$shopperName: Organic Cotton Tee'));
      await waitFor(tester, find.text('Tap the image to open it full size.'));
      // V2-8: the API's reading of the receipt (done, pending or failed).
      await scrollTo(tester, find.text('Automatic check'));

      // Approve; back on the brand's queue.
      await tapOn(tester, find.widgetWithText(FilledButton, 'Approve'));
      await waitFor(
        tester,
        find.text('Approved. The shopper is now the verified owner.'),
      );
      await waitFor(
        tester,
        find.textContaining('Shoppers who bought your products'),
      );

      // The shopper: who approved it, and the points for it.
      await signOut(tester);
      await signInWithEmail(tester, shopper.email, shopper.password);
      await waitFor(tester, find.text('Verified (1)'));
      await tapText(tester, 'Organic Cotton Tee');
      await waitFor(
        tester,
        find.textContaining('Terra Threads approved your receipt'),
      );
      await tester.pageBack();
      await tapOn(tester, navTab('Rewards'));
      await waitFor(tester, find.text('Your points'));
      await tapText(tester, 'See your points history');
      await waitFor(tester, find.text('Organic Cotton Tee was verified'));
    },
    skip: brandPassword.isEmpty,
  );
}
