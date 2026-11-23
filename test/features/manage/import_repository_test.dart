import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/import/data/datasources/import_remote_data_source.dart';
import 'package:staka/features/manage/import/data/repositories/import_repository_impl.dart';
import 'package:staka/features/manage/import/domain/models/import_report.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/import_fakes.dart';

const Map<String, Object> _report = {
  'dryRun': true,
  'totalRows': 2,
  'created': 1,
  'updated': 0,
  'failed': 1,
  'brandsCreated': ['Hemp House'],
  'errors': [
    {
      'row': 3,
      'messages': ['gtin is required'],
    },
  ],
};

(ImportRepositoryImpl, FakeHttpAdapter) _repository(FakeReply reply) {
  final adapter = FakeHttpAdapter([reply]);
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = adapter;
  return (
    ImportRepositoryImpl(ImportRemoteDataSource(dio, const AdminScope())),
    adapter,
  );
}

void main() {
  test('check: the file in the "file" field, as a dry run', () async {
    final (repository, adapter) = _repository(json(200, _report));

    final result = await repository.check(csvFile('catalog.csv'));

    final request = adapter.requests.single;
    expect((request.method, request.path), ('POST', '/products/import'));
    expect(request.queryParameters, {'dryRun': true});
    final upload = (request.data as FormData).files.single;
    expect((upload.key, upload.value.filename), ('file', 'catalog.csv'));
    final report = (result as Ok<ImportReport>).value;
    expect((report.writable, report.failed), (1, 1));
    expect(report.errors.single.gtin, isNull);
    expect(report.brandsCreated, ['Hemp House']);
  });

  test('import: the same upload, for real', () async {
    final (repository, adapter) = _repository(
      json(200, {..._report, 'dryRun': false}),
    );

    final result = await repository.importFile(csvFile('catalog.csv'));

    expect(adapter.requests.single.queryParameters, {'dryRun': false});
    expect((result as Ok<ImportReport>).value.isDryRun, isFalse);
  });

  test('template: the CSV bytes as sent', () async {
    final (repository, adapter) = _repository(
      (_) async => ResponseBody.fromString(
        'gtin,sku,name,brandName\n',
        200,
        headers: {
          Headers.contentTypeHeader: ['text/csv; charset=utf-8'],
        },
      ),
    );

    final result = await repository.fetchTemplate();

    expect(adapter.requests.single.path, '/products/import/template');
    expect(
      utf8.decode((result as Ok).value as List<int>),
      'gtin,sku,name,brandName\n',
    );
  });
}
