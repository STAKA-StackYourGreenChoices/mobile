import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/presentation/state/tag_controller.dart';
import 'package:staka/features/tags/presentation/state/tag_state.dart';

part 'look_again_controller.g.dart';

/// "Ask STAKA to look again" for one tag. Once sent, the tag shows the
/// request as open until STAKA answers.
@riverpod
class LookAgainController extends _$LookAgainController {
  /// What the API accepts, after trimming.
  static const minLength = 10;
  static const maxLength = 1000;

  @override
  RequestState<void> build(String cardId) => const RequestIdle();

  Future<void> send(String message) async {
    if (state is RequestSending) return;
    final tag = ref.read(tagControllerProvider(cardId).notifier);
    state = const RequestSending();
    final result = await ref
        .read(tagRepositoryProvider)
        .askToLookAgain(cardId, message.trim());
    if (result is Ok) {
      if (ref.read(tagControllerProvider(cardId)) case TagReady(:final card)) {
        tag.applyOwnership(
          card.ownership.copyWith(
            dispute: const OwnershipDispute(status: DisputeStatus.open),
          ),
        );
      }
    }
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }

  void reset() => state = const RequestIdle();
}
