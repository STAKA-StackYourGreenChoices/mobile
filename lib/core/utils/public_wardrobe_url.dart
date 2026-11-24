import 'package:staka/core/config/env.dart';

/// The public address of a shared wardrobe: `<website>/w/<slug>` (V2-3),
/// the page anyone with the link can open without signing in.
String publicWardrobeUrl(String slug, {String webAppUrl = Env.webAppUrl}) =>
    '${webAppUrl.replaceAll(RegExp(r'/+$'), '')}/w/${Uri.encodeComponent(slug)}';
