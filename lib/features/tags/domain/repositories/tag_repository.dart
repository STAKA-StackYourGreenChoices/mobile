import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';

abstract interface class TagRepository {
  /// One of the shopper's tags. `NotFoundFailure` if it isn't theirs.
  Future<Result<DigitalCard>> fetchTag(String cardId);

  /// Looks for a paid order that includes this piece. `NotFoundFailure`
  /// means there is none.
  Future<Result<Ownership>> matchOrder(String cardId);

  /// Sends a receipt for an admin to review. `BadRequestFailure` (type or
  /// size), `ForbiddenFailure` (all 5 used) and `ConflictFailure` (already
  /// verified or under review) carry the API's reason.
  Future<Result<Ownership>> uploadReceipt(String cardId, PickedReceipt receipt);
}
