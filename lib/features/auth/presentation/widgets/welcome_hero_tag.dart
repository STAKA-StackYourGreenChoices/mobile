import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';

/// The welcome screen's example: a real product from the seeded catalog
/// (the website's `SAMPLE_TEE`), hanging from its string and swinging once.
/// Its photo is bundled, so the first screen needs no network.
class WelcomeHeroTag extends StatelessWidget {
  const new({super.key});

  static const _sample = SustainabilityInfo(
    carbonScoreGrams: 2100,
    recyclabilityPercent: 80,
    isVerified: true,
    certifierName: 'Global Organic Textile Standard',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: HangTag(
        productName: l10n.sampleTagProduct,
        brandName: l10n.sampleTagBrand,
        sustainability: _sample,
        gtin: '08901234500019',
        image: SvgPicture.asset(
          'assets/images/organic-cotton-tee.svg',
          fit: BoxFit.cover,
        ),
        hasString: true,
        hasSwing: true,
      ),
    );
  }
}
