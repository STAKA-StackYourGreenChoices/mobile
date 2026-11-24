@Tags(['golden'])
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/presentation/screens/tag_screen.dart';

import '../../helpers/golden.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/tag_fakes.dart';
import '../../helpers/wardrobe_fakes.dart';

Widget _tag(Ownership ownership, {bool isJustAdded = false}) => ProviderScope(
  overrides: [
    tagRepositoryProvider.overrideWithValue(
      FakeTagRepository(
        cards: [
          cardFor(id: 'c1', name: 'Organic Cotton Tee', ownership: ownership),
        ],
      ),
    ),
  ],
  child: TagScreen(cardId: 'c1', isJustAdded: isJustAdded),
);

void main() {
  setUpAll(loadAppFonts);

  final cases = {
    'prove': (
      _tag(
        const Ownership(
          status: OwnershipStatus.unverified,
          receiptAttemptsUsed: 0,
          receiptAttemptsLeft: 5,
        ),
        isJustAdded: true,
      ),
      2300.0,
    ),
    'pending': (
      _tag(
        Ownership(
          status: OwnershipStatus.pending,
          receiptAttemptsUsed: 1,
          receiptAttemptsLeft: 4,
          pendingSince: DateTime(2026, 11, 14, 12),
        ),
      ),
      1700.0,
    ),
    'brand_rejected': (
      _tag(
        const Ownership(
          status: OwnershipStatus.rejected,
          receiptAttemptsUsed: 1,
          receiptAttemptsLeft: 4,
          method: ClaimMethod.receipt,
          lastRejectionReason: 'The shop name is cut off',
          decidedBy: ClaimDecider.brand,
          brandName: 'Terra Threads',
        ),
      ),
      2300.0,
    ),
    'look_again_open': (
      _tag(
        const Ownership(
          status: OwnershipStatus.blocked,
          receiptAttemptsUsed: 5,
          receiptAttemptsLeft: 0,
          method: ClaimMethod.receipt,
          lastRejectionReason: 'The shop name is cut off',
          decidedBy: ClaimDecider.brand,
          brandName: 'Terra Threads',
          dispute: OwnershipDispute(status: DisputeStatus.open),
        ),
      ),
      1900.0,
    ),
  };

  for (final MapEntry(key: name, value: (screen, height)) in cases.entries) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'tag $name, ${brightness.name}',
        (tester) => withRealShadows(() async {
          usePhoneScreen(tester, height: height);
          await pumpThemed(tester, screen, brightness: brightness);
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/tag_${name}_${brightness.name}.png'),
          );
        }),
      );
    }
  }
}
