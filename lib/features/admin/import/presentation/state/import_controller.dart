import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/import/data/repositories/import_repository_impl.dart';
import 'package:staka/features/admin/import/domain/models/picked_csv.dart';
import 'package:staka/features/admin/import/presentation/state/import_file_actions.dart';
import 'package:staka/features/admin/import/presentation/state/import_state.dart';
import 'package:staka/features/admin/shared/admin_catalog_revision.dart';

part 'import_controller.g.dart';

/// The website's `ImportFlow`: pick a file, check it (dry run), then
/// import for real or choose another.
@riverpod
class ImportController extends _$ImportController {
  @override
  ImportState build() => const ImportChoosing();

  Future<void> chooseFile() async {
    if (state case ImportChoosing(isChecking: true)) return;
    final picked = await ref.read(importFileActionsProvider).pickCsv();
    if (picked == null || !ref.mounted) return;
    if (state is ImportChoosing) state = ImportChoosing(file: picked);
  }

  Future<void> check() async {
    final current = state;
    if (current is! ImportChoosing || current.isChecking) return;
    final file = current.file;
    if (_rejection(file) case final rejection?) {
      state = ImportChoosing(file: file, error: rejection);
      return;
    }
    final picked = file!;
    state = ImportChoosing(file: picked, isChecking: true);
    final result = await ref.read(importRepositoryProvider).check(picked);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => ImportReviewing(file: picked, report: value),
      Err(:final failure) => ImportChoosing(
        file: picked,
        error: ImportRequestFailed(failure),
      ),
    };
  }

  Future<void> importFile() async {
    final current = state;
    if (current is! ImportReviewing || current.isImporting) return;
    final revision = ref.read(adminCatalogRevisionProvider.notifier);
    state = ImportReviewing(
      file: current.file,
      report: current.report,
      isImporting: true,
    );
    final result = await ref
        .read(importRepositoryProvider)
        .importFile(current.file);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => ImportDone(value),
      Err(:final failure) => ImportReviewing(
        file: current.file,
        report: current.report,
        error: ImportRequestFailed(failure),
      ),
    };
  }

  /// "Choose a different file" / "Import another file".
  void startOver() => state = const ImportChoosing();

  /// The website's checks before sending.
  static ImportFileRejected? _rejection(PickedCsv? file) => switch (file) {
    null => const ImportFileRejected(FileRejection.missing),
    PickedCsv(isEmpty: true) => const ImportFileRejected(FileRejection.missing),
    PickedCsv(isCsv: false, :final name) => ImportFileRejected(
      FileRejection.notCsv,
      fileName: name,
    ),
    PickedCsv(isTooLarge: true) => const ImportFileRejected(
      FileRejection.tooLarge,
    ),
    _ => null,
  };
}
