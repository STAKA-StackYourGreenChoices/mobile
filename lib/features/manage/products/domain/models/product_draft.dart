import 'package:flutter/foundation.dart';

/// What the admin typed in the product form, already checked: the body of
/// `POST /products` or `PATCH /products/:id`.
@immutable
class ProductDraft {
  const new({
    required this.name,
    required this.brandId,
    required this.gtin,
    required this.sku,
    this.description,
    this.imageUrl,
    this.figures,
  });

  final String name;
  final String brandId;

  /// The digits as typed (8, 12, 13 or 14); the API stores 14.
  final String gtin;
  final String sku;

  /// Null when left empty: cleared on edit, like the website.
  final String? description;
  final String? imageUrl;

  /// Null when the product has no figures.
  final FiguresDraft? figures;
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
