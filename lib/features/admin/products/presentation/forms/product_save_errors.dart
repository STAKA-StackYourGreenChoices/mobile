import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';

/// Product form fields the API can complain about.
enum ProductField { gtin, sku }

/// A refused save, split like the website's `productApiError`: an alert
/// above the form, and the API's own words on the field at fault.
typedef ProductSaveErrors = ({String alert, Map<ProductField, String> fields});

ProductSaveErrors productSaveErrors(Failure failure, AppLocalizations l10n) {
  // The website uses the API's first message.
  final message = failure is ApiFailure ? failure.message ?? '' : '';
  return switch (failure) {
    ConflictFailure() when message.isNotEmpty => (
      alert: l10n.productCodeTaken,
      fields: {
        RegExp('sku', caseSensitive: false).hasMatch(message)
                ? ProductField.sku
                : ProductField.gtin:
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
        fields: {ProductField.gtin: l10n.barcodeInvalidField(message)},
      ),
    ConflictFailure() => (alert: l10n.productCodeTaken, fields: const {}),
    _ => (alert: messageForFailure(failure, l10n), fields: const {}),
  };
}
