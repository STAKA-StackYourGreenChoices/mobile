@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/claims/presentation/screens/admin_claim_screen.dart';
import 'package:staka/features/manage/claims/presentation/screens/admin_claims_screen.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/admin_claim_fakes.dart';
import '../../helpers/golden.dart';
import '../../helpers/product_fakes.dart';
import '../../helpers/pump_app.dart';

void main() {
  setUpAll(loadAppFonts);

  final pending = claimFor(1);
  final rejectedEarlier = claimFor(
    2,
    status: ClaimStatus.rejected,
    receiptAttempt: 1,
    rejectionReason: 'The receipt is too blurry to read',
  );
  final approved = claimFor(3, status: ClaimStatus.approved);
  final repository = FakeAdminClaimRepository(
    pages: (_) => Ok(
      ClaimPage(
        items: [
          pending,
          claimFor(
            4,
            method: ClaimMethod.orderMatch,
            productName: 'Recycled Denim Jeans',
          ),
        ],
        total: 2,
      ),
    ),
    details: {
      pending.id: detailOf(pending),
      approved.id: detailOf(approved, history: [rejectedEarlier, approved]),
    },
    receipts: {
      pending.id: Ok(ClaimReceipt(bytes: onePixelPng, mimeType: 'image/png')),
    },
    products: {'p1': Ok(productNamed('Organic Cotton Tee'))},
  );

  final cases = <String, (Widget, double, bool)>{
    'list': (const AdminClaimsScreen(scope: AdminScope()), 760, false),
    'review_reject': (
      AdminClaimScreen(scope: const AdminScope(), claimId: pending.id),
      1700,
      true,
    ),
    'decided': (
      AdminClaimScreen(scope: const AdminScope(), claimId: approved.id),
      1500,
      false,
    ),
  };

  for (final MapEntry(key: name, value: (screen, height, openReject))
      in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'claims $name, ${brightness.name}',
        (tester) => withRealShadows(() async {
          usePhoneScreen(tester, height: height);
          await pumpThemed(
            tester,
            ProviderScope(
              overrides: [
                adminClaimRepositoryProvider.overrideWith((_, _) => repository),
              ],
              child: screen,
            ),
            brightness: brightness,
          );
          await tester.pumpAndSettle();
          if (openReject) {
            await tester.tap(find.text('Reject'));
            await tester.pumpAndSettle();
          }
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/claims_${name}_${brightness.name}.png'),
          );
        }),
      );
    }
  }
}
