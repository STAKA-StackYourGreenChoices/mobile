import 'package:flutter/widgets.dart';

import 'package:staka/core/l10n/generated/app_localizations.dart';

export 'package:staka/core/l10n/generated/app_localizations.dart';

/// Every user-facing string comes from here: `context.l10n.appName`.
extension L10nAccess on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
