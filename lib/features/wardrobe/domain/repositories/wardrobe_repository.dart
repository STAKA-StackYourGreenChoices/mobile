import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';

abstract interface class WardrobeRepository {
  /// The signed-in shopper's tags, newest first.
  Future<Result<List<DigitalCard>>> fetchMyCards();

  /// Emails a new confirmation link (it opens the website).
  Future<Result<ResendOutcome>> resendVerification();
}
