import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/utils/phone_number.dart';

void main() {
  group('toE164', () {
    test('Indian mobiles, however they are typed', () {
      for (final typed in [
        '9876543210',
        '98765 43210',
        '98765-43210',
        '(98765) 43210',
        '09876543210',
        '919876543210',
        '+91 98765 43210',
        '+919876543210',
        ' 98765.43210 ',
      ]) {
        expect(PhoneNumber.toE164(typed), '+919876543210', reason: typed);
      }
    });

    test('other countries need the + and their code', () {
      expect(PhoneNumber.toE164('+44 7700 900123'), '+447700900123');
      expect(PhoneNumber.toE164('+1 (415) 555-0100'), '+14155550100');
    });

    test('not a number we can text', () {
      for (final typed in [
        '',
        '12345',
        '5876543210', // Indian mobiles start with 6-9
        '98765432101', // 11 digits, no leading 0
        '+91 12345 67890',
        '+0 1234 5678',
        '+1234567', // too short
        '+1234567890123456', // too long
        '98765abc10',
        '++919876543210',
      ]) {
        expect(PhoneNumber.toE164(typed), isNull, reason: typed);
      }
    });
  });

  test('display groups Indian numbers, leaves others as stored', () {
    expect(PhoneNumber.display('+919876543210'), '+91\u00A098765\u00A043210');
    expect(PhoneNumber.display('+447700900123'), '+447700900123');
  });
}
