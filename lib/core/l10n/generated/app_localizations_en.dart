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

  @override
  String get forgotTitle => 'Reset your password';

  @override
  String get forgotLede =>
      'Enter the email you signed up with and we\'ll send you a link to choose a new password.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get sendAnotherLink => 'Send another link';

  @override
  String get sendingLink => 'Sending link…';

  @override
  String resetLinkSent(String email) {
    return 'If $email has a STAKA account, a reset link is on its way. It works once and expires in 1 hour.';
  }

  @override
  String get resetLinkOpensWebsite =>
      'The link opens the STAKA website: choose your new password there, then sign in here.';

  @override
  String get rememberedIt => 'Remembered it?';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get signingOut => 'Signing out…';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordLede =>
      'You\'ll stay signed in on this phone. Other devices will need to sign in again.';

  @override
  String get fieldCurrentPassword => 'Current password';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get fieldConfirmPassword => 'Confirm new password';

  @override
  String get validationCurrentPasswordRequired => 'Enter your current password';

  @override
  String get changingPassword => 'Changing password…';

  @override
  String get currentPasswordWrong =>
      'That isn\'t your current password. Check it and try again.';

  @override
  String get passwordChanged =>
      'Password changed. Other devices will need to sign in again.';

  @override
  String get passwordChangedSignIn =>
      'Password changed. Sign in with your new password.';

  @override
  String tagSemantics(String product, String brand) {
    return 'Digital tag for $product by $brand';
  }

  @override
  String get noPhotoYet => 'No photo yet';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get tagFootprint => 'Footprint';

  @override
  String get tagRecyclable => 'Recyclable';

  @override
  String verifiedBy(String certifier) {
    return 'Verified by $certifier';
  }

  @override
  String get verifiedByThirdParty => 'Verified by a third party';

  @override
  String get statedByBrand => 'Figures stated by the brand';

  @override
  String get noFiguresYet => 'No sustainability figures yet';

  @override
  String keptBy(String name) {
    return 'Kept by $name';
  }

  @override
  String get verifiedOwnerSemantics => 'verified owner';

  @override
  String barcodeNumber(String number) {
    return 'Barcode $number';
  }

  @override
  String get unitGramsCo2e => 'g CO₂e';

  @override
  String get unitKgCo2e => 'kg CO₂e';

  @override
  String get ownershipVerified => 'Verified owner';

  @override
  String get ownershipPending => 'Receipt under review';

  @override
  String get ownershipRejected => 'Receipt turned down';

  @override
  String get ownershipBlocked => 'Can\'t be verified';

  @override
  String get ownershipUnverified => 'Not verified yet';

  @override
  String get sampleTagProduct => 'Organic Cotton Tee';

  @override
  String get sampleTagBrand => 'Terra Threads';

  @override
  String get wardrobeTitle => 'My wardrobe';

  @override
  String welcomeName(String name) {
    return 'Welcome, $name';
  }

  @override
  String get wardrobeEmptyDescription =>
      'Scan the barcode on a garment\'s label to keep its footprint on a digital tag.';

  @override
  String wardrobeCount(int count, int verified) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '1 piece',
    );
    return '$_temp0, $verified verified.';
  }

  @override
  String get scanAProduct => 'Scan a product';

  @override
  String get wardrobeEmptyTitle => 'Your wardrobe is empty';

  @override
  String get wardrobeEmptyBody =>
      'Point your camera at the barcode on a clothing label, or type the number under it. Each piece you add gets its own tag.';

  @override
  String get scanFirstPiece => 'Scan your first piece';

  @override
  String get sectionVerified => 'Verified';

  @override
  String get sectionVerifiedBody => 'Pieces you\'ve proven you own.';

  @override
  String get sectionWaiting => 'Waiting for proof';

  @override
  String get sectionWaitingBody =>
      'Open a tag to match it to an order or upload a receipt.';

  @override
  String get confirmYourEmail => 'Confirm your email';

  @override
  String verifyEmailJustJoined(String email) {
    return 'We\'ve sent a confirmation link to $email. Open it to confirm your email.';
  }

  @override
  String verifyEmailReminder(String email) {
    return 'We sent a confirmation link to $email. Open it to confirm your email.';
  }

  @override
  String get sendNewLink => 'Send a new link';

  @override
  String get sending => 'Sending…';

  @override
  String get verificationResent => 'We\'ve sent a new confirmation link.';

  @override
  String get emailAlreadyConfirmed => 'Your email is already confirmed.';
}
