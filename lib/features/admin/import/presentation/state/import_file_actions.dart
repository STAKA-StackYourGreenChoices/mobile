import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import 'package:staka/features/admin/import/domain/models/picked_csv.dart';

part 'import_file_actions.g.dart';

/// What the phone does with import files: pick a CSV, and hand the
/// template to the share sheet (save to Files, Drive, email…), which takes
/// the place of the website's download. Tests override this with a fake.
abstract interface class ImportFileActions {
  /// Null when the admin cancels.
  Future<PickedCsv?> pickCsv();

  /// [origin]: where the share sheet points from on iPad.
  Future<void> shareTemplate(Uint8List csv, {Rect? origin});
}

@riverpod
ImportFileActions importFileActions(Ref ref) => const DeviceImportFileActions();

class DeviceImportFileActions implements ImportFileActions {
  const new();

  /// The website's template file name.
  static const templateName = 'staka-products-template.csv';

  @override
  Future<PickedCsv?> pickCsv() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
    );
    if (file == null) return null;
    return PickedCsv(name: file.name, bytes: await file.readAsBytes());
  }

  @override
  Future<void> shareTemplate(Uint8List csv, {Rect? origin}) =>
      SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(csv, mimeType: 'text/csv', name: templateName),
          ],
          fileNameOverrides: const [templateName],
          sharePositionOrigin: origin,
        ),
      );
}
