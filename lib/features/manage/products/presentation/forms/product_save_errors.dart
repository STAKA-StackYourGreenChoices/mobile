import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';

/// Product form fields the API can complain about.
enum ProductField { gtin, sku }

/// A field on one size/colour row of the form (V2-2).
typedef VariantFieldKey = ({int row, ProductField field});

/// A refused save, split like the website's `productApiError`: an alert
/// above the form, and the API's own words on the field at fault.
typedef ProductSaveErrors = ({
  String alert,
  Map<VariantFieldKey, String> fields,
});

/// [variants] are the rows as sent: a 409 names the clashing code, which
/// puts the message on the row that uses it (the first row when no code
/// matches).
ProductSaveErrors productSaveErrors(
  Failure failure,
  AppLocalizations l10n, {
  List<VariantDraft> variants = const [],
}) {
  // The website uses the API's first message.
  final message = failure is ApiFailure ? failure.message ?? '' : '';
  return switch (failure) {
    ConflictFailure() when message.isNotEmpty => (
      alert: l10n.productCodeTaken,
      fields: {
        _clash(message, variants) ??
                (
                  row: 0,
                  field: RegExp('sku', caseSensitive: false).hasMatch(message)
                      ? ProductField.sku
                      : ProductField.gtin,
                ):
            message,
      },
    ),
    BadRequestFailure()
        when RegExp(
          'gtin|check digit',
          caseSensitive: false,
        ).hasMatch(message) =>
      (
        alert: l10n.barcodeInvalid,
        fields: {
          (row: _clash(message, variants)?.row ?? 0, field: ProductField.gtin):
              l10n.barcodeInvalidField(message),
        },
      ),
    ConflictFailure() => (alert: l10n.productCodeTaken, fields: const {}),
    _ => (alert: messageForFailure(failure, l10n), fields: const {}),
  };
}

/// The row and field whose code [message] names, if any. SKUs are checked
/// first: a barcode's digits could appear inside a longer SKU, not the
/// other way round.
VariantFieldKey? _clash(String message, List<VariantDraft> variants) {
  for (final (row, variant) in variants.indexed) {
    if (variant.sku.isNotEmpty && message.contains(variant.sku)) {
      return (row: row, field: ProductField.sku);
    }
  }
  for (final (row, variant) in variants.indexed) {
    final digits = variant.gtin.replaceFirst(RegExp('^0+'), '');
    if (digits.isNotEmpty && message.contains(digits)) {
      return (row: row, field: ProductField.gtin);
    }
  }
  return null;
}
