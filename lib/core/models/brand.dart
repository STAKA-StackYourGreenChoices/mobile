import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';

/// The company that made a product.
@freezed
abstract class Brand with _$Brand {
  const factory({
    required String id,
    required String name,
    String? description,
    String? logoUrl,
  }) = _Brand;
}
