import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/share_link.dart';

/// The shopper's whole-wardrobe link (V2-3).
abstract interface class WardrobeShareRepository {
  /// The live link, or null when the wardrobe isn't shared.
  Future<Result<ShareLink?>> fetchShare();

  /// Creates (or returns) the link. `ForbiddenFailure` until the shopper
  /// has at least one verified piece.
  Future<Result<ShareLink>> share();

  /// Turns the link off for good; sharing again issues a new one.
  Future<Result<void>> stopSharing();
}
