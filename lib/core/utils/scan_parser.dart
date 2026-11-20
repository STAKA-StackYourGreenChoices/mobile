/// What a camera or keyboard produced, turned into a GTIN to look up — the
/// website's `parseScan` (`web/lib/scan.ts`), same rules.
///
/// Accepts barcode digits (EAN-8, UPC-A, EAN-13, GTIN-14) with stray
/// spaces or dashes, and GS1 Digital Link QR codes such as
/// `https://id.gs1.org/01/09506000134352`, where the GTIN follows `/01/`.
/// The check digit is left to the API, which explains a mismatch.
sealed class ScanResult {
  const new();
}

final class ScanGtin extends ScanResult {
  const new(this.gtin);

  final String gtin;
}

enum ScanRejection {
  /// Nothing was entered.
  empty,

  /// Digits, but not 8, 12, 13 or 14 of them ([ScanRejected.digitCount]).
  wrongLength,

  /// A web address that isn't a GS1 Digital Link.
  website,

  /// Anything else.
  notABarcode,
}

final class ScanRejected extends ScanResult {
  const new(this.reason, {this.digitCount = 0});

  final ScanRejection reason;
  final int digitCount;
}

final _digitLink = RegExp(r'/01/(\d{8,14})(?:[/?#]|$)');
final _separators = RegExp(r'[\s-]');
final _onlyDigits = RegExp(r'^\d+$');
final _webAddress = RegExp('^https?://', caseSensitive: false);
const _gtinLengths = {8, 12, 13, 14};

ScanResult parseScan(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return const ScanRejected(ScanRejection.empty);

  if (_digitLink.firstMatch(text)?.group(1) case final gtin?) {
    return ScanGtin(gtin);
  }

  final digits = text.replaceAll(_separators, '');
  if (_onlyDigits.hasMatch(digits)) {
    return _gtinLengths.contains(digits.length)
        ? ScanGtin(digits)
        : ScanRejected(ScanRejection.wrongLength, digitCount: digits.length);
  }

  return _webAddress.hasMatch(text)
      ? const ScanRejected(ScanRejection.website)
      : const ScanRejected(ScanRejection.notABarcode);
}
