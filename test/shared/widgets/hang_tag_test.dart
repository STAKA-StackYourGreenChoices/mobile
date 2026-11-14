import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/ownership_chip.dart';

import '../../helpers/pump_app.dart';

const _verified = SustainabilityInfo(
  carbonScoreGrams: 2100,
  recyclabilityPercent: 80,
  isVerified: true,
  certifierName: 'Global Organic Textile Standard',
);

HangTag _tag({
  SustainabilityInfo? info = _verified,
  String? owner,
  bool isOwnerVerified = false,
  HangTagSize size = HangTagSize.md,
  bool hasSwing = false,
}) => HangTag(
  productName: 'Organic Cotton Tee',
  brandName: 'Terra Threads',
  sustainability: info,
  gtin: '08901234500019',
  ownerName: owner,
  isOwnerVerified: isOwnerVerified,
  size: size,
  hasSwing: hasSwing,
);

void main() {
  testWidgets('verified figures name their certifier', (tester) async {
    usePhoneScreen(tester, height: 1000);
    await pumpThemed(tester, Center(child: _tag()));

    expect(find.text('2.1'), findsNothing); // value and unit are one line
    expect(find.textContaining('2.1'), findsOneWidget);
    expect(
      find.text('Verified by Global Organic Textile Standard'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
    expect(find.text('Barcode 8901234500019'), findsOneWidget);
    expect(find.text('No photo yet'), findsOneWidget);
  });

  testWidgets('brand-stated figures look different: other icon and words', (
    tester,
  ) async {
    await pumpThemed(
      tester,
      Center(child: _tag(info: _verified.copyWith(isVerified: false))),
    );

    expect(find.text('Figures stated by the brand'), findsOneWidget);
    expect(find.byIcon(Icons.verified_rounded), findsNothing);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });

  testWidgets('no figures says so', (tester) async {
    usePhoneScreen(tester, height: 1000);
    await pumpThemed(tester, Center(child: _tag(info: null)));

    expect(find.text('No sustainability figures yet'), findsOneWidget);
    expect(find.text('Footprint'), findsNothing);
  });

  testWidgets('screen readers hear the tag and a verified owner', (
    tester,
  ) async {
    usePhoneScreen(tester, height: 1000);
    final handle = tester.ensureSemantics();
    await pumpThemed(
      tester,
      Center(child: _tag(owner: 'Ada', isOwnerVerified: true)),
    );

    expect(
      find.bySemanticsLabel(
        'Digital tag for Organic Cotton Tee by Terra Threads',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Kept by Ada, verified owner'),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('swings once, then rests upright', (tester) async {
    usePhoneScreen(tester, height: 1000);
    await pumpThemed(tester, Center(child: _tag(hasSwing: true)));
    await tester.pump(const Duration(milliseconds: 100));
    final early = tester.widget<Transform>(
      find
          .descendant(of: find.byType(Center), matching: find.byType(Transform))
          .first,
    );
    expect(early.transform.storage[1], isNot(0)); // rotated

    await tester.pumpAndSettle();
    final rest = tester.widget<Transform>(
      find
          .descendant(of: find.byType(Center), matching: find.byType(Transform))
          .first,
    );
    expect(rest.transform.storage[1], closeTo(0, 1e-9));
  });

  testWidgets('reduce motion: fades in instead of swinging', (tester) async {
    usePhoneScreen(tester, height: 1000);
    await pumpThemed(
      tester,
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Center(child: _tag(hasSwing: true)),
      ),
    );

    expect(find.byType(FadeTransition), findsWidgets);
    await tester.pumpAndSettle();
    expect(find.text('Organic Cotton Tee'), findsOneWidget);
  });

  testWidgets('a small tag survives 200% text on a 360 dp phone', (
    tester,
  ) async {
    usePhoneScreen(tester, height: 1600);
    await pumpThemed(
      tester,
      SingleChildScrollView(
        child: Center(
          child: _tag(size: HangTagSize.sm, owner: 'Ada Lovelace'),
        ),
      ),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('ownership chip: icon and the website label for each status', (
    tester,
  ) async {
    const labels = {
      OwnershipStatus.verified: 'Verified owner',
      OwnershipStatus.pending: 'Receipt under review',
      OwnershipStatus.rejected: 'Receipt turned down',
      OwnershipStatus.blocked: "Can't be verified",
      OwnershipStatus.unverified: 'Not verified yet',
    };
    await pumpThemed(
      tester,
      Column(
        children: [
          for (final status in OwnershipStatus.values)
            OwnershipChip(status: status),
        ],
      ),
    );

    for (final label in labels.values) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.byType(Icon), findsNWidgets(labels.length));
  });
}
