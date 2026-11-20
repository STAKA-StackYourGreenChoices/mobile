import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:staka/core/api_models/share_link_dto.dart';
import 'package:staka/core/utils/public_tag_url.dart';

/// `POST` / `DELETE /digital-cards/:id/share` on the API, and the story
/// image, which the website renders (`/t/<slug>/story`).
class ShareRemoteDataSource {
  const new(this._api, this._web);

  final Dio _api;

  /// A plain client: the website's public image needs no session.
  final Dio _web;

  Future<ShareLinkDto> share(String cardId) async {
    final response = await _api.post<Map<String, dynamic>>(_path(cardId));
    return ShareLinkDto.fromJson(response.data!);
  }

  Future<void> stopSharing(String cardId) => _api.delete<void>(_path(cardId));

  Future<Uint8List> fetchStoryImage(String slug) async {
    final response = await _web.get<List<int>>(
      storyImageUrl(slug),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  String _path(String cardId) =>
      '/digital-cards/${Uri.encodeComponent(cardId)}/share';
}
