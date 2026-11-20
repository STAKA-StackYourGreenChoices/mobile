import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';
import 'package:staka/shared/formatters/gtin_format.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';

/// A code that didn't lead to a product: misread (invalid) or not on STAKA
/// yet (unknown), with the website's words and a way back to scanning.
class ProductNotFound extends StatelessWidget {
  const new({
    required this.lookup,
    required this.gtin,
    required this.onScanAgainPressed,
    super.key,
  });

  /// `InvalidBarcode` or `UnknownProduct`.
  final ProductLookup lookup;
  final String gtin;
  final VoidCallback onScanAgainPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (title, message) = switch (lookup) {
      InvalidBarcode(:final message) => (
        l10n.barcodeInvalidTitle,
        l10n.barcodeInvalidBody(message),
      ),
      _ => (
        l10n.productUnknownTitle,
        // As the website: shown as the 13-digit EAN when it fits.
        l10n.productUnknownBody(displayGtin(gtin.padLeft(14, '0'))),
      ),
    };
    return AppEmptyState(
      icon: Icons.search_off_rounded,
      title: title,
      message: message,
      actionLabel: l10n.scanAgain,
      actionIcon: Icons.qr_code_scanner_rounded,
      onActionPressed: onScanAgainPressed,
    );
  }
}
