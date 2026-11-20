import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cards_revision.g.dart';

/// Goes up whenever the shopper's tags change (added, proven, shared), so
/// screens that list them reload. Features can't import each other, so the
/// one that changes a tag bumps this and the wardrobe listens.
@Riverpod(keepAlive: true)
class CardsRevision extends _$CardsRevision {
  @override
  int build() => 0;

  void bump() => state++;
}
