import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/product_variant.dart';

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

  /// The kinds of piece the shopper has, in the app's order (V2-2).
  List<ProductCategory> get categories {
    final present = {
      for (final card in [...verified, ...waiting]) card.product.category,
    };
    return [
      for (final category in ProductCategory.values)
        if (present.contains(category)) category,
    ];
  }

  /// Only the pieces of [category]; everything when it is null.
  WardrobeData only(ProductCategory? category) => category == null
      ? this
      : WardrobeData(
          verified: [
            for (final card in verified)
              if (card.product.category == category) card,
          ],
          waiting: [
            for (final card in waiting)
              if (card.product.category == category) card,
          ],
          refreshFailure: refreshFailure,
        );
}

final class WardrobeError extends WardrobeState {
  const new(this.failure);

  final Failure failure;
}
