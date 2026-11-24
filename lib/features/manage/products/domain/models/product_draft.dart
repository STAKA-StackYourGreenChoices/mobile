import 'package:flutter/foundation.dart';

import 'package:staka/core/models/product_variant.dart';

/// What the brand typed in the product form, already checked: the body of
/// `POST /products` or `PATCH /products/:id` (under `/brand/<id>`).
@immutable
class ProductDraft {
  const new({
    required this.name,
    required this.brandId,
    required this.variants,
    this.category = ProductCategory.other,
    this.styleCode,
    this.description,
    this.imageUrl,
    this.figures,
  });

  final String name;
  final String brandId;

  /// At least one (V2-2); the first is the primary.
  final List<VariantDraft> variants;
  final ProductCategory category;

  /// Null when left empty: cleared on edit.
  final String? styleCode;

  /// The primary variant's codes, still sent for older readers.
  String get gtin => variants.first.gtin;
  String get sku => variants.first.sku;

  /// Null when left empty: cleared on edit, like the website.
  final String? description;
  final String? imageUrl;

  /// Null when the product has no figures.
  final FiguresDraft? figures;
}

/// One size/colour as typed. [id] is null for a new one.
@immutable
class VariantDraft {
  const new({
    required this.gtin,
    required this.sku,
    this.id,
    this.size,
    this.colour,
  });

  final String? id;

  /// The digits as typed (8, 12, 13 or 14); the API stores 14.
  final String gtin;
  final String sku;
  final String? size;
  final String? colour;

  /// For labels such as "Size M · Navy".
  ProductVariant get asVariant => ProductVariant(
    id: id ?? '',
    gtin: gtin,
    sku: sku,
    size: size,
    colour: colour,
  );
}

@immutable
class FiguresDraft {
  const new({
    required this.carbonScoreGrams,
    required this.recyclabilityPercent,
    required this.isVerified,
    this.certifierName,
  });

  final int carbonScoreGrams;
  final int recyclabilityPercent;
  final bool isVerified;

  /// Only sent when [isVerified].
  final String? certifierName;
}
