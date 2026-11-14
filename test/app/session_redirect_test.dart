import 'package:flutter_test/flutter_test.dart';
import 'package:staka/app/router/session_redirect.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/models/user.dart';

const _shopper = SignedIn(
  User(
    id: 'u1',
    email: 'a@x.io',
    name: 'Ada',
    role: Role.user,
    emailVerified: true,
  ),
);
const _admin = SignedIn(
  User(
    id: 'u2',
    email: 'b@x.io',
    name: 'Bo',
    role: Role.admin,
    emailVerified: true,
  ),
);

void main() {
  test('while restoring, everything waits on the launch screen', () {
    expect(redirectFor(const SessionRestoring(), '/wardrobe'), '/launch');
    expect(redirectFor(const SessionRestoring(), '/launch'), isNull);
  });

  test('API unreachable at launch shows the retry screen', () {
    expect(redirectFor(const SessionUnreachable(), '/launch'), '/unreachable');
    expect(redirectFor(const SessionUnreachable(), '/unreachable'), isNull);
  });

  test('signed out: guest pages only, everything else goes to welcome', () {
    const out = SignedOut();
    for (final guest in [
      '/welcome',
      '/login',
      '/register',
      '/forgot-password',
    ]) {
      expect(redirectFor(out, guest), isNull, reason: guest);
    }
    expect(redirectFor(out, '/launch'), '/welcome');
    expect(redirectFor(out, '/wardrobe'), '/welcome');
    expect(redirectFor(out, '/admin'), '/welcome');
  });

  test('an expired session lands on sign-in, which explains why', () {
    const expired = SignedOut(sessionExpired: true);
    expect(redirectFor(expired, '/wardrobe'), '/login');
    expect(redirectFor(expired, '/login'), isNull);
    expect(redirectFor(expired, '/register'), isNull);
  });

  test('signed in: guest and launch pages go to the wardrobe', () {
    for (final path in [
      '/welcome',
      '/login',
      '/register',
      '/launch',
      '/unreachable',
    ]) {
      expect(redirectFor(_shopper, path), '/wardrobe', reason: path);
    }
    expect(redirectFor(_shopper, '/scan'), isNull);
    expect(redirectFor(_shopper, '/account'), isNull);
  });

  test('admin pages are for admins only, like the website', () {
    expect(redirectFor(_shopper, '/admin'), '/wardrobe');
    expect(redirectFor(_shopper, '/admin/claims/42'), '/wardrobe');
    expect(redirectFor(_admin, '/admin'), isNull);
    expect(redirectFor(_admin, '/admin/claims/42'), isNull);
    expect(redirectFor(_shopper, '/administrator'), isNull);
  });
}
