import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'package:staka/features/wardrobe/presentation/state/wardrobe_state.dart';

part 'wardrobe_controller.g.dart';

@riverpod
class WardrobeController extends _$WardrobeController {
  @override
  WardrobeState build() {
    unawaited(Future.microtask(_load));
    return const WardrobeLoading();
  }

  /// After a failed first load.
  Future<void> retry() async {
    state = const WardrobeLoading();
    await _load();
  }

  /// Pull to refresh: also re-reads the user, so a confirmed email clears
  /// the banner. Tags already shown stay if the refresh fails.
  Future<void> refresh() async {
    final session = ref.read(sessionControllerProvider.notifier);
    final result = await ref.read(wardrobeRepositoryProvider).fetchMyCards();
    await session.refreshUser();
    if (!ref.mounted) return;
    state = switch ((result, state)) {
      (Ok(:final value), _) => WardrobeState.fromCards(value),
      (Err(:final failure), final WardrobeData shown) => WardrobeData(
        verified: shown.verified,
        waiting: shown.waiting,
        refreshFailure: failure,
      ),
      (Err(:final failure), _) => WardrobeError(failure),
    };
  }

  Future<void> _load() async {
    final result = await ref.read(wardrobeRepositoryProvider).fetchMyCards();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => WardrobeState.fromCards(value),
      Err(:final failure) => WardrobeError(failure),
    };
  }
}
