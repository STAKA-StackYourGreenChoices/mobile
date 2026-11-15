// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportReportDto _$ImportReportDtoFromJson(Map<String, dynamic> json) =>
    ImportReportDto(
      dryRun: json['dryRun'] as bool,
      totalRows: (json['totalRows'] as num).toInt(),
      created: (json['created'] as num).toInt(),
      updated: (json['updated'] as num).toInt(),
      failed: (json['failed'] as num).toInt(),
      brandsCreated: (json['brandsCreated'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      errors: (json['errors'] as List<dynamic>)
          .map((e) => ImportRowErrorDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ImportRowErrorDto _$ImportRowErrorDtoFromJson(Map<String, dynamic> json) =>
    ImportRowErrorDto(
      row: (json['row'] as num).toInt(),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gtin: json['gtin'] as String?,
    );
