import 'package:json_annotation/json_annotation.dart';

import 'package:staka/features/admin/import/domain/models/import_report.dart';

part 'import_report_dto.g.dart';

/// Wire format of `ImportReportDto` in the API.
@JsonSerializable(createToJson: false)
class ImportReportDto {
  const new({
    required this.dryRun,
    required this.totalRows,
    required this.created,
    required this.updated,
    required this.failed,
    required this.brandsCreated,
    required this.errors,
  });

  factory fromJson(Map<String, dynamic> json) =>
      _$ImportReportDtoFromJson(json);

  final bool dryRun;
  final int totalRows;
  final int created;
  final int updated;
  final int failed;
  final List<String> brandsCreated;
  final List<ImportRowErrorDto> errors;

  ImportReport toDomain() => ImportReport(
    isDryRun: dryRun,
    totalRows: totalRows,
    created: created,
    updated: updated,
    failed: failed,
    brandsCreated: brandsCreated,
    errors: [for (final error in errors) error.toDomain()],
  );
}

@JsonSerializable(createToJson: false)
class ImportRowErrorDto {
  const new({required this.row, required this.messages, this.gtin});

  factory fromJson(Map<String, dynamic> json) =>
      _$ImportRowErrorDtoFromJson(json);

  final int row;
  final String? gtin;
  final List<String> messages;

  ImportRowError toDomain() =>
      ImportRowError(row: row, gtin: gtin, messages: messages);
}
