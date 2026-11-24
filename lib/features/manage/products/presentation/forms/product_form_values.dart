import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/features/manage/products/presentation/forms/variant_form_values.dart';

/// Everything typed into the product form. Notifies on every change, so
/// the tag preview can follow along (the website's controlled inputs).
class ProductFormValues extends ChangeNotifier {
  /// [defaultBrandId] is chosen for a new product (a brand's own).
  new(EditableProduct? editing, {String? defaultBrandId}) {
    final product = editing?.product;
    final info = product?.sustainabilityInfo;
    name.text = product?.name ?? '';
    styleCode.text = product?.styleCode ?? '';
    _category = product?.category ?? ProductCategory.other;
    _variants = switch (product) {
      null => [VariantFormValues()],
      Product(variants: []) => [
        VariantFormValues.primary(gtin: product.gtin, sku: product.sku),
      ],
      _ => [
        for (final variant in product.variants)
          VariantFormValues(
            variant: variant,
            aliases: editing?.aliases[variant.id] ?? const [],
          ),
      ],
    };
    description.text = product?.description ?? '';
    imageUrl.text = editing?.storedImageUrl ?? '';
    carbon.text = info == null ? '' : '${info.carbonScoreGrams}';
    recyclability.text = info == null ? '' : '${info.recyclabilityPercent}';
    certifier.text = info?.certifierName ?? '';
    _brandId = product?.brand.id ?? defaultBrandId;
    _hasFigures = info != null || product == null;
    _isVerified = info?.isVerified ?? false;
    canRemoveFigures = info == null;
    for (final field in [..._fields, for (final v in _variants) ...v.fields]) {
      field.addListener(notifyListeners);
    }
  }

  final name = TextEditingController();
  final styleCode = TextEditingController();
  final description = TextEditingController();
  final imageUrl = TextEditingController();
  final carbon = TextEditingController();
  final recyclability = TextEditingController();
  final certifier = TextEditingController();

  /// Figures can be added to a product but not removed (website rule).
  late final bool canRemoveFigures;

  String? _brandId;
  bool _hasFigures = true;
  bool _isVerified = false;
  late ProductCategory _category;
  late List<VariantFormValues> _variants;
  final _removed = <VariantFormValues>[];

  String? get brandId => _brandId;
  ProductCategory get category => _category;

  /// The sizes and colours, in order; the first is the primary.
  List<VariantFormValues> get variants => List.unmodifiable(_variants);

  /// What the preview tag shows as the barcode: the first variant's.
  String get previewGtin => _variants.first.gtin.text;
  bool get hasFigures => _hasFigures;
  bool get isVerified => _isVerified;

  List<TextEditingController> get _fields => [
    name,
    styleCode,
    description,
    imageUrl,
    carbon,
    recyclability,
    certifier,
  ];

  set brandId(String? value) => _set(() => _brandId = value);
  set category(ProductCategory value) => _set(() => _category = value);

  void addVariant() {
    final variant = VariantFormValues();
    for (final field in variant.fields) {
      field.addListener(notifyListeners);
    }
    _set(() => _variants = [..._variants, variant]);
  }

  /// Leaves at least one.
  void removeVariant(VariantFormValues variant) {
    if (_variants.length == 1) return;
    _set(() => _variants = [..._variants]..remove(variant));
    // Its fields may still be on screen this frame: disposed with the form.
    _removed.add(variant);
  }

  /// After the other shop codes sheet changed them.
  void setAliases(VariantFormValues variant, List<SkuAlias> aliases) =>
      _set(() => variant.aliases = aliases);
  set hasFigures(bool value) => _set(() => _hasFigures = value);
  set isVerified(bool value) => _set(() => _isVerified = value);

  void _set(VoidCallback change) {
    change();
    notifyListeners();
  }

  /// What the preview tag shows: figures only once both numbers are typed.
  SustainabilityInfo? get previewFigures {
    final carbonValue = int.tryParse(carbon.text);
    final recyclable = int.tryParse(recyclability.text);
    if (!_hasFigures || carbonValue == null || recyclable == null) return null;
    final certifierName = certifier.text.trim();
    return SustainabilityInfo(
      carbonScoreGrams: carbonValue,
      recyclabilityPercent: math.min(100, recyclable),
      isVerified: _isVerified,
      certifierName: _isVerified && certifierName.isNotEmpty
          ? certifierName
          : null,
    );
  }

  /// The checked values as the API wants them. Call after validating.
  ProductDraft toDraft() {
    String? optional(TextEditingController field) =>
        field.text.trim().isEmpty ? null : field.text.trim();
    return ProductDraft(
      name: name.text.trim(),
      brandId: _brandId ?? '',
      variants: [for (final variant in _variants) variant.toDraft()],
      category: _category,
      styleCode: optional(styleCode),
      description: optional(description),
      imageUrl: optional(imageUrl),
      figures: _hasFigures
          ? FiguresDraft(
              carbonScoreGrams: int.parse(carbon.text.trim()),
              recyclabilityPercent: int.parse(recyclability.text.trim()),
              isVerified: _isVerified,
              certifierName: _isVerified ? optional(certifier) : null,
            )
          : null,
    );
  }

  @override
  void dispose() {
    for (final field in _fields) {
      field.dispose();
    }
    for (final variant in [..._variants, ..._removed]) {
      variant.dispose();
    }
    super.dispose();
  }
}
