import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:staka/features/admin/import/data/dtos/import_report_dto.dart';
import 'package:staka/features/admin/import/domain/models/picked_csv.dart';

/// `POST /products/import?dryRun=` (multipart field `file`) and
/// `GET /products/import/template`.
class ImportRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<ImportReportDto> upload(PickedCsv file, {required bool dryRun}) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file.bytes,
        filename: file.name,
        contentType: DioMediaType('text', 'csv'),
      ),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '/products/import',
      queryParameters: {'dryRun': dryRun},
      data: form,
    );
    return ImportReportDto.fromJson(response.data!);
  }

  Future<Uint8List> template() async {
    final response = await _dio.get<List<int>>(
      '/products/import/template',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }
}
