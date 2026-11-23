/// Mobile numbers for text-message sign-in (V2-1).
///
/// People type an Indian mobile number the way it's printed ("98765 43210",
/// "098765-43210", "+91 98765 43210"), or any number with a `+` and its
/// country code. The API takes E.164 (`+919876543210`).
abstract final class PhoneNumber {
  /// The country code added to a number typed without one.
  static const defaultCountryCode = '+91';

  /// [input] as E.164, or null if it isn't a number we can send a code to.
  static String? toE164(String input) {
    final compact = input.replaceAll(RegExp(r'[\s\-().]'), '');
    if (compact.startsWith('+')) {
      final digits = compact.substring(1);
      if (!RegExp(r'^[1-9]\d{7,14}$').hasMatch(digits)) return null;
      if (digits.startsWith('91')) return _indian(digits.substring(2));
      return '+$digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(compact)) return null;
    // "0" in front is the trunk prefix; "91" in front is the country code
    // typed without "+".
    final national = switch (compact.length) {
      11 when compact.startsWith('0') => compact.substring(1),
      12 when compact.startsWith('91') => compact.substring(2),
      _ => compact,
    };
    return _indian(national);
  }

  /// Indian mobile numbers have 10 digits and start with 6, 7, 8 or 9.
  static String? _indian(String national) =>
      RegExp(r'^[6-9]\d{9}$').hasMatch(national) ? '+91$national' : null;

  /// "+91 98765 43210" for Indian numbers; others as stored. The spaces
  /// are non-breaking, so a number never splits across two lines.
  static String display(String e164) {
    final indian = RegExp(r'^\+91(\d{5})(\d{5})$').firstMatch(e164);
    if (indian == null) return e164;
    return '+91\u00A0${indian.group(1)}\u00A0${indian.group(2)}';
  }
}
