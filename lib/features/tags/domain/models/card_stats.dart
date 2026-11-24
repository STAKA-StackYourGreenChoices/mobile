import 'package:flutter/foundation.dart';

import 'package:staka/core/sharing/share_target.dart';

/// How a shared tag's link is doing, `GET /me/cards/:id/stats` (V2-5).
@immutable
class CardStats {
  const new({
    required this.views,
    required this.viewsByChannel,
    required this.clicks,
  });

  /// `{views, viewsByChannel: {channel: n}, clicks}`; a channel the app
  /// doesn't know (or none) counts as [ShareChannel.other].
  factory fromJson(Map<String, dynamic> json) {
    final byChannel = <ShareChannel, int>{};
    final raw = json['viewsByChannel'] as Map<String, dynamic>? ?? const {};
    for (final MapEntry(:key, :value) in raw.entries) {
      final channel =
          ShareChannel.values.where((c) => c.apiName == key).firstOrNull ??
          ShareChannel.other;
      byChannel[channel] =
          (byChannel[channel] ?? 0) + ((value as num?)?.toInt() ?? 0);
    }
    return CardStats(
      views: (json['views'] as num?)?.toInt() ?? 0,
      viewsByChannel: byChannel,
      clicks: (json['clicks'] as num?)?.toInt() ?? 0,
    );
  }

  final int views;
  final Map<ShareChannel, int> viewsByChannel;

  /// Taps from the public page through to the brand's shop.
  final int clicks;

  /// Channels with views, most first.
  List<(ShareChannel, int)> get channelsByViews => [
    for (final MapEntry(:key, :value) in viewsByChannel.entries)
      if (value > 0) (key, value),
  ]..sort((a, b) => b.$2.compareTo(a.$2));
}
