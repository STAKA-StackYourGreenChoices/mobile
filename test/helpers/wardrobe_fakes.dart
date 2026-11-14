import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/wardrobe/domain/models/resend_outcome.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_repository.dart';

/// Answers from scripts. The last scripted answer repeats, so refreshes
/// keep working; with no script the wardrobe is empty.
class FakeWardrobeRepository implements WardrobeRepository {
  new({
    List<Result<List<DigitalCard>>> cards = const [Ok([])],
    List<Result<ResendOutcome>> resends = const [],
  }) : _cards = [...cards],
       _resends = [...resends];

  final List<Result<List<DigitalCard>>> _cards;
  final List<Result<ResendOutcome>> _resends;
  int fetches = 0;

  @override
  Future<Result<List<DigitalCard>>> fetchMyCards() async {
    fetches++;
    return _cards.length > 1 ? _cards.removeAt(0) : _cards.first;
  }

  @override
  Future<Result<ResendOutcome>> resendVerification() async =>
      _resends.removeAt(0);
}

final _date = DateTime.utc(2026, 11, 14);

DigitalCard cardFor({
  required String id,
  required String name,
  OwnershipStatus status = OwnershipStatus.unverified,
  bool hasFigures = true,
  Ownership? ownership,
}) => DigitalCard(
  id: id,
  createdAt: _date,
  ownerName: 'Ada Lovelace',
  product: Product(
    id: 'p-$id',
    gtin: '0890123450001$id',
    sku: 'SKU-$id',
    name: name,
    brand: const Brand(id: 'b1', name: 'Terra Threads'),
    createdAt: _date,
    updatedAt: _date,
    sustainabilityInfo: hasFigures
        ? const SustainabilityInfo(
            carbonScoreGrams: 2100,
            recyclabilityPercent: 80,
            isVerified: true,
            certifierName: 'GOTS',
          )
        : null,
  ),
  ownership:
      ownership ??
      Ownership(status: status, receiptAttemptsUsed: 0, receiptAttemptsLeft: 5),
);
