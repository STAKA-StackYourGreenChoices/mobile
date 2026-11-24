import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The website's product rules (`productSchema` in `admin/actions.ts`),
/// with the same messages. Figure rules only apply while figures are
/// included, which the form tells them through [hasFigures].
class ProductFormRules {
  const new(this._l10n, {required this.hasFigures, required this.isVerified});

  final AppLocalizations _l10n;
  final bool Function() hasFigures;
  final bool Function() isVerified;

  static final _gtin = RegExp(r'^\d{8}$|^\d{12,14}$');

  Validators get _common => Validators(_l10n);

  Validator get name => Validators.all([
    _common.required(_l10n.validationProductName),
    _common.maxLength(200),
  ]);

  Validator get brand =>
      (value) => (value ?? '').isEmpty ? _l10n.chooseBrand : null;

  Validator get gtin =>
      (value) =>
          _gtin.hasMatch((value ?? '').trim()) ? null : _l10n.validationGtin;

  Validator get sku => Validators.all([
    _common.required(_l10n.validationSku),
    _common.maxLength(64),
  ]);

  Validator get styleCode =>
      _common.labelledMaxLength(_l10n.fieldStyleCode, 64);

  Validator get size => _common.labelledMaxLength(_l10n.fieldSize, 50);

  Validator get colour => _common.labelledMaxLength(_l10n.fieldColour, 50);

  /// [gtin], and not the same digits as another size/colour in [others].
  Validator variantGtin(Iterable<String> others) => (value) {
    final error = gtin(value);
    if (error != null) return error;
    final digits = (value ?? '').trim().padLeft(14, '0');
    return others.any((other) => other.trim().padLeft(14, '0') == digits)
        ? _l10n.validationDuplicateBarcode
        : null;
  };

  /// [sku], and not the same as another size/colour in [others].
  Validator variantSku(Iterable<String> others) => (value) {
    final error = sku(value);
    if (error != null) return error;
    final text = (value ?? '').trim();
    return others.any((other) => other.trim() == text)
        ? _l10n.validationDuplicateSku
        : null;
  };

  Validator get description =>
      _common.labelledMaxLength(_l10n.fieldDescription, 2000);

  Validator get imageUrl => _common.optionalWebLink;

  /// Digits only (the field filters them), at least 0.
  Validator get carbon => _figure((_) => null);

  Validator get recyclability => _figure(
    (number) => number > 100
        ? _l10n.validationAtMost(_l10n.recyclabilityLabel, 100)
        : null,
  );

  Validator get certifier => (value) {
    if (!hasFigures() || !isVerified()) return null;
    final text = (value ?? '').trim();
    if (text.isEmpty) return _l10n.validationCertifier;
    return _common.labelledMaxLength(_l10n.certifierLabel, 200)(text);
  };

  Validator _figure(String? Function(int number) range) => (value) {
    if (!hasFigures()) return null;
    final number = int.tryParse((value ?? '').trim());
    if (number == null) return _l10n.validationFigureRequired;
    return range(number);
  };
}
