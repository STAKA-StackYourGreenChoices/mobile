import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/features/products/domain/models/product_lookup.dart';
import 'package:staka/features/products/domain/repositories/product_repository.dart';

/// Answers lookups by GTIN (anything unscripted is "not on STAKA yet") and
/// "add to wardrobe" from a script, recording what was added.
class FakeProductRepository implements ProductRepository {
  new({
    Map<String, Result<ProductLookup>> lookups = const {},
    List<Result<DigitalCard>> adds = const [],
  }) : _lookups = {...lookups},
       _adds = [...adds];

  final Map<String, Result<ProductLookup>> _lookups;
  final List<Result<DigitalCard>> _adds;
  final List<String> added = [];

  @override
  Future<Result<ProductLookup>> lookUp(String gtin) async =>
      _lookups[gtin] ?? const Ok(UnknownProduct());

  @override
  Future<Result<DigitalCard>> addToWardrobe(String gtin) async {
    added.add(gtin);
    return _adds.removeAt(0);
  }
}

final _date = DateTime.utc(2026, 11, 14);

Product productNamed(
  String name, {
  String gtin = '08901234500019',
  String? brandDescription,
  SustainabilityInfo? info = const SustainabilityInfo(
    carbonScoreGrams: 2100,
    recyclabilityPercent: 80,
    isVerified: true,
    certifierName: 'Global Organic Textile Standard',
  ),
}) => Product(
  id: 'p-$gtin',
  gtin: gtin,
  sku: 'SKU-$gtin',
  name: name,
  brand: Brand(id: 'b1', name: 'Terra Threads', description: brandDescription),
  createdAt: _date,
  updatedAt: _date,
  description: 'Soft organic cotton, cut for everyday wear.',
  sustainabilityInfo: info,
);
