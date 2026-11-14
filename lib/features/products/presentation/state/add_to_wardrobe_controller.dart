import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/cards/cards_revision.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/products/data/repositories/product_repository_impl.dart';

part 'add_to_wardrobe_controller.g.dart';

/// "Add to my wardrobe" for one product. On success the screen opens the
/// new tag, and the wardrobe is told to reload.
@riverpod
class AddToWardrobeController extends _$AddToWardrobeController {
  @override
  RequestState<DigitalCard> build(String gtin) => const RequestIdle();

  Future<void> add() async {
    if (state is RequestSending) return;
    final revision = ref.read(cardsRevisionProvider.notifier);
    state = const RequestSending();
    final result = await ref
        .read(productRepositoryProvider)
        .addToWardrobe(gtin);
    if (result is Ok<DigitalCard>) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}
