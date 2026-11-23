import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The website's brand rules (`brandSchema` in `admin/actions.ts`), with
/// the same messages.
class BrandFormRules {
  const new(this._l10n);

  final AppLocalizations _l10n;

  Validators get _common => Validators(_l10n);

  Validator get name => Validators.all([
    _common.required(_l10n.validationBrandName),
    _common.maxLength(100),
  ]);

  Validator get description =>
      _common.labelledMaxLength(_l10n.fieldDescription, 1000);

  Validator get logoUrl => _common.optionalWebLink;
}
