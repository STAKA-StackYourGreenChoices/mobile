import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/digital_card.dart';

/// The tag screen's states (guide §4.3); "empty" is a tag that isn't (or
/// is no longer) in this shopper's wardrobe.
sealed class TagState {
  const new();
}

final class TagLoading extends TagState {
  const new();
}

final class TagReady extends TagState {
  const new(this.card);

  final DigitalCard card;
}

final class TagMissing extends TagState {
  const new();
}

final class TagError extends TagState {
  const new(this.failure);

  final Failure failure;
}
