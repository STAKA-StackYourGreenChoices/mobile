import 'package:staka/core/config/env.dart';

/// The public address of a shared tag: `<website>/t/<slug>`, the page the
/// website serves to anyone with the link (no sign-in).
String publicTagUrl(String slug, {String webAppUrl = Env.webAppUrl}) =>
    '${webAppUrl.replaceAll(RegExp(r'/+$'), '')}/t/${Uri.encodeComponent(slug)}';

/// The 1080 × 1920 image the website renders for Instagram stories.
String storyImageUrl(String slug, {String webAppUrl = Env.webAppUrl}) =>
    '${publicTagUrl(slug, webAppUrl: webAppUrl)}/story';
