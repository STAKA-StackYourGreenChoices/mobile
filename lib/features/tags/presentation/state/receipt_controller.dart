import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/tags/data/repositories/tag_repository_impl.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';
import 'package:staka/features/tags/presentation/state/tag_controller.dart';

part 'receipt_controller.g.dart';

/// The chosen receipt and what happened when it was sent.
@immutable
class ReceiptState {
  const new({this.file, this.request = const RequestIdle()});

  final PickedReceipt? file;
  final RequestState<Ownership> request;

  /// A file is chosen, small enough, and not already on its way.
  bool get canSend => switch (file) {
    final file? => !file.isTooLarge && request is! RequestSending,
    null => false,
  };
}

/// "Upload a receipt" for one tag.
@riverpod
class ReceiptController extends _$ReceiptController {
  @override
  ReceiptState build(String cardId) => const ReceiptState();

  Future<void> choose(ReceiptSource source) async {
    final picked = await ref.read(receiptPickerProvider).pick(source);
    if (picked == null || !ref.mounted) return;
    state = ReceiptState(file: picked);
  }

  Future<void> send() async {
    final file = state.file;
    if (file == null || !state.canSend) return;
    final tag = ref.read(tagControllerProvider(cardId).notifier);
    state = ReceiptState(file: file, request: const RequestSending());
    final result = await ref
        .read(tagRepositoryProvider)
        .uploadReceipt(cardId, file);
    if (result case Ok(:final value)) tag.applyOwnership(value);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => ReceiptState(request: RequestDone(value)),
      Err(:final failure) => ReceiptState(
        file: file,
        request: RequestFailed(failure),
      ),
    };
  }
}
