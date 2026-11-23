import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/products/data/repositories/admin_product_repository_impl.dart';
import 'package:staka/features/manage/products/domain/models/product_page.dart';
import 'package:staka/features/manage/products/presentation/state/admin_products_controller.dart';
import 'package:staka/features/manage/products/presentation/state/admin_products_state.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

import '../../helpers/admin_product_fakes.dart';
import '../../helpers/product_fakes.dart';

void main() {
  test(
    'an older search answering late does not replace the newer one',
    () async {
      final answers = <String, Completer<Result<ProductPage>>>{
        '': Completer(),
        'tee': Completer(),
        'jeans': Completer(),
      };
      final container = ProviderContainer(
        overrides: [
          adminProductRepositoryProvider.overrideWith(
            (_, _) => FakeAdminProductRepository(
              pages: (request) => answers[request.filter.search]!.future,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        adminProductsControllerProvider(const AdminScope()),
        (_, _) {},
      );
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);
      final controller = container.read(
        adminProductsControllerProvider(const AdminScope()).notifier,
      );

      final slow = controller.search('tee');
      final fast = controller.search('jeans');
      answers['jeans']!.complete(
        Ok(pageOf([productNamed('Recycled Denim Jeans')])),
      );
      await fast;
      answers['tee']!.complete(
        Ok(pageOf([productNamed('Organic Cotton Tee')])),
      );
      answers['']!.complete(Ok(pageOf(const [])));
      await slow;

      final state = container.read(
        adminProductsControllerProvider(const AdminScope()),
      );
      expect(state.filter.search, 'jeans');
      final body = state.body as ProductListLoaded;
      expect(body.items.single.name, 'Recycled Denim Jeans');
    },
  );
}
