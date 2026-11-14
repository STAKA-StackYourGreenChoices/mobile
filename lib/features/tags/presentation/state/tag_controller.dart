import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/cards/cards_revision.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/presentation/state/tag_state.dart';

part 'tag_controller.g.dart';

/// One of the shopper's tags, kept up to date as they prove ownership.
@riverpod
class TagController extends _$TagController {
  @override
  TagState build(String cardId) {
    unawaited(Future.microtask(_load));
    return const TagLoading();
  }

  Future<void> retry() async {
    state = const TagLoading();
    await _load();
  }

  /// An ownership claim succeeded: show the API's new summary here and let
  /// the wardrobe regroup the tag.
  void applyOwnership(Ownership ownership) {
    if (state case TagReady(:final card)) {
      state = TagReady(card.copyWith(ownership: ownership));
    }
    ref.read(cardsRevisionProvider.notifier).bump();
  }

  Future<void> _load() async {
    final result = await ref.read(tagRepositoryProvider).fetchTag(cardId);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => TagReady(value),
      Err(failure: NotFoundFailure()) => const TagMissing(),
      Err(:final failure) => TagError(failure),
    };
  }
}
