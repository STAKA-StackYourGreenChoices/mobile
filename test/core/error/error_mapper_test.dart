import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/generated/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('network failures get the connection copy', () {
    expect(messageForFailure(const NetworkFailure(), l10n), l10n.errorNetwork);
  });

  test("the API's own message wins, like on the website", () {
    expect(
      messageForFailure(
        const ConflictFailure(['A brand with this name already exists']),
        l10n,
      ),
      'A brand with this name already exists',
    );
  });

  test('429 is always worded by the app, with the wait in minutes', () {
    String message(Duration? retryAfter) => messageForFailure(
      TooManyRequestsFailure(const [
        'ThrottlerException: Too Many Requests',
      ], retryAfter: retryAfter),
      l10n,
    );

    expect(
      message(const Duration(seconds: 899)),
      'Too many attempts. Please wait 15 minutes and try again.',
    );
    expect(
      message(const Duration(seconds: 20)),
      'Too many attempts. Please wait 1 minute and try again.',
    );
    expect(
      message(Duration.zero),
      'Too many attempts. Please wait 1 minute and try again.',
    );
    expect(
      message(null),
      'Too many attempts. Please wait a few minutes and try again.',
    );
  });

  test('status fallbacks when the API sent no message', () {
    expect(
      messageForFailure(const UnauthorizedFailure([]), l10n),
      l10n.errorSessionEnded,
    );
    expect(
      messageForFailure(const ForbiddenFailure([]), l10n),
      l10n.errorForbidden,
    );
    expect(
      messageForFailure(const ServerFailure(500, []), l10n),
      l10n.errorGeneric,
    );
    expect(
      messageForFailure(UnknownFailure(Exception('boom')), l10n),
      l10n.errorGeneric,
    );
  });
}
