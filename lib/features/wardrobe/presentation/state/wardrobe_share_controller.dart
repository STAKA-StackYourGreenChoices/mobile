import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/share_link.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_share_repository_impl.dart';
import 'package:staka/features/wardrobe/domain/repositories/wardrobe_share_repository.dart';

part 'wardrobe_share_controller.g.dart';

enum WardrobeShareBusy { none, creating, stopping }

/// What just happened, for a one-off snackbar.
enum WardrobeShareOutcome { none, created, stopped }

/// The share screen's states (V2-3).
sealed class WardrobeShareState {
  const new();
}

final class WardrobeShareLoading extends WardrobeShareState {
  const new();
}

final class WardrobeShareLoadFailed extends WardrobeShareState {
  const new(this.failure);

  final Failure failure;
}

/// [share] is null while the wardrobe isn't shared. [failure] is the last
/// create or stop that the API refused.
final class WardrobeShareReady extends WardrobeShareState {
  const new({
    this.share,
    this.busy = WardrobeShareBusy.none,
    this.failure,
    this.outcome = WardrobeShareOutcome.none,
  });

  final ShareLink? share;
  final WardrobeShareBusy busy;
  final Failure? failure;
  final WardrobeShareOutcome outcome;
}

/// The whole-wardrobe link: load it, create it, stop it.
@riverpod
class WardrobeShareController extends _$WardrobeShareController {
  @override
  WardrobeShareState build() {
    unawaited(Future.microtask(_load));
    return const WardrobeShareLoading();
  }

  Future<void> retry() async {
    state = const WardrobeShareLoading();
    await _load();
  }

  Future<void> create() => _change(
    WardrobeShareBusy.creating,
    (repository) => repository.share(),
    WardrobeShareOutcome.created,
  );

  Future<void> stop() => _change(
    WardrobeShareBusy.stopping,
    (repository) async => switch (await repository.stopSharing()) {
      Ok() => const Ok<ShareLink?>(null),
      Err(:final failure) => Err<ShareLink?>(failure),
    },
    WardrobeShareOutcome.stopped,
  );

  Future<void> _change(
    WardrobeShareBusy busy,
    Future<Result<ShareLink?>> Function(WardrobeShareRepository repository)
    call,
    WardrobeShareOutcome outcome,
  ) async {
    if (state case WardrobeShareReady(
      :final share,
      busy: WardrobeShareBusy.none,
    )) {
      final repository = ref.read(wardrobeShareRepositoryProvider);
      state = WardrobeShareReady(share: share, busy: busy);
      final result = await call(repository);
      if (!ref.mounted) return;
      state = switch (result) {
        Ok(:final value) => WardrobeShareReady(share: value, outcome: outcome),
        Err(:final failure) => WardrobeShareReady(
          share: share,
          failure: failure,
        ),
      };
    }
  }

  Future<void> _load() async {
    final result = await ref.read(wardrobeShareRepositoryProvider).fetchShare();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => WardrobeShareReady(share: value),
      Err(:final failure) => WardrobeShareLoadFailed(failure),
    };
  }
}
