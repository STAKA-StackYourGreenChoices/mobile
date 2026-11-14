import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/forms/validators.dart';
import 'package:staka/core/l10n/generated/app_localizations_en.dart';

void main() {
  final v = Validators(AppLocalizationsEn());

  test('email: same messages and verdicts as the website', () {
    expect(v.email('ada@example.com'), isNull);
    expect(v.email('  ada@example.com '), isNull);
    expect(v.email('ada.lovelace+staka@mail.example.co'), isNull);
    for (final bad in [
      '',
      'ada',
      'ada@',
      '@example.com',
      'ada@example',
      'a..b@x.io',
    ]) {
      expect(
        v.email(bad),
        'Enter an email address like name@example.com',
        reason: bad,
      );
    }
  });

  test('sign-in password only needs to be present', () {
    expect(v.password(''), 'Enter your password');
    expect(v.password('x'), isNull);
  });

  test('new password: 8 to 128 characters', () {
    expect(v.newPassword('1234567'), 'Use at least 8 characters');
    expect(v.newPassword('12345678'), isNull);
    expect(v.newPassword('a' * 128), isNull);
    expect(v.newPassword('a' * 129), 'Use 128 characters or fewer');
  });

  test('name: required after trimming, at most 100 characters', () {
    expect(v.name('   '), 'Enter your name');
    expect(v.name('Ada Lovelace'), isNull);
    expect(v.name('a' * 101), 'Use 100 characters or fewer');
  });

  test('matches compares with the other field at validation time', () {
    var other = 'secret-one';
    final rule = v.matches(() => other);
    expect(rule('secret-one'), isNull);
    other = 'secret-two';
    expect(rule('secret-one'), "The two passwords don't match");
  });
}
