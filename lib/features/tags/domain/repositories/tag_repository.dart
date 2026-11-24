import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';

abstract interface class TagRepository {
  /// One of the shopper's tags. `NotFoundFailure` if it isn't theirs.
  Future<Result<DigitalCard>> fetchTag(String cardId);

  /// Shows the piece on the public wardrobe page, or hides it (V2-3).
  Future<Result<DigitalCard>> setShowInWardrobe(
    String cardId, {
    required bool show,
  });

  /// Looks for a paid order that includes this piece. `NotFoundFailure`
  /// means there is none.
  Future<Result<Ownership>> matchOrder(String cardId);

  /// Sends a receipt for an admin to review. `BadRequestFailure` (type or
  /// size), `ForbiddenFailure` (all 5 used) and `ConflictFailure` (already
  /// verified or under review) carry the API's reason.
  Future<Result<Ownership>> uploadReceipt(String cardId, PickedReceipt receipt);

  /// Asks STAKA to look again at the brand's rejection of the latest
  /// receipt ([message] is 10–1000 characters). Once per claim:
  /// `ConflictFailure` if it was already asked.
  Future<Result<void>> askToLookAgain(String cardId, String message);

  /// Creates (or returns) the public link. `ConflictFailure` until the
  /// shopper is the verified owner.
  Future<Result<ShareLink>> share(String cardId);

  /// Turns the link off for good; sharing again issues a new one.
  Future<Result<void>> stopSharing(String cardId);
}
