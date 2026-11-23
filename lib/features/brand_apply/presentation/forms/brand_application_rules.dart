import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The application form's rules. Limits follow the admin brand form
/// (name 100, description 1000); the API has the final say.
class BrandApplicationRules {
  const new(this._l10n);

  final AppLocalizations _l10n;

  /// GST registration: state code, PAN, entity number, `Z`, check
  /// character.
  static final _gstinPattern = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
  );

  Validators get _common => Validators(_l10n);

  Validator get name => Validators.all([
    _common.required(_l10n.validationBrandName),
    _common.maxLength(100),
  ]);

  Validator get legalName => Validators.all([
    _common.required(_l10n.validationLegalName),
    _common.maxLength(200),
  ]);

  Validator get description =>
      _common.labelledMaxLength(_l10n.fieldAboutBrand, 1000);

  Validator get website => _common.optionalWebLink;

  Validator get gstin => (value) {
    final text = normalisedGstin(value ?? '');
    if (text.isEmpty) return null;
    return _gstinPattern.hasMatch(text) ? null : _l10n.validationGstin;
  };

  Validator get contactEmail => _common.email;

  /// Optional; when given, a number we could text.
  Validator get contactPhone => (value) {
    if ((value ?? '').trim().isEmpty) return null;
    return _common.phone(value);
  };

  Validator get listedBrand => _common.required(_l10n.chooseYourBrand);

  /// Upper case without spaces, as the API stores it.
  static String normalisedGstin(String value) =>
      value.replaceAll(RegExp(r'\s'), '').toUpperCase();
}
