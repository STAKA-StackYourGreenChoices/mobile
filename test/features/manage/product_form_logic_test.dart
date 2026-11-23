import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/generated/app_localizations_en.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_rules.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_values.dart';
import 'package:staka/features/manage/products/presentation/forms/product_save_errors.dart';

import '../../helpers/product_fakes.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('values', () {
    test('a new product starts with figures on and nothing typed', () {
      final values = ProductFormValues(null);
      addTearDown(values.dispose);

      expect(values.hasFigures, isTrue);
      expect(values.canRemoveFigures, isTrue);
      expect(values.previewFigures, isNull);
    });

    test('editing shows the barcode as printed and the stored photo', () {
      final values = ProductFormValues(
        EditableProduct(
          product: productNamed('Organic Cotton Tee'),
          storedImageUrl: 'http://localhost:3000/catalog-images/tee.svg',
        ),
      );
      addTearDown(values.dispose);

      expect(values.gtin.text, '8901234500019');
      expect(
        values.imageUrl.text,
        'http://localhost:3000/catalog-images/tee.svg',
      );
      expect(values.canRemoveFigures, isFalse);
      expect(values.isVerified, isTrue);
    });

    test('the draft is trimmed; the certifier only goes with verified', () {
      final values = ProductFormValues(null)
        ..brandId = 'b1'
        ..isVerified = false;
      addTearDown(values.dispose);
      values.name.text = '  Hemp Cap ';
      values.gtin.text = '8901234500057';
      values.sku.text = 'TT-CAP-01';
      values.description.text = '   ';
      values.carbon.text = '900';
      values.recyclability.text = '70';
      values.certifier.text = 'Left over';

      final draft = values.toDraft();

      expect(draft.name, 'Hemp Cap');
      expect(draft.description, isNull);
      expect(draft.figures?.certifierName, isNull);
    });

    test('the preview caps recyclability at 100, like the website', () {
      final values = ProductFormValues(null);
      addTearDown(values.dispose);
      values.carbon.text = '2100';
      values.recyclability.text = '150';

      expect(values.previewFigures?.recyclabilityPercent, 100);
    });
  });

  group('rules', () {
    ProductFormRules rules({bool figures = true, bool verified = false}) =>
        ProductFormRules(
          l10n,
          hasFigures: () => figures,
          isVerified: () => verified,
        );

    test('barcodes: 8, 12, 13 or 14 digits', () {
      for (final ok in ['12345670', '614141000418', '8901234500019']) {
        expect(rules().gtin(ok), isNull, reason: ok);
      }
      for (final bad in ['', '1234567', '12345678901']) {
        expect(rules().gtin(bad), l10n.validationGtin, reason: bad);
      }
    });

    test('photo link: optional, else a full http(s) link', () {
      expect(rules().imageUrl(''), isNull);
      expect(rules().imageUrl('https://example.com/a.jpg'), isNull);
      expect(rules().imageUrl('example.com/a.jpg'), l10n.validationUrl);
      expect(rules().imageUrl('ftp://example.com/a.jpg'), l10n.validationUrl);
    });

    test('figures are only checked while included', () {
      expect(rules(figures: false).carbon(''), isNull);
      expect(rules().carbon(''), l10n.validationFigureRequired);
      expect(rules().recyclability('101'), 'Recyclability must be 100 or less');
      expect(rules(verified: true).certifier(''), l10n.validationCertifier);
      expect(rules().certifier(''), isNull);
    });

    test('long text names its field', () {
      expect(
        rules().description('x' * 2001),
        'Description must be 2000 characters or fewer',
      );
    });
  });

  group('save errors', () {
    test('a taken SKU goes on the SKU field', () {
      final errors = productSaveErrors(
        const ConflictFailure(['Another product already uses this SKU']),
        l10n,
      );
      expect(errors.alert, l10n.productCodeTaken);
      expect(errors.fields, {
        ProductField.sku: 'Another product already uses this SKU',
      });
    });

    test('a taken GTIN goes on the barcode field', () {
      final errors = productSaveErrors(
        const ConflictFailure(['Another product already uses this GTIN']),
        l10n,
      );
      expect(errors.fields.keys, [ProductField.gtin]);
    });

    test('anything else is one alert in the API words', () {
      final errors = productSaveErrors(
        const BadRequestFailure(400, ['Brand b9 does not exist']),
        l10n,
      );
      expect(errors.alert, 'Brand b9 does not exist');
      expect(errors.fields, isEmpty);
    });
  });
}
