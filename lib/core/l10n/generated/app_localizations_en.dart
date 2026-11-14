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

  @override
  String get welcomeLede =>
      'Scan the barcode on a clothing label to see the piece\'s carbon footprint and recyclability, prove you bought it, and keep its tag in one wardrobe.';

  @override
  String get createAccount => 'Create an account';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get howItWorks => 'How it works';

  @override
  String get stepScanTitle => 'Scan the label';

  @override
  String get stepScanBody =>
      'Point your phone\'s camera at the barcode on a clothing label, or type the number under it.';

  @override
  String get stepFootprintTitle => 'See its footprint';

  @override
  String get stepFootprintBody =>
      'The piece\'s tag shows its carbon footprint, how much of it can be recycled, and who checked those figures.';

  @override
  String get stepProveTitle => 'Prove you own it';

  @override
  String get stepProveBody =>
      'Match it to a paid order, or upload a receipt for the STAKA team to check. Proven pieces join your wardrobe.';

  @override
  String get navWardrobe => 'Wardrobe';

  @override
  String get navScan => 'Scan';

  @override
  String get navAdmin => 'Admin';

  @override
  String get navAccount => 'Account';

  @override
  String get pendingScreenTitle => 'This screen is being built';

  @override
  String get loginTitle => 'Sign in to STAKA';

  @override
  String get loginLede => 'Pick up where you left off with your tags.';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get newToStaka => 'New to STAKA?';

  @override
  String get loginWrongCredentials =>
      'That email and password don\'t match an account. Check them and try again.';

  @override
  String get registerTitle => 'Create your STAKA account';

  @override
  String get registerLede => 'Start a digital tag for every piece you own.';

  @override
  String get fieldYourName => 'Your name';

  @override
  String get nameHint => 'Shown on tags you share.';

  @override
  String get passwordHint => 'At least 8 characters.';

  @override
  String get createAccountSubmit => 'Create account';

  @override
  String get creatingAccount => 'Creating account…';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get registerEmailTaken =>
      'An account already uses this email. Sign in instead.';
}
