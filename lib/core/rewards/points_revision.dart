import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'points_revision.g.dart';

/// Goes up when points may have changed (a reward redeemed, a phone
/// verified...), so the Rewards tab reloads its balance (V2-6). Tag changes
/// already reload it through `cardsRevisionProvider`.
@Riverpod(keepAlive: true)
class PointsRevision extends _$PointsRevision {
  @override
  int build() => 0;

  void bump() => state++;
}
