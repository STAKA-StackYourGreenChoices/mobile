import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/manage/import/data/datasources/import_remote_data_source.dart';
import 'package:staka/features/manage/import/domain/models/import_report.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';
import 'package:staka/features/manage/import/domain/repositories/import_repository.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'import_repository_impl.g.dart';

/// CSV import into [scope]'s catalog.
@riverpod
ImportRepository importRepository(Ref ref, ManageScope scope) =>
    ImportRepositoryImpl(ImportRemoteDataSource(ref.watch(dioProvider), scope));

class ImportRepositoryImpl implements ImportRepository {
  const new(this._remote);

  final ImportRemoteDataSource _remote;

  @override
  Future<Result<ImportReport>> check(PickedCsv file) => guardApi(
    () async => (await _remote.upload(file, dryRun: true)).toDomain(),
  );

  @override
  Future<Result<ImportReport>> importFile(PickedCsv file) => guardApi(
    () async => (await _remote.upload(file, dryRun: false)).toDomain(),
  );

  @override
  Future<Result<Uint8List>> fetchTemplate() => guardApi(_remote.template);
}
