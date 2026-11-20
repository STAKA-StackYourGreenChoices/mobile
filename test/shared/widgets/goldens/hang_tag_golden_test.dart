@Tags(['golden'])
library;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/ownership_chip.dart';

import '../../../helpers/golden.dart';
import '../../../helpers/pump_app.dart';

class _Tags extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      spacing: AppSpacing.xl,
      children: [
        HangTag(
          productName: 'Organic Cotton Tee',
          brandName: 'Terra Threads',
          sustainability: const SustainabilityInfo(
            carbonScoreGrams: 2100,
            recyclabilityPercent: 80,
            isVerified: true,
            certifierName: 'Global Organic Textile Standard',
          ),
          image: SvgPicture.asset(
            'assets/images/organic-cotton-tee.svg',
            fit: BoxFit.cover,
          ),
          gtin: '08901234500019',
          ownerName: 'Ada Lovelace',
          isOwnerVerified: true,
          size: HangTagSize.lg,
          hasString: true,
        ),
        const HangTag(
          productName: 'Recycled Denim Jeans',
          brandName: 'Terra Threads',
          sustainability: SustainabilityInfo(
            carbonScoreGrams: 9800,
            recyclabilityPercent: 70,
            isVerified: false,
          ),
          gtin: '08901234500026',
        ),
        const HangTag(
          productName: 'Linen Overshirt',
          brandName: 'Field & Flax',
          size: HangTagSize.sm,
          hasPhotoArea: false,
        ),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final status in OwnershipStatus.values)
              OwnershipChip(status: status),
          ],
        ),
      ],
    ),
  );
}

void main() {
  setUpAll(loadAppFonts);

  for (final brightness in Brightness.values) {
    testWidgets(
      'hang tags and chips, ${brightness.name}',
      (tester) => withRealShadows(() async {
        usePhoneScreen(tester, width: 400, height: 1900);
        await pumpThemed(tester, const _Tags(), brightness: brightness);
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('hang_tags_${brightness.name}.png'),
        );
      }),
    );
  }
}
