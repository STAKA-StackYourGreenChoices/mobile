import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/product_variant.dart';

/// A category's name on screen ("Tops").
String categoryName(ProductCategory category, AppLocalizations l10n) =>
    switch (category) {
      ProductCategory.tops => l10n.categoryTops,
      ProductCategory.bottoms => l10n.categoryBottoms,
      ProductCategory.dresses => l10n.categoryDresses,
      ProductCategory.outerwear => l10n.categoryOuterwear,
      ProductCategory.footwear => l10n.categoryFootwear,
      ProductCategory.accessories => l10n.categoryAccessories,
      ProductCategory.other => l10n.categoryOther,
    };

/// "Size M · Navy", "Size M", "Navy", or null when the variant has neither.
String? variantDetails(ProductVariant? variant, AppLocalizations l10n) {
  final size = switch (variant?.size) {
    final size? => l10n.variantSize(size),
    null => null,
  };
  return switch ((size, variant?.colour)) {
    (final size?, final colour?) => l10n.variantDetails(size, colour),
    (final size?, null) => size,
    (null, final colour?) => colour,
    (null, null) => null,
  };
}
