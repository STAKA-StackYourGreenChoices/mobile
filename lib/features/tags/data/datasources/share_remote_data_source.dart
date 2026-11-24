import 'package:dio/dio.dart';

import 'package:staka/core/api_models/share_link_dto.dart';

/// `POST` / `DELETE /digital-cards/:id/share` on the API. The share
/// images come from the website: `ShareImageApi` (core/sharing).
class ShareRemoteDataSource {
  const new(this._api);

  final Dio _api;

  Future<ShareLinkDto> share(String cardId) async {
    final response = await _api.post<Map<String, dynamic>>(_path(cardId));
    return ShareLinkDto.fromJson(response.data!);
  }

  Future<void> stopSharing(String cardId) => _api.delete<void>(_path(cardId));

  String _path(String cardId) =>
      '/digital-cards/${Uri.encodeComponent(cardId)}/share';
}
