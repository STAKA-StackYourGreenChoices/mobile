import 'package:flutter/foundation.dart';

/// What `POST /products/import` found (a check) or did (an import).
@immutable
class ImportReport {
  const new({
    required this.isDryRun,
    required this.totalRows,
    required this.created,
    required this.updated,
    required this.failed,
    required this.brandsCreated,
    required this.errors,
  });

  final bool isDryRun;
  final int totalRows;
  final int created;
  final int updated;
  final int failed;

  /// Names of brands the file creates (or created).
  final List<String> brandsCreated;
  final List<ImportRowError> errors;

  /// Rows that are (or were) saved.
  int get writable => created + updated;
}

/// A row that will be skipped, and why. [row] is the spreadsheet line.
@immutable
class ImportRowError {
  const new({required this.row, required this.messages, this.gtin});

  final int row;
  final String? gtin;
  final List<String> messages;
}
