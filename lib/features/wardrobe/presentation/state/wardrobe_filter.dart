import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/models/product_variant.dart';

part 'wardrobe_filter.g.dart';

/// The kind of piece the wardrobe shows; null shows everything (V2-2).
@riverpod
class WardrobeCategoryFilter extends _$WardrobeCategoryFilter {
  @override
  ProductCategory? build() => null;

  // A method, not a setter: the screen passes it as a callback.
  // ignore: use_setters_to_change_properties
  void select(ProductCategory? category) => state = category;
}
