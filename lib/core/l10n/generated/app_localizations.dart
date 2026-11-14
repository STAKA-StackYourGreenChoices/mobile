import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Product name. Never translated.
  ///
  /// In en, this message translates to:
  /// **'STAKA'**
  String get appName;

  /// One-line description of what STAKA does, from the website's home page.
  ///
  /// In en, this message translates to:
  /// **'Your clothes, with their footprint attached.'**
  String get appTagline;

  /// Shown when the API can't be reached (offline, timeout). Adapted from the website's 503 copy.
  ///
  /// In en, this message translates to:
  /// **'STAKA\'s server isn\'t reachable right now. Check your connection, then try again.'**
  String get errorNetwork;

  /// Fallback error when nothing more specific is known. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Try again in a moment.'**
  String get errorGeneric;

  /// 401 without an API message. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Sign in again.'**
  String get errorSessionEnded;

  /// 403 without an API message. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Your account doesn\'t have access to this.'**
  String get errorForbidden;

  /// Screen-reader label for spinners.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Retry button after a failed load. Same wording as the website.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Heading above an error message when a screen or section fails to load.
  ///
  /// In en, this message translates to:
  /// **'This didn\'t load'**
  String get errorTitle;

  /// Heading when the API can't be reached.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get errorOfflineTitle;

  /// Invalid email. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Enter an email address like name@example.com'**
  String get validationEmail;

  /// Empty password on sign-in. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get validationPasswordRequired;

  /// New password under 8 characters. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get validationPasswordShort;

  /// New password over 128 characters. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Use 128 characters or fewer'**
  String get validationPasswordLong;

  /// Empty name on registration. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get validationNameRequired;

  /// Confirmation differs from the new password. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'The two passwords don\'t match'**
  String get validationPasswordsDiffer;

  /// Text over the length limit. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Use {max} characters or fewer'**
  String validationTooLong(int max);

  /// Tooltip and screen-reader label of the eye button in password fields.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// Tooltip and screen-reader label when the password is visible.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// Welcome screen intro. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'Scan the barcode on a clothing label to see the piece\'s carbon footprint and recyclability, prove you bought it, and keep its tag in one wardrobe.'**
  String get welcomeLede;

  /// Primary action for signed-out people. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// Sign-in action and screen title. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Ends the session. Same as the website's account menu.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Heading of the three steps on the welcome screen. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// Step 1 title. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'Scan the label'**
  String get stepScanTitle;

  /// Step 1. Website copy without its 'No app to install' line.
  ///
  /// In en, this message translates to:
  /// **'Point your phone\'s camera at the barcode on a clothing label, or type the number under it.'**
  String get stepScanBody;

  /// Step 2 title. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'See its footprint'**
  String get stepFootprintTitle;

  /// Step 2. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'The piece\'s tag shows its carbon footprint, how much of it can be recycled, and who checked those figures.'**
  String get stepFootprintBody;

  /// Step 3 title. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'Prove you own it'**
  String get stepProveTitle;

  /// Step 3. From the website's home page.
  ///
  /// In en, this message translates to:
  /// **'Match it to a paid order, or upload a receipt for the STAKA team to check. Proven pieces join your wardrobe.'**
  String get stepProveBody;

  /// Bottom bar tab. Same as the website nav.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe'**
  String get navWardrobe;

  /// Bottom bar tab. Same as the website nav.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// Bottom bar tab for admins: products, brands, import, claims.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get navAdmin;

  /// Bottom bar tab: the user's account and sign out.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// TEMPORARY development stand-in. Remove with PendingScreen before Phase 5.
  ///
  /// In en, this message translates to:
  /// **'This screen is being built'**
  String get pendingScreenTitle;

  /// Sign-in heading. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Sign in to STAKA'**
  String get loginTitle;

  /// Under the sign-in heading. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off with your tags.'**
  String get loginLede;

  /// Email field label. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// Password field label. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// Link under the sign-in password. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// Sign-in button while waiting. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// Before the 'Create an account' link on sign-in. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'New to STAKA?'**
  String get newToStaka;

  /// Sign-in 401. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'That email and password don\'t match an account. Check them and try again.'**
  String get loginWrongCredentials;

  /// Register heading. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Create your STAKA account'**
  String get registerTitle;

  /// Under the register heading. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Start a digital tag for every piece you own.'**
  String get registerLede;

  /// Register name label. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fieldYourName;

  /// Hint under the name field. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Shown on tags you share.'**
  String get nameHint;

  /// Hint under a new password. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters.'**
  String get passwordHint;

  /// Register submit button. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountSubmit;

  /// Register button while waiting. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Creating account…'**
  String get creatingAccount;

  /// Before the 'Sign in' link on register. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Register 409, shown on the email field. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'An account already uses this email. Sign in instead.'**
  String get registerEmailTaken;

  /// Forgot-password heading. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotTitle;

  /// Under the forgot-password heading. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Enter the email you signed up with and we\'ll send you a link to choose a new password.'**
  String get forgotLede;

  /// Forgot-password submit. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// Forgot-password submit after a link was sent. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Send another link'**
  String get sendAnotherLink;

  /// Forgot-password button while waiting. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Sending link…'**
  String get sendingLink;

  /// Forgot-password success. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'If {email} has a STAKA account, a reset link is on its way. It works once and expires in 1 hour.'**
  String resetLinkSent(String email);

  /// Mobile-only addition after the reset success message: the link opens the website (decision 7).
  ///
  /// In en, this message translates to:
  /// **'The link opens the STAKA website: choose your new password there, then sign in here.'**
  String get resetLinkOpensWebsite;

  /// Before 'Back to sign in'. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Remembered it?'**
  String get rememberedIt;

  /// Link back to sign-in. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// Sign-out button while waiting.
  ///
  /// In en, this message translates to:
  /// **'Signing out…'**
  String get signingOut;

  /// Account row, screen heading and submit button (decision 14; not on the website).
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// Under the change-password heading. The API revokes every session on change.
  ///
  /// In en, this message translates to:
  /// **'You\'ll stay signed in on this phone. Other devices will need to sign in again.'**
  String get changePasswordLede;

  /// Change-password field label.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get fieldCurrentPassword;

  /// Change-password field label.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPassword;

  /// Change-password confirmation label.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get fieldConfirmPassword;

  /// Empty current password.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get validationCurrentPasswordRequired;

  /// Change-password button while waiting.
  ///
  /// In en, this message translates to:
  /// **'Changing password…'**
  String get changingPassword;

  /// Change-password 401, shown on the current-password field.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t your current password. Check it and try again.'**
  String get currentPasswordWrong;

  /// Snackbar after a successful change.
  ///
  /// In en, this message translates to:
  /// **'Password changed. Other devices will need to sign in again.'**
  String get passwordChanged;

  /// Sign-in alert when re-signing in after a change failed. Website's reset-password success copy.
  ///
  /// In en, this message translates to:
  /// **'Password changed. Sign in with your new password.'**
  String get passwordChangedSignIn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
