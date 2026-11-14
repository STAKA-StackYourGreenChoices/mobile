import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/presentation/state/tag_controller.dart';

part 'order_match_controller.g.dart';

/// "Find it in my orders" for one tag.
@riverpod
class OrderMatchController extends _$OrderMatchController {
  @override
  RequestState<Ownership> build(String cardId) => const RequestIdle();

  Future<void> check() async {
    if (state is RequestSending) return;
    final tag = ref.read(tagControllerProvider(cardId).notifier);
    state = const RequestSending();
    final result = await ref.read(tagRepositoryProvider).matchOrder(cardId);
    if (result case Ok(:final value)) tag.applyOwnership(value);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
