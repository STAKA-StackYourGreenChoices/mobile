import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/digital_card.dart';

/// The Wardrobe tab's four states (guide §4.3).
sealed class WardrobeState {
  const new();

  /// Empty, or split like the website into proven and waiting pieces.
  factory fromCards(List<DigitalCard> cards) => cards.isEmpty
      ? const WardrobeEmpty()
      : WardrobeData(
          verified: [
            for (final card in cards)
              if (card.ownership.isVerified) card,
          ],
          waiting: [
            for (final card in cards)
              if (!card.ownership.isVerified) card,
          ],
        );
}

final class WardrobeLoading extends WardrobeState {
  const new();
}

final class WardrobeEmpty extends WardrobeState {
  const new();
}

final class WardrobeData extends WardrobeState {
  const new({
    required this.verified,
    required this.waiting,
    this.refreshFailure,
  });

  final List<DigitalCard> verified;
  final List<DigitalCard> waiting;

  /// A pull-to-refresh that failed: the tags stay, the screen says why.
  final Failure? refreshFailure;

  int get total => verified.length + waiting.length;
}

final class WardrobeError extends WardrobeState {
  const new(this.failure);

  final Failure failure;
}
