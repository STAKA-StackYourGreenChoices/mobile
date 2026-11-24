import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/products/domain/models/sku_alias.dart';
import 'package:staka/features/manage/products/domain/repositories/admin_product_repository.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'sku_alias_controller.g.dart';

/// Adds or removes another shop's code on one saved size/colour (V2-2).
/// The sheet keeps the list; each call says whether it went through.
@riverpod
class SkuAliasController extends _$SkuAliasController {
  @override
  RequestState<void> build(
    ManageScope scope,
    String productId,
    String variantId,
  ) => const RequestIdle();

  Future<bool> add(SkuAlias alias) =>
      _send((repository) => repository.addAlias(productId, variantId, alias));

  Future<bool> remove(SkuAlias alias) => _send(
    (repository) => repository.removeAlias(productId, variantId, alias),
  );

  Future<bool> _send(
    Future<Result<void>> Function(AdminProductRepository repository) call,
  ) async {
    if (state is RequestSending) return false;
    final repository = ref.read(adminProductRepositoryProvider(scope));
    state = const RequestSending();
    final result = await call(repository);
    if (!ref.mounted) return result is Ok;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
    return result is Ok;
  }
}
