import 'package:staka/core/l10n/l10n.dart';

/// A form-field rule: null when valid, otherwise the message to show.
typedef Validator = String? Function(String? value);

/// The website's form rules (zod schemas in `web/app/(auth)/actions.ts`),
/// with the same messages, so both clients reject the same input.
class Validators {
  const new(this._l10n);

  final AppLocalizations _l10n;

  /// Same pattern zod 4's `z.email()` uses.
  static final _emailPattern = RegExp(
    r"^(?!\.)(?!.*\.\.)([A-Za-z0-9_'+\-\.]*)[A-Za-z0-9_+-]"
    r'@([A-Za-z0-9][A-Za-z0-9\-]*\.)+[A-Za-z]{2,}$',
  );

  Validator get email =>
      (value) => _emailPattern.hasMatch((value ?? '').trim())
      ? null
      : _l10n.validationEmail;

  /// Sign-in only checks that something was typed.
  Validator get password => required(_l10n.validationPasswordRequired);

  /// A password being set: 8 to 128 characters.
  Validator get newPassword => (value) {
    final length = (value ?? '').length;
    if (length < 8) return _l10n.validationPasswordShort;
    if (length > 128) return _l10n.validationPasswordLong;
    return null;
  };

  /// A person's name: 1 to 100 characters after trimming.
  Validator get name =>
      all([required(_l10n.validationNameRequired), maxLength(100)]);

  /// Must equal [other] (e.g. "new password" and "confirm").
  Validator matches(String Function() other) =>
      (value) => value == other() ? null : _l10n.validationPasswordsDiffer;

  /// Non-blank after trimming.
  Validator required(String message) =>
      (value) => (value ?? '').trim().isEmpty ? message : null;

  /// At most [max] characters after trimming.
  Validator maxLength(int max) =>
      (value) => (value ?? '').trim().length > max
      ? _l10n.validationTooLong(max)
      : null;

  /// At most [max] characters, naming the field: "Description must be 1000
  /// characters or fewer" (the website's admin forms).
  Validator labelledMaxLength(String label, int max) =>
      (value) => (value ?? '').trim().length > max
      ? _l10n.validationFieldTooLong(label, max)
      : null;

  /// Optional; when given, a full http(s) link (zod's `z.url` with the
  /// website's protocol rule).
  Validator get optionalWebLink => (value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final isWebLink =
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
    return isWebLink ? null : _l10n.validationUrl;
  };

  /// The first failing rule's message, like zod reports per field.
  static Validator all(List<Validator> rules) => (value) {
    for (final rule in rules) {
      if (rule(value) case final message?) return message;
    }
    return null;
  };
}
