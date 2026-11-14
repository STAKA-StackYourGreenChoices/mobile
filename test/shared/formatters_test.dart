import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/l10n/generated/app_localizations_en.dart';
import 'package:staka/shared/formatters/carbon_format.dart';
import 'package:staka/shared/formatters/gtin_format.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test("carbon: same output as the website's carbonParts", () {
    expect(carbonParts(950, l10n), (value: '950', unit: 'g CO₂e'));
    expect(carbonParts(1000, l10n), (value: '1', unit: 'kg CO₂e'));
    expect(carbonParts(2100, l10n), (value: '2.1', unit: 'kg CO₂e'));
    expect(carbonParts(9840, l10n), (value: '9.8', unit: 'kg CO₂e'));
    expect(carbonParts(12345, l10n), (value: '12', unit: 'kg CO₂e'));
    expect(formatCarbon(2100, l10n), '2.1 kg CO₂e');
  });

  test('GTIN: the 13-digit EAN when the stored 14 start with 0', () {
    expect(displayGtin('08901234500019'), '8901234500019');
    expect(displayGtin('18901234500016'), '18901234500016');
  });
}
