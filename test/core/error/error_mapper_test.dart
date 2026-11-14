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
