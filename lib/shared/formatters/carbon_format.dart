import 'package:intl/intl.dart';

import 'package:staka/core/l10n/l10n.dart';

/// A carbon figure split for display: a large value and a small unit, so
/// the unit never wraps away from its number. Grams below 1 kg, otherwise
/// kg with one decimal under 10 kg — the website's `carbonParts`.
({String value, String unit}) carbonParts(int grams, AppLocalizations l10n) {
  if (grams < 1000) {
    return (
      value: NumberFormat.decimalPattern().format(grams),
      unit: l10n.unitGramsCo2e,
    );
  }
  final kg = grams / 1000;
  final format = NumberFormat.decimalPattern()
    ..maximumFractionDigits = kg < 10 ? 1 : 0;
  return (value: format.format(kg), unit: l10n.unitKgCo2e);
}

/// "2.1 kg CO₂e": every number names its unit (web DESIGN.md principle 2).
String formatCarbon(int grams, AppLocalizations l10n) {
  final (:value, :unit) = carbonParts(grams, l10n);
  return '$value $unit';
}
