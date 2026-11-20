import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/api_models/product_mapper.dart';
import 'package:staka/core/cards/cards_api.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/products/data/datasources/product_remote_data_source.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';
import 'package:staka/features/products/domain/repositories/product_repository.dart';

part 'product_repository_impl.g.dart';

@riverpod
ProductRepository productRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepositoryImpl(ProductRemoteDataSource(dio), CardsApi(dio));
}

class ProductRepositoryImpl implements ProductRepository {
  const new(this._products, this._cards);

  final ProductRemoteDataSource _products;
  final CardsApi _cards;

  /// Both requests at once, like the website's page.
  @override
  Future<Result<ProductLookup>> lookUp(String gtin) async {
    final (product, mine) = await (
      guardApi(() async => (await _products.fetchByGtin(gtin)).toDomain()),
      guardApi(_cards.fetchMine),
    ).wait;

    return switch ((product, mine)) {
      (Err(failure: BadRequestFailure(:final message)), _) => Ok(
        InvalidBarcode(message ?? ''),
      ),
      (Err(failure: NotFoundFailure()), _) => const Ok(UnknownProduct()),
      (Err(:final failure), _) || (_, Err(:final failure)) => Err(failure),
      (Ok(value: final Product found), Ok(value: final cards)) => Ok(
        ProductFound(
          found,
          ownedCardId: cards
              .where((card) => card.product.id == found.id)
              .firstOrNull
              ?.id,
        ),
      ),
    };
  }

  @override
  Future<Result<DigitalCard>> addToWardrobe(String gtin) =>
      guardApi(() async => (await _cards.create(gtin)).toDomain());
}
