import 'package:material_ui/material_ui.dart';

import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/shared/formatters/gtin_format.dart';

/// One size/colour row of the product form (V2-2). [id] is set once the
/// API has saved it; only then can other shops' codes be added.
class VariantFormValues {
  new({ProductVariant? variant, List<SkuAlias> aliases = const []})
    : id = variant?.id,
      aliases = [...aliases] {
    gtin.text = variant == null ? '' : displayGtin(variant.gtin);
    sku.text = variant?.sku ?? '';
    size.text = variant?.size ?? '';
    colour.text = variant?.colour ?? '';
  }

  /// A stand-in for an older API that sends no variants: the product's own
  /// codes, not yet saved as a variant.
  new primary({required String gtin, required String sku}) : id = null {
    this.gtin.text = displayGtin(gtin);
    this.sku.text = sku;
  }

  final String? id;

  /// Kept up to date by the other shop codes sheet.
  List<SkuAlias> aliases = [];

  /// Tells widgets apart while rows are added and removed.
  final Key key = UniqueKey();

  final gtin = TextEditingController();
  final sku = TextEditingController();
  final size = TextEditingController();
  final colour = TextEditingController();

  List<TextEditingController> get fields => [gtin, sku, size, colour];

  VariantDraft toDraft() {
    String? optional(TextEditingController field) =>
        field.text.trim().isEmpty ? null : field.text.trim();
    return VariantDraft(
      id: id,
      gtin: gtin.text.trim(),
      sku: sku.text.trim(),
      size: optional(size),
      colour: optional(colour),
    );
  }

  void dispose() {
    for (final field in fields) {
      field.dispose();
    }
  }
}
