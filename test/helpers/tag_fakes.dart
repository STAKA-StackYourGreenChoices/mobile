import 'dart:typed_data';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';
import 'package:staka/features/tags/domain/repositories/tag_repository.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';

/// Serves tags by id (anything else is "not in your wardrobe") and answers
/// order matches and receipt uploads from scripts.
class FakeTagRepository implements TagRepository {
  new({
    List<DigitalCard> cards = const [],
    List<Result<Ownership>> matches = const [],
    List<Result<Ownership>> uploads = const [],
  }) : _cards = {for (final card in cards) card.id: card},
       _matches = [...matches],
       _uploads = [...uploads];

  final Map<String, DigitalCard> _cards;
  final List<Result<Ownership>> _matches;
  final List<Result<Ownership>> _uploads;
  final List<PickedReceipt> uploaded = [];

  @override
  Future<Result<DigitalCard>> fetchTag(String cardId) async =>
      switch (_cards[cardId]) {
        final card? => Ok(card),
        null => const Err(NotFoundFailure([])),
      };

  @override
  Future<Result<Ownership>> matchOrder(String cardId) async =>
      _matches.removeAt(0);

  @override
  Future<Result<Ownership>> uploadReceipt(
    String cardId,
    PickedReceipt receipt,
  ) async {
    uploaded.add(receipt);
    return _uploads.removeAt(0);
  }
}

/// Hands back [receipt] whatever source is chosen (null: "cancelled").
class FakeReceiptPicker implements ReceiptPicker {
  new([this.receipt]);

  final PickedReceipt? receipt;
  final List<ReceiptSource> asked = [];

  @override
  Future<PickedReceipt?> pick(ReceiptSource source) async {
    asked.add(source);
    return receipt;
  }
}

PickedReceipt receiptOf(int sizeBytes, {String name = 'receipt.jpg'}) =>
    PickedReceipt(name: name, bytes: Uint8List(sizeBytes));
