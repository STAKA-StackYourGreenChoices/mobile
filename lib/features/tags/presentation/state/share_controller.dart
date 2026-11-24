import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/presentation/state/tag_controller.dart';

part 'share_controller.g.dart';

/// What the share panel is busy with, one thing at a time.
enum ShareBusy { none, creating, stopping }

/// The last outcome the panel should tell the shopper about.
enum ShareOutcome { none, created, stopped }

@immutable
class ShareState {
  const new({
    this.busy = ShareBusy.none,
    this.outcome = ShareOutcome.none,
    this.failure,
  });

  final ShareBusy busy;
  final ShareOutcome outcome;
  final Failure? failure;
}

/// Creating and stopping a tag's public link. The channels and images are
/// `ShareChannelsController` (core/sharing, V2-4).
@riverpod
class ShareController extends _$ShareController {
  @override
  ShareState build(String cardId) => const ShareState();

  Future<void> create() async {
    if (state.busy != ShareBusy.none) return;
    final tag = ref.read(tagControllerProvider(cardId).notifier);
    state = const ShareState(busy: ShareBusy.creating);
    final result = await ref.read(tagRepositoryProvider).share(cardId);
    if (result case Ok(:final value)) tag.applyShare(value);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const ShareState(outcome: ShareOutcome.created),
      Err(:final failure) => ShareState(failure: failure),
    };
  }

  Future<void> stop() async {
    if (state.busy != ShareBusy.none) return;
    final tag = ref.read(tagControllerProvider(cardId).notifier);
    state = const ShareState(busy: ShareBusy.stopping);
    final result = await ref.read(tagRepositoryProvider).stopSharing(cardId);
    if (result is Ok<void>) tag.applyShare(null);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const ShareState(outcome: ShareOutcome.stopped),
      Err(:final failure) => ShareState(failure: failure),
    };
  }
}
