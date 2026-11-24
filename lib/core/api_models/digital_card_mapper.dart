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
  DigitalCard toDomain({String webAppUrl = Env.webAppUrl}) {
    final product = this.product.toDomain(webAppUrl: webAppUrl);
    return DigitalCard(
      id: id,
      createdAt: createdAt,
      ownerName: user.name,
      product: product,
      ownership: ownership.toDomain(),
      share: share?.toDomain(),
      variant:
          variant?.toDomain() ??
          product.variants.where((v) => v.id == variantId).firstOrNull,
      showInWardrobe: showInWardrobe ?? true,
    );
  }
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
    decidedBy: switch (decidedBy) {
      'BRAND' => ClaimDecider.brand,
      'ADMIN' => ClaimDecider.admin,
      _ => null,
    },
    brandName: switch (brandName?.trim()) {
      final name? when name.isNotEmpty => name,
      _ => null,
    },
    dispute: switch (dispute) {
      final dispute? => OwnershipDispute(
        status: switch (dispute.status) {
          'UPHELD' => DisputeStatus.upheld,
          'OVERTURNED' => DisputeStatus.overturned,
          // Unknown counts as still open: the app never offers a second
          // request the API would refuse.
          _ => DisputeStatus.open,
        },
        resolution: dispute.resolution,
      ),
      null => null,
    },
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
