import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:staka/features/manage/import/data/dtos/import_report_dto.dart';
import 'package:staka/features/manage/import/domain/models/picked_csv.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

/// `POST /products/import?dryRun=` (multipart field `file`) and
/// `GET /products/import/template`; under `/brand/<id>` for a brand's own
/// catalog.
class ImportRemoteDataSource {
  const new(this._dio, this._scope);

  final Dio _dio;
  final ManageScope _scope;

  Future<ImportReportDto> upload(PickedCsv file, {required bool dryRun}) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file.bytes,
        filename: file.name,
        contentType: DioMediaType('text', 'csv'),
      ),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      _scope.path('/products/import'),
      queryParameters: {'dryRun': dryRun},
      data: form,
    );
    return ImportReportDto.fromJson(response.data!);
  }

  Future<Uint8List> template() async {
    final response = await _dio.get<List<int>>(
      _scope.path('/products/import/template'),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }
}
