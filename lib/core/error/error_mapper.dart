import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The one place a [Failure] becomes user-facing copy (guide §10.2).
///
/// Like the website (`web/lib/api.ts`), the API's own message wins when it
/// sent one; otherwise a status-specific fallback is used. Features that show
/// a special message for a status (e.g. login 401) handle it before calling
/// this.
String messageForFailure(Failure failure, AppLocalizations l10n) {
  return switch (failure) {
    NetworkFailure() => l10n.errorNetwork,
    CancelledFailure() || UnknownFailure() => l10n.errorGeneric,
    ApiFailure(:final message?) => message,
    UnauthorizedFailure() => l10n.errorSessionEnded,
    ForbiddenFailure() => l10n.errorForbidden,
    ApiFailure() => l10n.errorGeneric,
  };
}
