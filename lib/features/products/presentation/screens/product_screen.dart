import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';
import 'package:staka/features/products/presentation/state/add_to_wardrobe_controller.dart';
import 'package:staka/features/products/presentation/state/product_controller.dart';
import 'package:staka/features/products/presentation/state/product_state.dart';
import 'package:staka/features/products/presentation/widgets/ownership_action.dart';
import 'package:staka/features/products/presentation/widgets/product_found_view.dart';
import 'package:staka/features/products/presentation/widgets/product_not_found.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/products/[gtin]`, opened from Scan: the product's tag
/// and figures, and adding it to the wardrobe, which opens the new tag.
class ProductScreen extends ConsumerWidget {
  const new({required this.gtin, this.isScan = false, super.key});

  final String gtin;

  /// Opened from the Scan tab (`?scan=1`), not from a tag.
  final bool isScan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = productControllerProvider(gtin, isScan: isScan);
    final product = ref.watch(provider);
    final adding = ref.watch(addToWardrobeControllerProvider(gtin));

    void openTag(String cardId, {bool isNew = false}) => context.goNamed(
      AppRoute.tag.name,
      pathParameters: {'id': cardId},
      queryParameters: isNew ? const {'added': '1'} : const {},
    );

    ref.listen(addToWardrobeControllerProvider(gtin), (_, next) {
      if (next case RequestDone(value: final card)) {
        openTag(card.id, isNew: true);
      }
    });

    return AppScaffold(
      showAppBar: true,
      isScrollable: product is ProductReady,
      body: switch (product) {
        ProductLoading() => const AppLoader(),
        ProductError(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: ref.read(provider.notifier).retry,
        ),
        ProductReady(
          lookup: ProductFound(:final product, :final ownedCardId),
        ) =>
          ProductFoundView(
            product: product,
            action: OwnershipAction(
              onViewTagPressed: switch (ownedCardId) {
                final id? => () => openTag(id),
                null => null,
              },
              onAddPressed: ref
                  .read(addToWardrobeControllerProvider(gtin).notifier)
                  .add,
              isAdding: adding is RequestSending,
              errorMessage: switch (adding) {
                RequestFailed(:final failure) => messageForFailure(
                  failure,
                  l10n,
                ),
                _ => null,
              },
            ),
          ),
        ProductReady(:final lookup) => ProductNotFound(
          lookup: lookup,
          gtin: gtin,
          onScanAgainPressed: context.pop,
        ),
      },
    );
  }
}
