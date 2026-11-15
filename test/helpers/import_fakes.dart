import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/import/domain/models/import_report.dart';
import 'package:staka/features/admin/import/domain/models/picked_csv.dart';
import 'package:staka/features/admin/import/domain/repositories/import_repository.dart';
import 'package:staka/features/admin/import/presentation/state/import_file_actions.dart';

/// Answers checks and imports from scripts, recording the files sent.
class FakeImportRepository implements ImportRepository {
  new({
    List<Result<ImportReport>> checks = const [],
    List<Result<ImportReport>> imports = const [],
    Result<Uint8List>? template,
  }) : _checks = [...checks],
       _imports = [...imports],
       _template = template ?? Ok(utf8.encode('gtin,sku,name,brandName\n'));

  final List<Result<ImportReport>> _checks;
  final List<Result<ImportReport>> _imports;
  final Result<Uint8List> _template;
  final List<String> checked = [];
  final List<String> imported = [];

  @override
  Future<Result<ImportReport>> check(PickedCsv file) async {
    checked.add(file.name);
    return _checks.removeAt(0);
  }

  @override
  Future<Result<ImportReport>> importFile(PickedCsv file) async {
    imported.add(file.name);
    return _imports.removeAt(0);
  }

  @override
  Future<Result<Uint8List>> fetchTemplate() async => _template;
}

/// Hands out the scripted `picks` in order; records shared templates.
class FakeImportFileActions implements ImportFileActions {
  new({List<PickedCsv?> picks = const []}) : _picks = [...picks];

  final List<PickedCsv?> _picks;
  final List<Uint8List> sharedTemplates = [];

  @override
  Future<PickedCsv?> pickCsv() async => _picks.removeAt(0);

  @override
  Future<void> shareTemplate(Uint8List csv, {Rect? origin}) async =>
      sharedTemplates.add(csv);
}

/// A picked file named [name] holding [text] (or [size] bytes).
PickedCsv csvFile(String name, {String text = 'gtin\n1\n', int? size}) =>
    PickedCsv(
      name: name,
      bytes: size == null ? utf8.encode(text) : Uint8List(size),
    );

ImportReport importReport({
  bool isDryRun = true,
  int totalRows = 4,
  int created = 2,
  int updated = 1,
  List<String> brandsCreated = const ['Hemp House'],
  List<ImportRowError> errors = const [
    ImportRowError(row: 5, messages: ['gtin is required']),
  ],
}) => ImportReport(
  isDryRun: isDryRun,
  totalRows: totalRows,
  created: created,
  updated: updated,
  failed: errors.length,
  brandsCreated: brandsCreated,
  errors: errors,
);
