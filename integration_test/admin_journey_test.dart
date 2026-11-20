import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/config/env.dart';
import 'package:staka/features/admin/brands/presentation/widgets/brand_tile.dart';

import 'helpers/device.dart';

/// The admin side on a real phone against the real API, ending with a
/// shopper sharing the tag the admin just verified:
/// products (search, open), brands (add, edit, delete), import page,
/// claims (review the receipt, approve), then share and stop sharing.
///
/// Only touches what it creates: a throwaway shopper, their claim and a
/// throwaway brand. Needs `LIVE_ADMIN_EMAIL` / `LIVE_ADMIN_PASSWORD`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'admin: catalog, brands, import, approve a receipt; shopper shares',
    (tester) async {
      final stamp = DateTime.now().microsecondsSinceEpoch;
      final shopperName = 'Device Shopper $stamp';
      final shopper = await _shopperWithPendingReceipt(shopperName);
      final brandName = 'Device Brand $stamp';

      // Sign in as the admin.
      await launchSignedOut(tester);
      await tapText(tester, 'Sign in');
      await waitFor(tester, field('Email'));
      await fill(tester, 'Email', adminEmail);
      await fill(tester, 'Password', adminPassword);
      await tapButton(tester, 'Sign in');
      await waitFor(tester, find.text('Admin'));

      // Products: search, open one, back.
      await tapText(tester, 'Admin');
      await waitFor(tester, find.text('Products'));
      await tapText(tester, 'Products');
      await waitFor(tester, find.textContaining('Showing 1–'));
      await tester.enterText(find.byType(TextField), 'Organic Cotton');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await waitFor(tester, find.text('Terra Threads, $seededGtin'));
      await tapText(tester, 'Organic Cotton Tee');
      await waitFor(tester, find.text('Delete product'));
      await tester.pageBack();
      await waitFor(tester, find.text('Terra Threads, $seededGtin'));
      await tester.pageBack();

      // Brands: add, edit, delete a throwaway brand.
      await waitFor(tester, find.text('Brands'));
      await tapText(tester, 'Brands');
      await waitFor(tester, find.text('Terra Threads'));
      await tapOn(tester, find.text('Add brand').first);
      await waitFor(tester, field('Brand name'));
      await fill(tester, 'Brand name', brandName);
      await tapOn(tester, find.widgetWithText(FilledButton, 'Add brand').last);
      await waitFor(tester, find.text('Brand added'));
      await scrollTo(tester, find.text(brandName));

      Finder inTile(String text) => find.descendant(
        of: find.ancestor(
          of: find.text(brandName),
          matching: find.byType(BrandTile),
        ),
        matching: find.text(text),
      );
      await tapOn(tester, inTile('Edit'));
      await waitFor(tester, field('About the brand'));
      await fill(tester, 'About the brand', 'Made on a phone, for a test.');
      await tapButton(tester, 'Save changes');
      await waitFor(tester, find.text('Brand updated'));
      await scrollTo(tester, find.text('Made on a phone, for a test.'));
      await tapOn(tester, inTile('Delete'));
      await waitFor(tester, find.text('Delete brand'));
      await tapText(tester, 'Delete brand');
      await waitFor(tester, find.text('$brandName deleted'));
      await tester.pageBack();

      // Import: the page and what the file needs (picking a file is the
      // phone's own picker, checked by hand).
      await waitFor(tester, find.text('Import'));
      await tapText(tester, 'Import');
      await waitFor(tester, find.text('Up to 2 MB and 5,000 rows.'));
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
      await tapButton(tester, 'Approve');
      await waitFor(
        tester,
        find.text('Approved. The shopper is now the verified owner.'),
      );

      // Sign out; the shopper signs in and shares their verified tag.
      await tapText(tester, 'Account');
      await waitFor(tester, find.text('Sign out'));
      await tapText(tester, 'Sign out');
      await waitFor(tester, find.text('Create an account'));
      await tapText(tester, 'Sign in');
      await waitFor(tester, field('Email'));
      await fill(tester, 'Email', shopper.email);
      await fill(tester, 'Password', shopper.password);
      await tapButton(tester, 'Sign in');
      await waitFor(tester, find.text('Verified (1)'));
      await tapText(tester, 'Organic Cotton Tee');
      await waitFor(tester, find.text("You're the verified owner"));
      await tapText(tester, 'Create share link');
      await waitFor(tester, find.text('Copy link'));
      await tapText(tester, 'Stop sharing');
      await waitFor(tester, find.text('Stop sharing this tag?'));
      await tapOn(tester, find.widgetWithText(FilledButton, 'Stop sharing'));
      await waitFor(tester, find.text('Create share link'));
    },
    skip: adminPassword.isEmpty,
  );
}

typedef _Shopper = ({String email, String password});

/// Registers a shopper, adds the seeded product and sends a receipt photo,
/// straight through the API (the app part is the admin's).
Future<_Shopper> _shopperWithPendingReceipt(String name) async {
  final dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
  final email = throwawayEmail();
  final password = randomPassword();
  final tokens = await dio.post<Map<String, dynamic>>(
    '/auth/register',
    data: {'name': name, 'email': email, 'password': password},
  );
  dio.options.headers['authorization'] =
      'Bearer ${tokens.data!['accessToken']}';
  final card = await dio.post<Map<String, dynamic>>(
    '/digital-cards',
    data: {'gtin': seededGtin},
  );
  await dio.post<Object?>(
    '/digital-cards/${card.data!['id']}/ownership/receipt',
    data: FormData.fromMap({
      'file': MultipartFile.fromBytes(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk'
          'YPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
        ),
        filename: 'receipt.png',
        contentType: DioMediaType('image', 'png'),
      ),
    }),
  );
  return (email: email, password: password);
}
