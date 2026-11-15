import 'package:staka/core/error/failure.dart';
import 'package:staka/features/admin/import/domain/models/import_report.dart';
import 'package:staka/features/admin/import/domain/models/picked_csv.dart';

/// The website's three import steps: choose a file, review the check,
/// imported.
sealed class ImportState {
  const new();
}

final class ImportChoosing extends ImportState {
  const new({this.file, this.isChecking = false, this.error});

  final PickedCsv? file;
  final bool isChecking;
  final ImportError? error;
}

final class ImportReviewing extends ImportState {
  const new({
    required this.file,
    required this.report,
    this.isImporting = false,
    this.error,
  });

  final PickedCsv file;

  /// The dry run's findings; nothing is saved yet.
  final ImportReport report;
  final bool isImporting;
  final ImportError? error;
}

final class ImportDone extends ImportState {
  const new(this.report);

  final ImportReport report;
}

/// Why a step could not go ahead, shown above the step.
sealed class ImportError {
  const new();
}

/// The file was refused before sending, as the website does.
final class ImportFileRejected extends ImportError {
  const new(this.reason, {this.fileName = ''});

  final FileRejection reason;
  final String fileName;
}

enum FileRejection { missing, notCsv, tooLarge }

/// The API refused or could not be reached.
final class ImportRequestFailed extends ImportError {
  const new(this.failure);

  final Failure failure;
}
