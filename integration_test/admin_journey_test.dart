import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/device.dart';

/// The admin side on a real phone against the real API, ending with a
/// shopper sharing the tag the admin just verified:
/// products (search, open the hide dialog, cancel), the brands and
/// disputes pages, claims (review the receipt, overrule: approve instead),
/// rewards, reward rules and users (find this run's shopper and their
/// points), then share and stop sharing. Needs the V2 API
/// (`/admin/brand-applications`, `/admin/disputes`,
/// `/admin/claims/:id/override`, `/admin/rewards`, `/admin/reward-rules`,
/// `/admin/users`).
///
/// Only touches what it creates: a throwaway shopper and their claim.
/// Nothing is switched off, edited or adjusted. Needs `LIVE_ADMIN_EMAIL` /
/// `LIVE_ADMIN_PASSWORD`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('admin: catalog, brands, disputes, overrule, rewards, users; '
      'shopper shares', (tester) async {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final shopperName = 'Device Shopper $stamp';
    final shopper = await shopperWithPendingReceipt(shopperName);

    // Sign in as the admin.
    await launchSignedOut(tester);
    await signInWithEmail(tester, adminEmail, adminPassword);
    await waitFor(tester, navTab('Admin'));

    // Products: search, open one, back.
    await tapOn(tester, navTab('Admin'));
    await waitFor(tester, find.text('Products'));
    await tapText(tester, 'Products');
    await waitFor(tester, find.textContaining('Showing 1–'));
    await tester.enterText(find.byType(TextField), 'Organic Cotton');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await waitFor(tester, find.text('Terra Threads, $seededGtin'));
    // Admins don't edit products; a tap offers to hide it. Cancel.
    await tapText(tester, 'Organic Cotton Tee');
    await waitFor(tester, find.text('Hide Organic Cotton Tee?'));
    await tapText(tester, 'Cancel');
    await waitFor(tester, find.text('Terra Threads, $seededGtin'));
    await tester.pageBack();

    // Brands and disputes: the pages load (deciding is left to fakes).
    await waitFor(tester, find.text('Brands'));
    await tapText(tester, 'Brands');
    await waitFor(tester, find.text('To review'));
    await tester.pageBack();
    await waitFor(tester, find.text('Disputes'));
    await tapText(tester, 'Disputes');
    await waitFor(tester, find.text('To decide'));
    await tester.pageBack();

    // Claims: find this run's receipt, look at it, approve it.
    await waitFor(tester, find.text('Claims'));
    await tapText(tester, 'Claims');
    await waitFor(tester, find.text('Ownership claims'));
    final row = find.text('$shopperName (${shopper.email})');
    await scrollTo(tester, row);
    await tapOn(tester, row);
    await waitFor(tester, find.text('$shopperName: Organic Cotton Tee'));
    await waitFor(tester, find.text('Tap the image to open it full size.'));
    await tapText(tester, 'Approve instead');
    await waitFor(tester, find.text('Approve this claim?'));
    await tester.enterText(
      find.byType(EditableText).last,
      'Checked on a phone, for a test.',
    );
    await tapOn(tester, find.widgetWithText(FilledButton, 'Approve').last);
    await waitFor(
      tester,
      find.text('Approved. The shopper is now the verified owner.'),
    );
    await waitFor(tester, find.text('Ownership claims'));
    await tester.pageBack();

    // Rewards and reward rules: the pages load (nothing is changed). The
    // tiles are found by their line, as "Rewards" is also a tab.
    const rewardsTile = "See every brand's rewards and switch one off.";
    await waitFor(tester, find.text(rewardsTile));
    await tapText(tester, rewardsTile);
    await waitFor(tester, find.textContaining("Every brand's rewards."));
    await tester.pageBack();
    const rulesTile = 'Points for each action and daily limits.';
    await waitFor(tester, find.text(rulesTile));
    await tapText(tester, rulesTile);
    await waitFor(tester, find.textContaining('How many points each'));
    await tester.pageBack();

    // Users: find this run's shopper and open their points.
    const usersTile = 'Find a shopper to see and adjust their points.';
    await waitFor(tester, find.text(usersTile));
    await tapText(tester, usersTile);
    await waitFor(tester, find.text('Find a shopper'));
    await tester.enterText(find.byType(TextField), shopper.email);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await waitFor(tester, find.text(shopperName));
    await tapText(tester, shopperName);
    await waitFor(tester, find.text('Points balance'));
    await waitFor(tester, find.text('Latest points'));
    await tester.pageBack();
    await tester.pageBack();

    // Sign out; the shopper signs in and shares their verified tag.
    await signOut(tester);
    await signInWithEmail(tester, shopper.email, shopper.password);
    await waitFor(tester, find.text('Verified (1)'));
    await tapText(tester, 'Organic Cotton Tee');
    await waitFor(tester, find.text("You're the verified owner"));
    await tapText(tester, 'Create share link');
    await waitFor(tester, find.text('Copy link'));
    await tapText(tester, 'Stop sharing');
    await waitFor(tester, find.text('Stop sharing this tag?'));
    await tapOn(tester, find.widgetWithText(FilledButton, 'Stop sharing'));
    await waitFor(tester, find.text('Create share link'));
  }, skip: adminPassword.isEmpty);
}
