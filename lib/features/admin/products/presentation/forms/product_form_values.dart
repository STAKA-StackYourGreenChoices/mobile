import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/admin/products/domain/models/editable_product.dart';
import 'package:staka/features/admin/products/domain/models/product_draft.dart';
import 'package:staka/shared/formatters/gtin_format.dart';

/// Everything typed into the product form. Notifies on every change, so
/// the tag preview can follow along (the website's controlled inputs).
class ProductFormValues extends ChangeNotifier {
  new(EditableProduct? editing) {
    final product = editing?.product;
    final info = product?.sustainabilityInfo;
    name.text = product?.name ?? '';
    gtin.text = product == null ? '' : displayGtin(product.gtin);
    sku.text = product?.sku ?? '';
    description.text = product?.description ?? '';
    imageUrl.text = editing?.storedImageUrl ?? '';
    carbon.text = info == null ? '' : '${info.carbonScoreGrams}';
    recyclability.text = info == null ? '' : '${info.recyclabilityPercent}';
    certifier.text = info?.certifierName ?? '';
    _brandId = product?.brand.id;
    _hasFigures = info != null || product == null;
    _isVerified = info?.isVerified ?? false;
    canRemoveFigures = info == null;
    for (final field in _fields) {
      field.addListener(notifyListeners);
    }
  }

  final name = TextEditingController();
  final gtin = TextEditingController();
  final sku = TextEditingController();
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

  String? get brandId => _brandId;
  bool get hasFigures => _hasFigures;
  bool get isVerified => _isVerified;

  List<TextEditingController> get _fields => [
    name,
    gtin,
    sku,
    description,
    imageUrl,
    carbon,
    recyclability,
    certifier,
  ];

  set brandId(String? value) => _set(() => _brandId = value);
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
      gtin: gtin.text.trim(),
      sku: sku.text.trim(),
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
    super.dispose();
  }
}
