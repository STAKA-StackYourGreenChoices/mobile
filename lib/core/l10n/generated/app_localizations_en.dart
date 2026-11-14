// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'STAKA';

  @override
  String get appTagline => 'Your clothes, with their footprint attached.';

  @override
  String get errorNetwork =>
      'STAKA\'s server isn\'t reachable right now. Check your connection, then try again.';

  @override
  String get errorGeneric =>
      'Something went wrong on our side. Try again in a moment.';

  @override
  String get errorSessionEnded => 'Your session has ended. Sign in again.';

  @override
  String get errorForbidden => 'Your account doesn\'t have access to this.';

  @override
  String get loading => 'Loading';

  @override
  String get tryAgain => 'Try again';

  @override
  String get errorTitle => 'This didn\'t load';

  @override
  String get errorOfflineTitle => 'No connection';

  @override
  String get validationEmail => 'Enter an email address like name@example.com';

  @override
  String get validationPasswordRequired => 'Enter your password';

  @override
  String get validationPasswordShort => 'Use at least 8 characters';

  @override
  String get validationPasswordLong => 'Use 128 characters or fewer';

  @override
  String get validationNameRequired => 'Enter your name';

  @override
  String get validationPasswordsDiffer => 'The two passwords don\'t match';

  @override
  String validationTooLong(int max) {
    return 'Use $max characters or fewer';
  }

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';
}
