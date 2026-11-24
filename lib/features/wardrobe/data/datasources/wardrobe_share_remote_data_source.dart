import 'package:dio/dio.dart';

import 'package:staka/core/api_models/share_link_dto.dart';

/// `GET`, `POST` and `DELETE /me/wardrobe-share` (V2-3).
class WardrobeShareRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  static const _path = '/me/wardrobe-share';

  /// Null when not shared: the API answers `null` (or nothing).
  Future<ShareLinkDto?> fetch() async {
    final response = await _dio.get<Object?>(_path);
    return switch (response.data) {
      final Map<String, dynamic> json => ShareLinkDto.fromJson(json),
      _ => null,
    };
  }

  Future<ShareLinkDto> create() async {
    final response = await _dio.post<Map<String, dynamic>>(_path);
    return ShareLinkDto.fromJson(response.data!);
  }

  Future<void> delete() => _dio.delete<void>(_path);
}
