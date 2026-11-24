import 'package:material_ui/material_ui.dart';

import 'package:staka/core/config/env.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/utils/image_url.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_values.dart';
import 'package:staka/shared/widgets/data_display/hang_tag/hang_tag.dart';
import 'package:staka/shared/widgets/data_display/tag_image.dart';

/// "Shoppers will see this tag": the hang tag drawn from what is typed so
/// far, updating as the admin types (the website's preview aside).
class ProductTagPreview extends StatelessWidget {
  const new({required this.values, required this.brands, super.key});

  final ProductFormValues values;
  final List<BrandSummary> brands;

  static final _webLink = RegExp(r'^https?://\S+$');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: values,
      builder: (context, _) {
        final name = values.name.text.trim();
        final gtin = values.previewGtin;
        final link = values.imageUrl.text.trim();
        final photo = _webLink.hasMatch(link)
            ? resolveImageUrl(link, webAppUrl: Env.webAppUrl)
            : null;
        return Column(
          spacing: AppSpacing.sm,
          children: [
            Text(
              l10n.tagPreviewCaption,
              style: context.text.bodyMedium.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
            HangTag(
              productName: name.isEmpty ? l10n.previewProductName : name,
              brandName: _brandName(values.brandId) ?? l10n.fieldBrand,
              sustainability: values.previewFigures,
              image: switch (photo) {
                final url? => TagImage(url, key: ValueKey(url)),
                null => null,
              },
              gtin: gtin.isEmpty ? null : gtin.padLeft(14, '0'),
              size: HangTagSize.lg,
            ),
          ],
        );
      },
    );
  }

  String? _brandName(String? id) {
    for (final brand in brands) {
      if (brand.id == id) return brand.name;
    }
    return null;
  }
}
