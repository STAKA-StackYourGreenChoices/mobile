import 'package:flutter/foundation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/import/domain/models/import_report.dart';
import 'package:staka/features/admin/import/domain/models/picked_csv.dart';

/// Importing products from a CSV file.
abstract interface class ImportRepository {
  /// Checks the file without saving anything (a dry run).
  Future<Result<ImportReport>> check(PickedCsv file);

  /// Saves every valid row; invalid ones are skipped.
  Future<Result<ImportReport>> importFile(PickedCsv file);

  /// The CSV template: the header row plus one example.
  Future<Result<Uint8List>> fetchTemplate();
}
