import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/presentation/state/tag_controller.dart';

part 'show_in_wardrobe_controller.g.dart';

/// "Show in my public wardrobe" on one tag (V2-3). The tag screen shows
/// the API's answer.
@riverpod
class ShowInWardrobeController extends _$ShowInWardrobeController {
  @override
  RequestState<void> build(String cardId) => const RequestIdle();

  Future<void> set({required bool show}) async {
    if (state is RequestSending) return;
    final repository = ref.read(tagRepositoryProvider);
    final tag = ref.read(tagControllerProvider(cardId).notifier);
    state = const RequestSending();
    final result = await repository.setShowInWardrobe(cardId, show: show);
    if (result case Ok(:final value)) tag.applyCard(value);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
