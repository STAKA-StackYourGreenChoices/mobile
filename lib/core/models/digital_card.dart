import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/core/models/share_link.dart';

part 'digital_card.freezed.dart';

/// A shopper's tag for one product in their wardrobe ("tag" on screen).
@freezed
abstract class DigitalCard with _$DigitalCard {
  const factory({
    required String id,
    required DateTime createdAt,
    required String ownerName,
    required Product product,
    required Ownership ownership,

    /// Present while the tag is publicly shared.
    ShareLink? share,

    /// The size/colour the shopper scanned (V2-2), when the API knows it.
    ProductVariant? variant,

    /// Shown on the public wardrobe page while it is shared (V2-3).
    @Default(true) bool showInWardrobe,
  }) = _DigitalCard;
}
