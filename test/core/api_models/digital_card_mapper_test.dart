import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/api_models/digital_card_dto.dart';
import 'package:staka/core/api_models/digital_card_mapper.dart';
import 'package:staka/core/models/ownership.dart';
import 'package:staka/core/models/ownership_status.dart';
import 'package:staka/core/utils/image_url.dart';

/// The shape `DigitalCardsService.present` sends: absent, not null, fields.
Map<String, Object?> _cardJson({
  Map<String, Object?> ownership = const {
    'status': 'VERIFIED',
    'method': 'ORDER_MATCH',
    'verifiedAt': '2026-11-10T09:00:00.000Z',
    'receiptAttemptsUsed': 0,
    'receiptAttemptsLeft': 5,
  },
  bool withFigures = true,
  bool withShare = true,
}) => {
  'id': 'c1',
  'createdAt': '2026-11-09T12:00:00.000Z',
  'user': {'id': 'u1', 'name': 'Ada Lovelace'},
  'product': {
    'id': 'p1',
    'gtin': '08901234500019',
    'sku': 'TT-TEE-01',
    'name': 'Organic Cotton Tee',
    'imageUrl': 'http://localhost:3000/catalog-images/organic-cotton-tee.svg',
    'brand': {'id': 'b1', 'name': 'Terra Threads'},
    if (withFigures)
      'sustainabilityInfo': {
        'carbonScoreGrams': 2100,
        'recyclabilityPercent': 80,
        'verified': true,
        'certifierName': 'Global Organic Textile Standard',
      },
    'createdAt': '2026-11-01T00:00:00.000Z',
    'updatedAt': '2026-11-01T00:00:00.000Z',
  },
  'ownership': ownership,
  if (withShare)
    'share': {'slug': 'abc123', 'createdAt': '2026-11-11T00:00:00.000Z'},
};

void main() {
  test('maps a full card, re-pointing the catalog image at the website', () {
    final card = DigitalCardDto.fromJson(_cardJson())
        .toDomain(webAppUrl: 'http://192.168.1.20:3000/');

    expect(card.ownerName, 'Ada Lovelace');
    expect(card.product.brand.name, 'Terra Threads');
    expect(card.product.sustainabilityInfo!.isVerified, isTrue);
    expect(
      card.product.imageUrl,
      'http://192.168.1.20:3000/catalog-images/organic-cotton-tee.svg',
    );
    expect(card.ownership.status, OwnershipStatus.verified);
    expect(card.ownership.method, ClaimMethod.orderMatch);
    expect(card.share!.slug, 'abc123');
  });

  test('absent optional fields stay absent', () {
    final card = DigitalCardDto.fromJson(
      _cardJson(
        ownership: const {
          'status': 'UNVERIFIED',
          'receiptAttemptsUsed': 0,
          'receiptAttemptsLeft': 5,
        },
        withFigures: false,
        withShare: false,
      ),
    ).toDomain(webAppUrl: 'http://web.test');

    expect(card.product.sustainabilityInfo, isNull);
    expect(card.share, isNull);
    expect(card.ownership.method, isNull);
    expect(card.ownership.isVerified, isFalse);
  });

  test('every API ownership status maps; unknown never claims more', () {
    expect(ownershipStatusFromApi('PENDING'), OwnershipStatus.pending);
    expect(ownershipStatusFromApi('REJECTED'), OwnershipStatus.rejected);
    expect(ownershipStatusFromApi('BLOCKED'), OwnershipStatus.blocked);
    expect(ownershipStatusFromApi('UNVERIFIED'), OwnershipStatus.unverified);
    expect(ownershipStatusFromApi('SOMETHING_NEW'), OwnershipStatus.unverified);
    expect(claimMethodFromApi('RECEIPT'), ClaimMethod.receipt);
  });

  group('resolveImageUrl', () {
    const web = 'http://10.0.2.2:3000';

    test('catalog images move to the website the phone can reach', () {
      expect(
        resolveImageUrl(
          'http://localhost:3000/catalog-images/tee.svg',
          webAppUrl: web,
        ),
        '$web/catalog-images/tee.svg',
      );
      expect(
        resolveImageUrl('/catalog-images/tee.svg', webAppUrl: web),
        '$web/catalog-images/tee.svg',
      );
    });

    test('other images are left alone; nothing stays nothing', () {
      const brandPhoto = 'https://cdn.brand.example/tee.jpg';
      expect(resolveImageUrl(brandPhoto, webAppUrl: web), brandPhoto);
      expect(resolveImageUrl(null, webAppUrl: web), isNull);
      expect(resolveImageUrl('', webAppUrl: web), isNull);
    });
  });
}
