import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/utils/scan_parser.dart';

/// Why a code was ignored, in the website's words (`web/lib/scan.ts`).
String scanRejectionMessage(ScanRejected rejected, AppLocalizations l10n) =>
    switch (rejected.reason) {
      ScanRejection.empty => l10n.scanEmpty,
      ScanRejection.wrongLength => l10n.scanWrongLength(rejected.digitCount),
      ScanRejection.website => l10n.scanWebsite,
      ScanRejection.notABarcode => l10n.scanNotBarcode,
    };
