import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/sharing/share_target.dart';

part 'share_image_api.g.dart';

@riverpod
ShareImageApi shareImageApi(Ref ref) =>
    // Not built here: this provider is disposed as soon as a read finishes,
    // and a client of its own would be closed mid-download.
    ShareImageApi(ref.watch(webDioProvider));

/// Downloads the images the website renders for a share (V2-4):
/// `/t/<slug>/story|square` and `/w/<slug>/story|square`. Public, so no
/// session.
class ShareImageApi {
  const new(this._web);

  final Dio _web;

  Future<Result<Uint8List>> fetch(
    ShareTarget target,
    ShareImageFormat format,
  ) => guardApi(() async {
    final response = await _web.get<List<int>>(
      target.imageUrl(format),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  });
}
