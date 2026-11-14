import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/tags/presentation/state/order_match_controller.dart';
import 'package:staka/features/tags/presentation/state/receipt_controller.dart';
import 'package:staka/features/tags/presentation/state/tag_controller.dart';
import 'package:staka/features/tags/presentation/state/tag_state.dart';
import 'package:staka/features/tags/presentation/widgets/order_match_option.dart';
import 'package:staka/features/tags/presentation/widgets/ownership_panel.dart';
import 'package:staka/features/tags/presentation/widgets/receipt_option.dart';
import 'package:staka/features/tags/presentation/widgets/receipt_source_sheet.dart';
import 'package:staka/features/tags/presentation/widgets/tag_view.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// One of the shopper's tags (the website's `/tags/[id]`): the tag, and
/// proving ownership by order or receipt. Sharing joins in the next slice.
class TagScreen extends ConsumerWidget {
  const new({required this.cardId, this.isJustAdded = false, super.key});

  final String cardId;
  final bool isJustAdded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tag = ref.watch(tagControllerProvider(cardId));

    ref
      ..listen(orderMatchControllerProvider(cardId), (_, next) {
        if (next is RequestDone) {
          AppSnackbar.show(context, message: l10n.orderMatched);
        }
      })
      ..listen(receiptControllerProvider(cardId), (_, next) {
        if (next.request is RequestDone) {
          AppSnackbar.show(context, message: l10n.receiptSent);
        }
      });

    return AppScaffold(
      showAppBar: true,
      isScrollable: tag is TagReady,
      body: switch (tag) {
        TagLoading() => const AppLoader(),
        TagError(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: ref
              .read(tagControllerProvider(cardId).notifier)
              .retry,
        ),
        TagMissing() => AppEmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.tagMissingTitle,
          message: l10n.tagMissingBody,
          actionLabel: l10n.wardrobeTitle,
          onActionPressed: () => context.goNamed(AppRoute.wardrobe.name),
        ),
        TagReady(:final card) => TagView(
          card: card,
          isJustAdded: isJustAdded,
          ownershipPanel: OwnershipPanel(
            ownership: card.ownership,
            proveOptions: [
              _OrderOption(cardId: cardId),
              _ReceiptOption(card: card),
            ],
          ),
          onScanAnotherPressed: () => context.goNamed(AppRoute.scan.name),
          onProductDetailsPressed: () => context.goNamed(
            AppRoute.product.name,
            pathParameters: {'gtin': card.product.gtin},
          ),
        ),
      },
    );
  }
}

/// Connects "Find it in my orders" to its request.
class _OrderOption extends ConsumerWidget {
  const new({required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(orderMatchControllerProvider(cardId));
    return OrderMatchOption(
      isChecking: request is RequestSending,
      errorMessage: switch (request) {
        RequestFailed(failure: NotFoundFailure()) => l10n.orderNotFound,
        RequestFailed(:final failure) => messageForFailure(failure, l10n),
        _ => null,
      },
      onFindPressed: ref
          .read(orderMatchControllerProvider(cardId).notifier)
          .check,
    );
  }
}

/// Connects "Upload a receipt" to the picker and the upload.
class _ReceiptOption extends ConsumerWidget {
  const new({required this.card});

  final DigitalCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final receipt = ref.watch(receiptControllerProvider(card.id));
    final controller = ref.read(receiptControllerProvider(card.id).notifier);
    final failure = switch (receipt.request) {
      RequestFailed(:final failure) => failure,
      _ => null,
    };
    return ReceiptOption(
      uploadsLeft: card.ownership.receiptAttemptsLeft,
      file: receipt.file,
      isSending: receipt.request is RequestSending,
      // The API's reason for a rejected file belongs on the file.
      fileError: failure is BadRequestFailure
          ? messageForFailure(failure, l10n)
          : null,
      alertMessage: failure == null || failure is BadRequestFailure
          ? null
          : messageForFailure(failure, l10n),
      onChoosePressed: () async {
        final source = await showReceiptSourceSheet(context);
        if (source != null) await controller.choose(source);
      },
      onSendPressed: controller.send,
    );
  }
}
