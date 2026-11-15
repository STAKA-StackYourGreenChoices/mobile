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

  Validator get description => _labelledMax(_l10n.fieldDescription, 2000);

  /// Optional; when given, a full http(s) link.
  Validator get imageUrl => (value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final isWebLink =
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
    return isWebLink ? null : _l10n.validationUrl;
  };

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
    return _labelledMax(_l10n.certifierLabel, 200)(text);
  };

  Validator _figure(String? Function(int number) range) => (value) {
    if (!hasFigures()) return null;
    final number = int.tryParse((value ?? '').trim());
    if (number == null) return _l10n.validationFigureRequired;
    return range(number);
  };

  Validator _labelledMax(String label, int max) =>
      (value) => (value ?? '').trim().length > max
      ? _l10n.validationFieldTooLong(label, max)
      : null;
}
