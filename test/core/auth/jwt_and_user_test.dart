import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/api_models/user_dto.dart';
import 'package:staka/core/api_models/user_mapper.dart';
import 'package:staka/core/auth/jwt_claims.dart';
import 'package:staka/core/models/user.dart';

import '../../helpers/auth_fakes.dart';

void main() {
  group('jwt claims', () {
    final now = DateTime.utc(2026, 11, 14, 12);

    test('reads exp from the payload', () {
      final exp = DateTime.utc(2026, 11, 14, 12, 15);
      expect(accessTokenExpiry(fakeJwt(exp: exp)), exp);
    });

    test('expiring within 30 s counts as expiring soon', () {
      final soon = fakeJwt(exp: now.add(const Duration(seconds: 29)));
      final later = fakeJwt(exp: now.add(const Duration(minutes: 5)));
      expect(isExpiringSoon(soon, now: now), isTrue);
      expect(isExpiringSoon(later, now: now), isFalse);
    });

    test('an unreadable token is left to the 401 path', () {
      expect(accessTokenExpiry('not-a-jwt'), isNull);
      expect(isExpiringSoon('a.b.c', now: now), isFalse);
    });
  });

  group('user mapping', () {
    test('maps the API role and ignores extra fields', () {
      final admin = UserDto.fromJson(userJson(role: 'ADMIN')).toDomain();
      final shopper = UserDto.fromJson(userJson()).toDomain();
      final unknown = UserDto.fromJson(userJson(role: 'BRAND')).toDomain();

      expect(admin.role, Role.admin);
      expect(shopper.role, Role.user);
      expect(unknown.isAdmin, isFalse);
      expect(shopper.firstName, 'Ada');
    });
  });
}
