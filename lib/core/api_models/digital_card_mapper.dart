import 'package:staka/core/api_models/digital_card_dto.dart';
import 'package:staka/core/api_models/ownership_dto.dart';
import 'package:staka/core/api_models/product_mapper.dart';
import 'package:staka/core/api_models/share_link_dto.dart';
import 'package:staka/core/config/env.dart';
import 'package:staka/core/models/digital_card.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/models/share_link.dart';

extension DigitalCardDtoMapper on DigitalCardDto {
  DigitalCard toDomain({String webAppUrl = Env.webAppUrl}) => DigitalCard(
    id: id,
    createdAt: createdAt,
    ownerName: user.name,
    product: product.toDomain(webAppUrl: webAppUrl),
    ownership: ownership.toDomain(),
    share: share?.toDomain(),
  );
}

extension OwnershipDtoMapper on OwnershipDto {
  Ownership toDomain() => Ownership(
    status: ownershipStatusFromApi(status),
    receiptAttemptsUsed: receiptAttemptsUsed,
    receiptAttemptsLeft: receiptAttemptsLeft,
    method: claimMethodFromApi(method),
    verifiedAt: verifiedAt,
    pendingSince: pendingSince,
    lastRejectionReason: lastRejectionReason,
  );
}

extension ShareLinkDtoMapper on ShareLinkDto {
  ShareLink toDomain() => ShareLink(slug: slug, createdAt: createdAt);
}

/// An unknown status is treated as not verified: the app never claims more
/// than the API said.
OwnershipStatus ownershipStatusFromApi(String status) => switch (status) {
  'VERIFIED' => OwnershipStatus.verified,
  'PENDING' => OwnershipStatus.pending,
  'REJECTED' => OwnershipStatus.rejected,
  'BLOCKED' => OwnershipStatus.blocked,
  _ => OwnershipStatus.unverified,
};

ClaimMethod? claimMethodFromApi(String? method) => switch (method) {
  'ORDER_MATCH' => ClaimMethod.orderMatch,
  'RECEIPT' => ClaimMethod.receipt,
  _ => null,
};
