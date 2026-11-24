import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/core/sharing/share_actions.dart';
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
    List<Result<ShareLink>> shares = const [],
    List<Result<void>> stops = const [],
    List<Result<Uint8List>> images = const [],
    List<Result<void>> lookAgains = const [],
    List<Failure> wardrobeToggleFailures = const [],
  }) : _cards = {for (final card in cards) card.id: card},
       _matches = [...matches],
       _uploads = [...uploads],
       _shares = [...shares],
       _stops = [...stops],
       _images = [...images],
       _lookAgains = [...lookAgains],
       _toggleFailures = [...wardrobeToggleFailures];

  final Map<String, DigitalCard> _cards;
  final List<Result<Ownership>> _matches;
  final List<Result<Ownership>> _uploads;
  final List<Result<ShareLink>> _shares;
  final List<Result<void>> _stops;
  final List<Result<Uint8List>> _images;
  final List<Result<void>> _lookAgains;
  final List<Failure> _toggleFailures;

  /// Each "Show in my public wardrobe" change sent, in order.
  final List<bool> wardrobeToggles = [];
  final List<PickedReceipt> uploaded = [];

  /// Messages sent with "Ask STAKA to look again".
  final List<String> lookAgainMessages = [];

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

  @override
  Future<Result<void>> askToLookAgain(String cardId, String message) async {
    lookAgainMessages.add(message);
    return _lookAgains.removeAt(0);
  }

  @override
  Future<Result<ShareLink>> share(String cardId) async => _shares.removeAt(0);

  @override
  Future<Result<void>> stopSharing(String cardId) async => _stops.removeAt(0);

  @override
  Future<Result<Uint8List>> fetchStoryImage(String slug) async =>
      _images.removeAt(0);

  /// Answers with the stored card changed, unless a failure is scripted.
  @override
  Future<Result<DigitalCard>> setShowInWardrobe(
    String cardId, {
    required bool show,
  }) async {
    wardrobeToggles.add(show);
    if (_toggleFailures.isNotEmpty) return Err(_toggleFailures.removeAt(0));
    final card = _cards[cardId]!.copyWith(showInWardrobe: show);
    _cards[cardId] = card;
    return Ok(card);
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

/// Records what would have gone to the clipboard, share sheet and browser.
class FakeShareActions implements ShareActions {
  new({this.canOpen = true});

  final bool canOpen;
  final List<String> copied = [];
  final List<String> sharedTexts = [];
  final List<String> sharedImages = [];
  final List<({String fileName, String mimeType, String text})> sharedFiles =
      [];
  final List<String> opened = [];

  @override
  Future<void> copy(String text) async => copied.add(text);

  @override
  Future<void> shareLink({
    required String url,
    required String text,
    required String subject,
    Rect? origin,
  }) async => sharedTexts.add('$text $url');

  @override
  Future<void> shareImage({
    required Uint8List png,
    required String fileName,
    required String text,
    Rect? origin,
  }) async => sharedImages.add(fileName);

  @override
  Future<void> shareFile({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    Rect? origin,
  }) async => sharedFiles.add((
    fileName: fileName,
    mimeType: mimeType,
    text: utf8.decode(bytes),
  ));

  @override
  Future<bool> open(String url) async {
    opened.add(url);
    return canOpen;
  }
}
