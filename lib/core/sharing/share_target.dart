import 'package:flutter/foundation.dart';

import 'package:staka/core/config/env.dart';
import 'package:staka/core/utils/public_tag_url.dart';
import 'package:staka/core/utils/public_wardrobe_url.dart';

/// Where a share link points, with `?ch=` telling the API which button
/// was used (V2-4). The API's names are fixed: keep [apiName] as is.
enum ShareChannel {
  whatsapp('whatsapp'),
  instagram('instagram'),
  facebook('facebook'),
  x('x'),
  linkedin('linkedin'),
  copy('copy'),
  qr('qr'),
  embed('embed'),
  other('other');

  new(this.apiName);

  final String apiName;
}

/// The images the website renders for a shared tag or wardrobe (V2-4):
/// 9:16 for stories, 1:1 for feed posts.
enum ShareImageFormat {
  story('story'),
  square('square');

  new(this.path);

  /// The last part of the image's address on the website.
  final String path;
}

enum ShareKind { tag, wardrobe }

/// A shared tag (`/t/<slug>`) or wardrobe (`/w/<slug>`).
@immutable
final class ShareTarget {
  const new({
    required this.kind,
    required this.slug,
    this.cardId,
    this.webAppUrl = Env.webAppUrl,
  });

  final ShareKind kind;
  final String slug;

  /// The tag's card, sent with the share event; null for a wardrobe.
  final String? cardId;
  final String webAppUrl;

  /// The public page, without a channel.
  String get url => switch (kind) {
    ShareKind.tag => publicTagUrl(slug, webAppUrl: webAppUrl),
    ShareKind.wardrobe => publicWardrobeUrl(slug, webAppUrl: webAppUrl),
  };

  /// The public page as shared through [channel].
  String linkFor(ShareChannel channel) {
    final uri = Uri.parse(url);
    return uri
        .replace(
          queryParameters: {...uri.queryParameters, 'ch': channel.apiName},
        )
        .toString();
  }

  String imageUrl(ShareImageFormat format) => '$url/${format.path}';

  String imageFileName(ShareImageFormat format) =>
      'staka-$slug-${format.path}.png';

  String get qrFileName => 'staka-$slug-qr.png';

  @override
  bool operator ==(Object other) =>
      other is ShareTarget &&
      other.kind == kind &&
      other.slug == slug &&
      other.cardId == cardId &&
      other.webAppUrl == webAppUrl;

  @override
  int get hashCode => Object.hash(kind, slug, cardId, webAppUrl);
}
