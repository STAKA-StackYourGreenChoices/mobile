import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/generated/app_localizations_en.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
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

      // An older API sends no variants: the product's own codes.
      expect(values.variants.single.gtin.text, '8901234500019');
      expect(values.variants.single.id, isNull);
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
      values.variants.single.gtin.text = '8901234500057';
      values.variants.single.sku.text = ' TT-CAP-01 ';
      values.variants.single.size.text = ' ';
      values.description.text = '   ';
      values.carbon.text = '900';
      values.recyclability.text = '70';
      values.certifier.text = 'Left over';

      final draft = values.toDraft();

      expect(draft.name, 'Hemp Cap');
      expect(draft.description, isNull);
      expect(draft.figures?.certifierName, isNull);
      expect(draft.sku, 'TT-CAP-01');
      expect(draft.variants.single.size, isNull);
      expect(draft.styleCode, isNull);
      expect(draft.category, ProductCategory.other);
    });

    test('variants (V2-2): one per saved variant with its codes', () {
      final values = ProductFormValues(
        EditableProduct(
          product: productNamed('Organic Cotton Tee').copyWith(
            category: ProductCategory.tops,
            styleCode: 'TT-TEE',
            variants: const [
              ProductVariant(
                id: 'v1',
                gtin: '08901234500019',
                sku: 'TT-TEE-S',
                size: 'S',
              ),
              ProductVariant(
                id: 'v2',
                gtin: '08901234500057',
                sku: 'TT-TEE-M',
                size: 'M',
                colour: 'Navy',
              ),
            ],
          ),
          aliases: const {
            'v2': [SkuAlias(source: 'Myntra', code: 'MY-2')],
          },
        ),
      );
      addTearDown(values.dispose);

      expect(values.category, ProductCategory.tops);
      expect(values.styleCode.text, 'TT-TEE');
      expect([for (final v in values.variants) v.id], ['v1', 'v2']);
      expect(values.variants.last.gtin.text, '8901234500057');
      expect(values.variants.last.colour.text, 'Navy');
      expect(values.variants.last.aliases, hasLength(1));
      expect(values.previewGtin, '8901234500019');
    });

    test('add and remove sizes; the last one stays', () {
      final values = ProductFormValues(null);
      addTearDown(values.dispose);

      values.addVariant();
      expect(values.variants, hasLength(2));
      values.removeVariant(values.variants.last);
      expect(values.variants, hasLength(1));
      values.removeVariant(values.variants.single);
      expect(values.variants, hasLength(1));
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

    test('two sizes cannot share a barcode or SKU', () {
      final gtin = rules().variantGtin(['08901234500057']);
      expect(gtin('8901234500057'), l10n.validationDuplicateBarcode);
      expect(gtin('8901234500064'), isNull);
      expect(gtin('123'), l10n.validationGtin);
      final sku = rules().variantSku(['CAP-S']);
      expect(sku(' CAP-S '), l10n.validationDuplicateSku);
      expect(sku('CAP-M'), isNull);
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
        (row: 0, field: ProductField.sku):
            'Another product already uses this SKU',
      });
    });

    test('a taken GTIN goes on the barcode field', () {
      final errors = productSaveErrors(
        const ConflictFailure(['Another product already uses this GTIN']),
        l10n,
      );
      expect(errors.fields.keys, [(row: 0, field: ProductField.gtin)]);
    });

    test('a 409 naming a code goes on the row that uses it (V2-2)', () {
      const variants = [
        VariantDraft(gtin: '8901234500057', sku: 'CAP-S'),
        VariantDraft(gtin: '8901234500064', sku: 'CAP-M'),
      ];
      expect(
        productSaveErrors(
          const ConflictFailure(['SKU CAP-M is already used']),
          l10n,
          variants: variants,
        ).fields.keys,
        [(row: 1, field: ProductField.sku)],
      );
      expect(
        productSaveErrors(
          const ConflictFailure(['GTIN 08901234500064 is already used']),
          l10n,
          variants: variants,
        ).fields.keys,
        [(row: 1, field: ProductField.gtin)],
      );
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
