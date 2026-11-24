import 'package:staka/core/api_models/brand_dto.dart';
import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/core/api_models/product_variant_dto.dart';
import 'package:staka/core/api_models/sustainability_info_dto.dart';
import 'package:staka/core/config/env.dart';
import 'package:staka/core/models/brand.dart';
import 'package:staka/core/models/product.dart';
import 'package:staka/core/models/product_variant.dart';
import 'package:staka/core/models/sustainability_info.dart';
import 'package:staka/core/utils/image_url.dart';

extension ProductDtoMapper on ProductDto {
  Product toDomain({String webAppUrl = Env.webAppUrl}) => Product(
    id: id,
    gtin: gtin,
    sku: sku,
    name: name,
    brand: brand.toDomain(),
    createdAt: createdAt,
    updatedAt: updatedAt,
    description: description,
    imageUrl: resolveImageUrl(imageUrl, webAppUrl: webAppUrl),
    sustainabilityInfo: sustainabilityInfo?.toDomain(),
    isHidden: hidden ?? false,
    category: ProductCategory.fromApi(category),
    styleCode: _text(styleCode),
    variants: [
      for (final variant in variants ?? const <ProductVariantDto>[])
        variant.toDomain(),
    ],
    matchedVariant: matchedVariant?.toDomain(),
  );
}

extension ProductVariantDtoMapper on ProductVariantDto {
  ProductVariant toDomain() => ProductVariant(
    id: id,
    gtin: gtin,
    sku: sku,
    size: _text(size),
    colour: _text(colour),
  );
}

/// Blank text from the API counts as absent.
String? _text(String? value) => switch (value?.trim()) {
  final text? when text.isNotEmpty => text,
  _ => null,
};

extension BrandDtoMapper on BrandDto {
  Brand toDomain() =>
      Brand(id: id, name: name, description: description, logoUrl: logoUrl);
}

extension SustainabilityInfoDtoMapper on SustainabilityInfoDto {
  SustainabilityInfo toDomain() => SustainabilityInfo(
    carbonScoreGrams: carbonScoreGrams,
    recyclabilityPercent: recyclabilityPercent,
    isVerified: verified,
    verifiedAt: verifiedAt,
    certifierName: certifierName,
  );
}
