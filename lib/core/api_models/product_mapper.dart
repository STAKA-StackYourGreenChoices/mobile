import 'package:staka/core/api_models/brand_dto.dart';
import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/core/api_models/sustainability_info_dto.dart';
import 'package:staka/core/config/env.dart';
import 'package:staka/core/models/brand.dart';
import 'package:staka/core/models/product.dart';
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
  );
}

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
