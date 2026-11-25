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

  /// 429 (too many sign-in attempts or emails). Same wording as the API's message, which the website shows.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{Too many attempts. Please wait 1 minute and try again.} other{Too many attempts. Please wait {minutes} minutes and try again.}}'**
  String errorTooManyAttempts(int minutes);

  /// 429 when the API didn't say how long to wait.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a few minutes and try again.'**
  String get errorTooManyAttemptsSoon;

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

  /// Screen-reader label of a hang tag. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Digital tag for {product} by {brand}'**
  String tagSemantics(String product, String brand);

  /// Tag photo area without a photo. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'No photo yet'**
  String get noPhotoYet;

  /// A product photo failed to load (guide §6.4).
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailable;

  /// Carbon figure label on a tag. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Footprint'**
  String get tagFootprint;

  /// Recyclability figure label on a tag. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Recyclable'**
  String get tagRecyclable;

  /// Figures checked by a named certifier. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Verified by {certifier}'**
  String verifiedBy(String certifier);

  /// Verified figures without a certifier name. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Verified by a third party'**
  String get verifiedByThirdParty;

  /// Unverified figures. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Figures stated by the brand'**
  String get statedByBrand;

  /// Product without figures. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'No sustainability figures yet'**
  String get noFiguresYet;

  /// Owner line on a tag. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Kept by {name}'**
  String keptBy(String name);

  /// Screen-reader suffix after 'Kept by …' when ownership is proven. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'verified owner'**
  String get verifiedOwnerSemantics;

  /// GTIN line on a tag. Same as the website's hang tag.
  ///
  /// In en, this message translates to:
  /// **'Barcode {number}'**
  String barcodeNumber(String number);

  /// Unit after a carbon figure under 1 kg. Keep the subscript ₂.
  ///
  /// In en, this message translates to:
  /// **'g CO₂e'**
  String get unitGramsCo2e;

  /// Unit after a carbon figure of 1 kg or more. Keep the subscript ₂.
  ///
  /// In en, this message translates to:
  /// **'kg CO₂e'**
  String get unitKgCo2e;

  /// Ownership chip. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Verified owner'**
  String get ownershipVerified;

  /// Ownership chip. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Receipt under review'**
  String get ownershipPending;

  /// Ownership chip. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Receipt turned down'**
  String get ownershipRejected;

  /// Ownership chip. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Can\'t be verified'**
  String get ownershipBlocked;

  /// Ownership chip. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Not verified yet'**
  String get ownershipUnverified;

  /// Welcome example tag: a seeded product's name. Proper noun, do not translate.
  ///
  /// In en, this message translates to:
  /// **'Organic Cotton Tee'**
  String get sampleTagProduct;

  /// Welcome example tag: a seeded brand. Proper noun, do not translate.
  ///
  /// In en, this message translates to:
  /// **'Terra Threads'**
  String get sampleTagBrand;

  /// Wardrobe heading. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'My wardrobe'**
  String get wardrobeTitle;

  /// Wardrobe heading right after registering. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeName(String name);

  /// Wardrobe intro when empty. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Scan the barcode on a garment\'s label to keep its footprint on a digital tag.'**
  String get wardrobeEmptyDescription;

  /// Wardrobe intro with tags. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 piece} other{{count} pieces}}, {verified} verified.'**
  String wardrobeCount(int count, int verified);

  /// Wardrobe action. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Scan a product'**
  String get scanAProduct;

  /// Empty wardrobe heading. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Your wardrobe is empty'**
  String get wardrobeEmptyTitle;

  /// Empty wardrobe text. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the barcode on a clothing label, or type the number under it. Each piece you add gets its own tag.'**
  String get wardrobeEmptyBody;

  /// Empty wardrobe action. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Scan your first piece'**
  String get scanFirstPiece;

  /// Wardrobe group of proven pieces. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get sectionVerified;

  /// Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Pieces you\'ve proven you own.'**
  String get sectionVerifiedBody;

  /// Wardrobe group of unproven pieces. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Waiting for proof'**
  String get sectionWaiting;

  /// Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Open a tag to match it to an order or upload a receipt.'**
  String get sectionWaitingBody;

  /// Screen-reader label of the verify-email banner. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email'**
  String get confirmYourEmail;

  /// Banner right after registering. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation link to {email}. Open it to confirm your email.'**
  String verifyEmailJustJoined(String email);

  /// Banner later on. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}. Open it to confirm your email.'**
  String verifyEmailReminder(String email);

  /// Banner button. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Send a new link'**
  String get sendNewLink;

  /// Banner button while waiting. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sending;

  /// After a resend. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a new confirmation link.'**
  String get verificationResent;

  /// Resend when already confirmed. Same as the website's /wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Your email is already confirmed.'**
  String get emailAlreadyConfirmed;

  /// Scan heading. Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Scan a product'**
  String get scanTitle;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Hold the barcode on the clothing label inside the frame. QR codes on tags work too.'**
  String get scanLede;

  /// Screen-reader label of the camera area. Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraRegion;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Starting the camera…'**
  String get cameraStarting;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Looking for a barcode…'**
  String get cameraLooking;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Found {gtin}. Opening the product…'**
  String cameraFound(String gtin);

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Camera is off.'**
  String get cameraOff;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Turn camera on'**
  String get turnCameraOn;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Turn camera off'**
  String get turnCameraOff;

  /// Camera permission refused. Website copy, adapted: phone Settings instead of browser site settings.
  ///
  /// In en, this message translates to:
  /// **'Camera access is blocked. Allow it for STAKA in your phone\'s Settings, then try again. Or type the number.'**
  String get cameraBlocked;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'{reason} Type the barcode number instead.'**
  String cameraUnavailable(String reason);

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'No camera was found on this device.'**
  String get cameraNoCamera;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'The camera couldn\'t start.'**
  String get cameraCouldNotStart;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Type the number instead'**
  String get typeNumberTitle;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Barcode number'**
  String get barcodeNumberLabel;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'e.g. 8901234500019'**
  String get barcodeNumberHint;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'The digits printed under the bars.'**
  String get barcodeNumberHelp;

  /// Same as the website's /scan.
  ///
  /// In en, this message translates to:
  /// **'Look up product'**
  String get lookUpProduct;

  /// web lib/scan.ts
  ///
  /// In en, this message translates to:
  /// **'Enter the number under the barcode.'**
  String get scanEmpty;

  /// web lib/scan.ts
  ///
  /// In en, this message translates to:
  /// **'That\'s {count} digits. Barcode numbers have 8, 12, 13 or 14.'**
  String scanWrongLength(int count);

  /// web lib/scan.ts
  ///
  /// In en, this message translates to:
  /// **'This QR code links to a website, not a product STAKA knows.'**
  String get scanWebsite;

  /// web lib/scan.ts
  ///
  /// In en, this message translates to:
  /// **'This code isn\'t a product barcode.'**
  String get scanNotBarcode;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'In your wardrobe'**
  String get productInWardrobe;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'View your tag'**
  String get viewYourTag;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Add to my wardrobe'**
  String get addToMyWardrobe;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Adding…'**
  String get adding;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'What the figures mean'**
  String get figuresTitle;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Carbon footprint: {value}'**
  String figureCarbon(String value);

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Estimated greenhouse gases from making this piece, expressed as the same warming effect in carbon dioxide.'**
  String get figureCarbonBody;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Recyclable: {percent}%'**
  String figureRecyclable(int percent);

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'The share of the piece, by weight, that can be recycled at end of life.'**
  String get figureRecyclableBody;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Independently verified'**
  String get independentlyVerified;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'{certifier} has checked these figures.'**
  String certifierChecked(String certifier);

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'A third party has checked these figures.'**
  String get thirdPartyChecked;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Stated by the brand'**
  String get statedByBrandTitle;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'No one outside the brand has checked these figures yet.'**
  String get noOneChecked;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'{brand} hasn\'t shared figures for this piece yet.'**
  String brandNoFigures(String brand);

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'About {brand}'**
  String aboutBrand(String brand);

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'That barcode didn\'t read correctly'**
  String get barcodeInvalidTitle;

  /// Same as the website's product page. {message} is the API's reason.
  ///
  /// In en, this message translates to:
  /// **'{message}. Scan it again, or check the digits if you typed them.'**
  String barcodeInvalidBody(String message);

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'This product isn\'t on STAKA yet'**
  String get productUnknownTitle;

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'No brand has added barcode {gtin} yet. Only products from partner brands have tags for now.'**
  String productUnknownBody(String gtin);

  /// Same as the website's product page.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scanAgain;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'{product} is in your wardrobe.'**
  String addedBanner(String product);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Added to your wardrobe on {date}.'**
  String addedOn(String date);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Scan another piece'**
  String get scanAnotherPiece;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// The tag doesn't exist or isn't this shopper's (API 404). The website shows its 404 page.
  ///
  /// In en, this message translates to:
  /// **'This tag isn\'t in your wardrobe'**
  String get tagMissingTitle;

  /// Under tagMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed, or the link was copied wrong.'**
  String get tagMissingBody;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'{left, plural, =1{1 upload left.} other{{left} of 5 uploads left.}}'**
  String uploadsLeft(int left);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'You\'re the verified owner'**
  String get ownershipVerifiedTitle;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'We matched this piece to a paid order on your account on {date}. It counts toward your wardrobe.'**
  String verifiedByOrderOn(String date);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'We matched this piece to a paid order on your account. It counts toward your wardrobe.'**
  String get verifiedByOrder;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'An admin approved your receipt on {date}. It counts toward your wardrobe.'**
  String verifiedByReceiptOn(String date);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'An admin approved your receipt. It counts toward your wardrobe.'**
  String get verifiedByReceipt;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Sent {date}. An admin will check it, and the result shows up here. {uploadsLeft}'**
  String pendingBody(String date, String uploadsLeft);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'An admin will check it, and the result shows up here. {uploadsLeft}'**
  String pendingBodyUndated(String uploadsLeft);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'This piece can\'t be verified'**
  String get blockedTitle;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'All 5 receipt uploads for it were used. You can still keep its tag.'**
  String get blockedBody;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'All 5 receipt uploads for it were used. The last one was turned down: {reason}. You can still keep its tag.'**
  String blockedBodyWithReason(String reason);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Prove you own it'**
  String get proveTitle;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Verified pieces count toward your wardrobe. Use whichever way works for you.'**
  String get proveLede;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Your last receipt was turned down: {reason}. {uploadsLeft}'**
  String lastReceiptRejected(String reason, String uploadsLeft);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'no reason given'**
  String get noReasonGiven;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Bought it through STAKA\'s partner shop?'**
  String get orderTitle;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'We\'ll look for it in the paid orders on your account.'**
  String get orderBody;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Find it in my orders'**
  String get findInOrders;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Checking orders…'**
  String get checkingOrders;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Verified: we found it in your orders.'**
  String get orderMatched;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'No paid order on your account includes this piece. Upload a receipt instead.'**
  String get orderNotFound;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Upload a receipt'**
  String get receiptTitle;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'A clear photo or PDF showing the shop, the date and this piece. An admin checks it. {uploadsLeft}'**
  String receiptBody(String uploadsLeft);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo or PDF'**
  String get choosePhotoOrPdf;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'{size} MB. Tap to change.'**
  String fileSizeTapToChange(String size);

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'The file is over 5 MB. Take a smaller photo or crop it.'**
  String get fileTooLarge;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Send for review'**
  String get sendForReview;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Sending receipt…'**
  String get sendingReceipt;

  /// Same as the website's tag page.
  ///
  /// In en, this message translates to:
  /// **'Receipt sent. We\'ll check it soon.'**
  String get receiptSent;

  /// Receipt source: the camera. Mobile only (the website has one file input).
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// Receipt source: the photo library.
  ///
  /// In en, this message translates to:
  /// **'Choose from your photos'**
  String get choosePhoto;

  /// Receipt source: a PDF file.
  ///
  /// In en, this message translates to:
  /// **'Choose a PDF'**
  String get choosePdf;

  /// Screen-reader label of a tag in the wardrobe. Same as the website.
  ///
  /// In en, this message translates to:
  /// **'{product} by {brand}, open tag'**
  String openTagLabel(String product, String brand);

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Sharing unlocks once you\'re verified'**
  String get shareLockedTitle;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Only proven pieces can be shared, so every STAKA tag people see is backed by a real purchase.'**
  String get shareLockedBody;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Share this tag'**
  String get shareTitle;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the link sees the tag, your first name and that you\'re the verified owner. Never your email.'**
  String get shareBody;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Create share link'**
  String get createShareLink;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Creating link…'**
  String get creatingLink;

  /// Screen-reader label of the link box. Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get shareLinkLabel;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// While the story image downloads.
  ///
  /// In en, this message translates to:
  /// **'Preparing image…'**
  String get preparingImage;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'See what others see'**
  String get seeWhatOthersSee;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing'**
  String get stopSharing;

  /// Stop sharing while waiting.
  ///
  /// In en, this message translates to:
  /// **'Stopping…'**
  String get stoppingSharing;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing this tag?'**
  String get stopSharingTitle;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'The link stops working for everyone, including posts that already use it. You can share again later with a new link.'**
  String get stopSharingBody;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Keep sharing'**
  String get keepSharing;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Share link ready'**
  String get shareLinkReady;

  /// Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Sharing turned off. The old link no longer works.'**
  String get sharingTurnedOff;

  /// No app could open the public page.
  ///
  /// In en, this message translates to:
  /// **'The link couldn\'t be opened.'**
  String get couldNotOpenLink;

  /// Text shared with the link. Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'I own this {product}, verified on STAKA.'**
  String shareText(String product);

  /// Share subject (e.g. email). Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'{product} on STAKA'**
  String shareSubject(String product);

  /// Same as the website's admin nav.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get adminProducts;

  /// Same as the website's products page header.
  ///
  /// In en, this message translates to:
  /// **'Everything shoppers can scan. A product\'s tag shows exactly what\'s recorded here.'**
  String get adminProductsDescription;

  /// Same as the website's admin nav.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get adminBrands;

  /// Same as the website's brands page header.
  ///
  /// In en, this message translates to:
  /// **'Every product belongs to a brand. Its name appears at the top of each tag.'**
  String get adminBrandsDescription;

  /// Same as the website's admin nav.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get adminImport;

  /// Same as the website's import page header.
  ///
  /// In en, this message translates to:
  /// **'Add or update many products at once from a spreadsheet saved as CSV. Rows are matched on barcode: new barcodes are added, known ones are updated.'**
  String get adminImportDescription;

  /// Same as the website's admin nav.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get adminClaims;

  /// Same as the website's claims page header.
  ///
  /// In en, this message translates to:
  /// **'Shoppers prove they bought a piece with a receipt. Approving one makes them its verified owner. Order matches are approved automatically.'**
  String get adminClaimsDescription;

  /// Same as the website's products page action.
  ///
  /// In en, this message translates to:
  /// **'Import CSV'**
  String get importCsv;

  /// Same as the website's products page action.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// Same as the website's product search (screen-reader label).
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProductsLabel;

  /// Same as the website's product search placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name, SKU, barcode or brand'**
  String get searchProductsHint;

  /// Same as the website's brand filter label; also the sheet title.
  ///
  /// In en, this message translates to:
  /// **'Filter by brand'**
  String get filterByBrand;

  /// Same as the website's brand filter.
  ///
  /// In en, this message translates to:
  /// **'All brands'**
  String get allBrands;

  /// Same as the website's product filters: removes search and brand.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearFilters;

  /// Clears the search field (screen-reader label of its x button).
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// Same as the website's product list count. The app loads more as you scroll, so first is 1.
  ///
  /// In en, this message translates to:
  /// **'{total, plural, =1{Showing {first}–{last} of {total} product} other{Showing {first}–{last} of {total} products}}'**
  String showingProducts(int total, int first, int last);

  /// Same as the website's SustainabilityBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get figuresVerified;

  /// Same as the website's SustainabilityBadge.
  ///
  /// In en, this message translates to:
  /// **'Brand-stated'**
  String get figuresBrandStated;

  /// Same as the website's SustainabilityBadge.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get figuresMissing;

  /// Same as the website's compact SustainabilityBadge (screen-reader label).
  ///
  /// In en, this message translates to:
  /// **'Figures: {status}'**
  String figuresBadgeLabel(String status);

  /// Same as the website's products empty state (filtered).
  ///
  /// In en, this message translates to:
  /// **'No products match'**
  String get noProductsMatchTitle;

  /// Same as the website's products empty state (filtered).
  ///
  /// In en, this message translates to:
  /// **'Try a different name, SKU or barcode, or clear the filters.'**
  String get noProductsMatchBody;

  /// Same as the website's products empty state.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsTitle;

  /// Same as the website's products empty state.
  ///
  /// In en, this message translates to:
  /// **'Add products one at a time, or import a whole catalog from a CSV file.'**
  String get noProductsBody;

  /// Same as the website's product pages.
  ///
  /// In en, this message translates to:
  /// **'Shoppers find this product by scanning its barcode.'**
  String get productNewDescription;

  /// Same as the website's product pages.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}.'**
  String productLastUpdated(String date);

  /// No product with this id. The website shows the Next.js 404 page with this line.
  ///
  /// In en, this message translates to:
  /// **'This page could not be found.'**
  String get pageNotFound;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productSection;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldProductName;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'As it\'s printed on the label, e.g. Organic Cotton Tee.'**
  String get productNameHint;

  /// Same as the website's product form. Also the preview's brand before one is chosen.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get fieldBrand;

  /// Same as the website's product form. Placeholder and validation message.
  ///
  /// In en, this message translates to:
  /// **'Choose a brand'**
  String get chooseBrand;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Missing one?'**
  String get brandMissing;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Add it on the Brands page'**
  String get addBrandLink;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Barcode number'**
  String get fieldBarcode;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'The digits under the barcode (EAN, UPC or GTIN).'**
  String get barcodeHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get fieldSku;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Your internal product code.'**
  String get skuHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Optional. One or two sentences about materials and making.'**
  String get descriptionHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Photo link'**
  String get fieldPhotoLink;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Optional. A square photo works best.'**
  String get photoLinkHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'https://'**
  String get photoLinkPlaceholder;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Sustainability figures'**
  String get figuresSection;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Include carbon and recyclability figures'**
  String get includeFigures;

  /// Same as the website's product form. Keep the subscript ₂.
  ///
  /// In en, this message translates to:
  /// **'Carbon footprint (grams CO₂e)'**
  String get fieldCarbon;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Whole grams, e.g. 2100.'**
  String get carbonHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Shown as {value}'**
  String carbonShownAs(String value);

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Recyclable (%)'**
  String get fieldRecyclable;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'0 to 100.'**
  String get recyclableHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Leave off if the brand states these figures itself. Tags show the difference.'**
  String get verifiedByThirdPartyHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Verified by'**
  String get fieldCertifier;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'The certification or body, e.g. Global Organic Textile Standard.'**
  String get certifierHint;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// Same as the website's product form. Submit button while waiting.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Shoppers will see this tag'**
  String get tagPreviewCaption;

  /// Same as the website's product form. Preview before a name is typed.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get previewProductName;

  /// Same as the website's product form. Snackbar.
  ///
  /// In en, this message translates to:
  /// **'Product added'**
  String get productAdded;

  /// Same as the website's product form. Snackbar.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// Same as the website's product form.
  ///
  /// In en, this message translates to:
  /// **'Some details need fixing before this product can be saved.'**
  String get productFormInvalid;

  /// Same as the website's product form. Alert on a 409; the API's message goes on the field.
  ///
  /// In en, this message translates to:
  /// **'Another product already uses this code.'**
  String get productCodeTaken;

  /// Same as the website's product form. Alert on a GTIN 400.
  ///
  /// In en, this message translates to:
  /// **'The barcode number isn\'t valid.'**
  String get barcodeInvalid;

  /// Same as the website's product form. {message} is the API's reason.
  ///
  /// In en, this message translates to:
  /// **'{message}. Check the digits under the barcode.'**
  String barcodeInvalidField(String message);

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Enter the product name'**
  String get validationProductName;

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Enter the 8, 12, 13 or 14 digits printed under the barcode'**
  String get validationGtin;

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Enter the SKU'**
  String get validationSku;

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'{label} must be {max} characters or fewer'**
  String validationFieldTooLong(String label, int max);

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Enter a full link starting with https://'**
  String get validationUrl;

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Required when figures are included'**
  String get validationFigureRequired;

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'{label} must be {max} or less'**
  String validationAtMost(String label, int max);

  /// Same as the website's product rules (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Name who verified the figures'**
  String get validationCertifier;

  /// Same as the website's product rules (admin/actions.ts). Used inside validationFieldTooLong.
  ///
  /// In en, this message translates to:
  /// **'Certifier'**
  String get certifierLabel;

  /// Same as the website's product rules (admin/actions.ts). Used inside validationAtMost.
  ///
  /// In en, this message translates to:
  /// **'Recyclability'**
  String get recyclabilityLabel;

  /// Same as the website's delete-product dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProduct;

  /// Delete buttons while waiting (products, brands). Same as the website.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get deleting;

  /// Same as the website's delete-product dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteProductTitle(String name);

  /// Same as the website's delete-product dialog.
  ///
  /// In en, this message translates to:
  /// **'Shoppers will no longer find it by scanning. This can\'t be undone.'**
  String get deleteProductBody;

  /// Same as the website's delete-product dialog.
  ///
  /// In en, this message translates to:
  /// **'Keep product'**
  String get keepProduct;

  /// Same as the website's delete-product dialog. Snackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String productDeleted(String name);

  /// Same as the website's brands page. Also the dialog title and submit button.
  ///
  /// In en, this message translates to:
  /// **'Add brand'**
  String get addBrand;

  /// Same as the website's brands page.
  ///
  /// In en, this message translates to:
  /// **'No brands yet'**
  String get noBrandsTitle;

  /// Same as the website's brands page.
  ///
  /// In en, this message translates to:
  /// **'Add a brand before adding its products. Importing a CSV also creates any brands it names.'**
  String get noBrandsBody;

  /// Same as the website's brands page. Opens the products list filtered to the brand.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String brandProductCount(int count);

  /// Same as the website's brands page.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Same as the website's brands page. Screen-reader label of Edit; also the dialog title.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editBrandLabel(String name);

  /// Same as the website's brands page.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Same as the website's brands page. Screen-reader label of Delete.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String deleteBrandLabel(String name);

  /// Same as the website's brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Changes show on every tag for this brand\'s products.'**
  String get editBrandDescription;

  /// Same as the website's brand dialog.
  ///
  /// In en, this message translates to:
  /// **'You can add its products once the brand exists.'**
  String get addBrandDescription;

  /// Same as the website's brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Brand name'**
  String get fieldBrandName;

  /// Same as the website's brand dialog.
  ///
  /// In en, this message translates to:
  /// **'About the brand'**
  String get fieldAboutBrand;

  /// Same as the website's brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Optional. One sentence on what they make and how.'**
  String get aboutBrandHint;

  /// Same as the website's brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Logo link'**
  String get fieldLogoLink;

  /// Same as the website's brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Optional.'**
  String get optionalHint;

  /// Same as the website's brand rules.
  ///
  /// In en, this message translates to:
  /// **'Enter the brand name'**
  String get validationBrandName;

  /// Same as the website's brand dialog (409, on the name field).
  ///
  /// In en, this message translates to:
  /// **'A brand with this name already exists'**
  String get brandNameTaken;

  /// Same as the website's brand dialog. Snackbar.
  ///
  /// In en, this message translates to:
  /// **'Brand added'**
  String get brandAdded;

  /// Same as the website's brand dialog. Snackbar.
  ///
  /// In en, this message translates to:
  /// **'Brand updated'**
  String get brandUpdated;

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'{name} still has products'**
  String brandHasProductsTitle(String name);

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete its 1 product or move them to another brand first.} other{Delete its {count} products or move them to another brand first.}}'**
  String brandHasProductsBody(int count);

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteBrandTitle(String name);

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get cantBeUndone;

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'See its products'**
  String get seeItsProducts;

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Keep brand'**
  String get keepBrand;

  /// Same as the website's delete-brand dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete brand'**
  String get deleteBrand;

  /// Same as the website's delete-brand dialog. Snackbar.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String brandDeleted(String name);

  /// Same as the website's import page header.
  ///
  /// In en, this message translates to:
  /// **'Import products'**
  String get importTitle;

  /// Same as the website's import flow. Screen-reader label of the stepper.
  ///
  /// In en, this message translates to:
  /// **'Import progress'**
  String get importProgressLabel;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get stepChooseFile;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get stepImport;

  /// Screen-reader label of one step circle (the website hides step names on phones).
  ///
  /// In en, this message translates to:
  /// **'Step {number} of {total}: {name}'**
  String stepLabel(int number, int total, String name);

  /// Same as the website's import flow. Screen-reader suffix of a finished step.
  ///
  /// In en, this message translates to:
  /// **'(done)'**
  String get stepDone;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Choose a CSV file'**
  String get chooseCsvFile;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Up to 2 MB and 5,000 rows.'**
  String get csvLimits;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{size} KB. Choose another file to replace it.'**
  String chosenFileSize(String size);

  /// Same as the website's import flow. On the phone it opens the share sheet with the file.
  ///
  /// In en, this message translates to:
  /// **'Download the template'**
  String get downloadTemplate;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Check file'**
  String get checkFile;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Checking file…'**
  String get checkingFile;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'What the file needs'**
  String get fileNeedsTitle;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Required columns:'**
  String get fileNeedsColumnsLabel;

  /// Same as the website's import flow. CSV column names: do not translate.
  ///
  /// In en, this message translates to:
  /// **'gtin, sku, name, brandName'**
  String get fileNeedsColumns;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Barcodes can be 8, 12, 13 or 14 digits. Keep leading zeros by formatting the column as text.'**
  String get fileNeedsBarcodes;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'For figures, fill both carbonScoreGrams and recyclabilityPercent, and set verified to true or false.'**
  String get fileNeedsFigures;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Brands that don\'t exist yet are created for you.'**
  String get fileNeedsBrands;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Nothing is saved until you\'ve reviewed the check.'**
  String get fileNeedsReview;

  /// Same as the website's importProducts action.
  ///
  /// In en, this message translates to:
  /// **'Choose a CSV file to import.'**
  String get chooseCsvFirst;

  /// Same as the website's importProducts action.
  ///
  /// In en, this message translates to:
  /// **'{name} isn\'t a CSV file. Save the sheet as .csv and try again.'**
  String notCsvFile(String name);

  /// Same as the website's importProducts action.
  ///
  /// In en, this message translates to:
  /// **'The file is larger than 2 MB. Split it into smaller files.'**
  String get csvTooLarge;

  /// Same as the website's template route.
  ///
  /// In en, this message translates to:
  /// **'The template isn\'t available right now. Try again in a moment.'**
  String get templateUnavailable;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Ready to import 1 product} other{Ready to import {count} products}}'**
  String readyToImport(int count);

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this file can be imported'**
  String get nothingToImport;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Checked 1 row in {file}. Nothing has been saved yet.} other{Checked {count} rows in {file}. Nothing has been saved yet.}}'**
  String checkedRows(int count, String file);

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'New products'**
  String get statNewProducts;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get statUpdates;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'New brands'**
  String get statNewBrands;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Rows to fix'**
  String get statRowsToFix;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'New brands: {names}'**
  String newBrandsList(String names);

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 row will be skipped} other{{count} rows will be skipped}}'**
  String rowsSkipped(int count);

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Fix these lines in your spreadsheet and import the file again; rows already imported are just updated.'**
  String get rowsSkippedHint;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get columnLine;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get columnBarcode;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'What to fix'**
  String get columnFix;

  /// Same as the website's import flow. A row without a barcode.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get barcodeMissing;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Choose a different file'**
  String get chooseDifferentFile;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Import 1 product} other{Import {count} products}}'**
  String importProductCount(int count);

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Importing…'**
  String get importing;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Imported 1 product} other{Imported {count} products}}'**
  String importedCount(int count);

  /// Same as the website's import flow. Assembles the parts below, as the website does.
  ///
  /// In en, this message translates to:
  /// **'{added}, {updated}{brands}.{skipped}'**
  String importSummary(
    String added,
    String updated,
    String brands,
    String skipped,
  );

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new product} other{{count} new products}} added'**
  String importAdded(int count);

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}} updated'**
  String importUpdated(int count);

  /// Same as the website's import flow. Keep the leading comma.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{, 1 new brand created} other{, {count} new brands created}}'**
  String importBrandsCreated(int count);

  /// Same as the website's import flow. Keep the leading space.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{ 1 row with problems was skipped.} other{ {count} rows with problems were skipped.}}'**
  String importSkipped(int count);

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'View products'**
  String get viewProducts;

  /// Same as the website's import flow.
  ///
  /// In en, this message translates to:
  /// **'Import another file'**
  String get importAnotherFile;

  /// Same as the website's claims page header.
  ///
  /// In en, this message translates to:
  /// **'Ownership claims'**
  String get claimsTitle;

  /// Same as the website's claims page. Screen-reader label of the tabs.
  ///
  /// In en, this message translates to:
  /// **'Claim status'**
  String get claimStatusLabel;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get tabToReview;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get tabApproved;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get tabRejected;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review'**
  String get nothingToReview;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'Receipts shoppers upload appear here, oldest first.'**
  String get nothingToReviewBody;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'No approved claims yet'**
  String get noApprovedClaims;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'No rejected claims yet'**
  String get noRejectedClaims;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'Decisions you make will be listed here.'**
  String get decidedClaimsBody;

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'{name} ({email})'**
  String claimUserLine(String name, String email);

  /// Same as the website's claims page.
  ///
  /// In en, this message translates to:
  /// **'Order match'**
  String get methodOrderMatch;

  /// Same as the website's claims page. {attempt} is the upload number, or ? when unknown.
  ///
  /// In en, this message translates to:
  /// **'Receipt {attempt} of 5'**
  String receiptAttemptOf(String attempt);

  /// Count above the claims list (the app loads more as you scroll).
  ///
  /// In en, this message translates to:
  /// **'{total, plural, =1{Showing 1–{last} of {total} claim} other{Showing 1–{last} of {total} claims}}'**
  String showingClaims(int total, int last);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'{name}: {product}'**
  String claimTitle(String name, String product);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'Matched automatically to a paid order on {date}.'**
  String claimOrderMatched(String date);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'Receipt {attempt} of 5, sent {date}.'**
  String claimReceiptSent(String attempt, String date);

  /// Same as the website's claim review page. Website: 'in a new tab'; the app opens it in its own viewer.
  ///
  /// In en, this message translates to:
  /// **'Open the PDF receipt'**
  String get openPdfReceipt;

  /// Same as the website's claim review page. Website says 'Select'.
  ///
  /// In en, this message translates to:
  /// **'Tap the image to open it full size.'**
  String get tapReceiptFullSize;

  /// Same as the website's claim review page. Screen-reader label of the receipt image.
  ///
  /// In en, this message translates to:
  /// **'Receipt uploaded by {name}'**
  String receiptImageLabel(String name);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'No receipt: this claim was verified from order {order}.'**
  String noReceiptOrder(String order);

  /// Same as the website's claim review page. Used in noReceiptOrder when the order id is unknown.
  ///
  /// In en, this message translates to:
  /// **'on record'**
  String get orderOnRecord;

  /// Same as the website's receipt route.
  ///
  /// In en, this message translates to:
  /// **'This receipt isn\'t available.'**
  String get receiptUnavailable;

  /// App bar title of the full-screen receipt viewer.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receiptViewerTitle;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Your decision'**
  String get yourDecision;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Approving…'**
  String get approving;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Reason the shopper will see'**
  String get rejectReasonLabel;

  /// Same as the website's claim decision panel. Screen-reader label of the reason chips.
  ///
  /// In en, this message translates to:
  /// **'Common reasons'**
  String get commonReasonsLabel;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'The receipt is too blurry to read'**
  String get reasonBlurry;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'This product isn\'t on the receipt'**
  String get reasonProductMissing;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'The receipt is from a shop that doesn\'t sell this brand'**
  String get reasonWrongShop;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Part of the receipt is cut off'**
  String get reasonCutOff;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'This was their last upload: rejecting it means they can\'t verify this piece.'**
  String get lastUpload;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{They\'ll have 1 upload left.} other{They\'ll have {count} uploads left.}}'**
  String rejectUploadsLeft(int count);

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Reject receipt'**
  String get rejectReceipt;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Rejecting…'**
  String get rejecting;

  /// Same as the website's claim actions (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Approved. The shopper is now the verified owner.'**
  String get claimApproved;

  /// Same as the website's claim actions (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Rejected. The shopper will see your reason.'**
  String get claimRejected;

  /// Same as the website's claim actions (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Tell the shopper what was wrong so they can fix it'**
  String get reasonTooShort;

  /// Same as the website's claim actions (admin/actions.ts).
  ///
  /// In en, this message translates to:
  /// **'Keep the reason under 500 characters'**
  String get reasonTooLong;

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Approved {date}'**
  String claimDecidedApproved(String date);

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Rejected {date}'**
  String claimDecidedRejected(String date);

  /// Same as the website's claim decision panel. Keep the leading space.
  ///
  /// In en, this message translates to:
  /// **' by {name}'**
  String reviewedBy(String name);

  /// Same as the website's claim decision panel.
  ///
  /// In en, this message translates to:
  /// **'Reason given: “{reason}”'**
  String reasonGiven(String reason);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'What to check'**
  String get whatToCheck;

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'The shop or brand is {brand} or a stockist.'**
  String checkShop(String brand);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'A line on the receipt matches {product} (SKU {sku}).'**
  String checkLine(String product, String sku);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'It looks like a real, unedited receipt.'**
  String get checkReal;

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'Shopper'**
  String get shopperHeading;

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'All claims for this piece'**
  String get allClaimsForPiece;

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'Receipt {attempt}'**
  String historyReceipt(String attempt);

  /// Same as the website's claim review page. Keep the leading space.
  ///
  /// In en, this message translates to:
  /// **' (this one)'**
  String get thisOne;

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'Waiting since {date}'**
  String waitingSince(String date);

  /// Same as the website's claim review page.
  ///
  /// In en, this message translates to:
  /// **'“{text}”'**
  String quotedText(String text);

  /// Welcome screen main button (V2-1): sign in or sign up with a text-message code.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone number'**
  String get continueWithPhone;

  /// Welcome screen second button: the email and password sign-in.
  ///
  /// In en, this message translates to:
  /// **'Use email instead'**
  String get useEmailInstead;

  /// Phone sign-in screen heading.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get phoneTitle;

  /// Phone sign-in screen lede.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text you a 6-digit code. New to STAKA? The same code creates your account.'**
  String get phoneLede;

  /// Phone number field label.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get fieldPhone;

  /// Helper under the phone field.
  ///
  /// In en, this message translates to:
  /// **'A 10-digit Indian number, or start with + and the country code.'**
  String get phoneHelper;

  /// Phone field error.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number, or a number that starts with + and the country code.'**
  String get phoneInvalid;

  /// Phone sign-in button.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// Phone sign-in button while sending.
  ///
  /// In en, this message translates to:
  /// **'Sending code…'**
  String get sendingCode;

  /// Code screen heading.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get codeTitle;

  /// Code screen lede.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}. It works for {minutes, plural, =1{1 minute} other{{minutes} minutes}}.'**
  String codeLede(String phone, int minutes);

  /// Code field label (read by screen readers).
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get fieldCode;

  /// Code screen button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get checkCode;

  /// Code screen button while checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checkingCode;

  /// Link that sends a new code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// Countdown before a new code can be sent.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String resendCodeIn(String time);

  /// While a new code is being sent.
  ///
  /// In en, this message translates to:
  /// **'Sending a new code…'**
  String get resendingCode;

  /// Snackbar after a new code was sent.
  ///
  /// In en, this message translates to:
  /// **'We sent a new code.'**
  String get codeResent;

  /// Code screen link back to the phone number.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get changeNumber;

  /// Wrong code (API 401).
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. Check the message and try again.'**
  String get codeWrong;

  /// Expired or used-up code (API 410).
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Ask for a new one.'**
  String get codeExpired;

  /// Name screen heading for a new phone account.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get nameTitle;

  /// Name screen lede.
  ///
  /// In en, this message translates to:
  /// **'This is the name on your account. You can add an email later in Account.'**
  String get nameLede;

  /// Button when the sign-in code screens lost their state.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get startAgain;

  /// Phone sign-in screen: prompt before the link to email sign-in.
  ///
  /// In en, this message translates to:
  /// **'Signed up with email?'**
  String get signInWithEmailPrompt;

  /// Sign-in screen prompt above the phone link.
  ///
  /// In en, this message translates to:
  /// **'No email on your account?'**
  String get signInWithPhonePrompt;

  /// Sign-in screen link to phone sign-in.
  ///
  /// In en, this message translates to:
  /// **'Use your phone number'**
  String get signInWithPhone;

  /// Account screen: heading above phone, email and password.
  ///
  /// In en, this message translates to:
  /// **'How you sign in'**
  String get accountSectionSignIn;

  /// Account row and screen title: the phone number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get accountPhoneRow;

  /// Account row: the email address.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmailRow;

  /// Account row detail when there is no phone number or email yet.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get accountNotAdded;

  /// Account email row detail before the email is confirmed.
  ///
  /// In en, this message translates to:
  /// **'{email} · not confirmed yet'**
  String accountEmailUnconfirmed(String email);

  /// Account phone screen, when there is a number.
  ///
  /// In en, this message translates to:
  /// **'You sign in with {phone} and a 6-digit code we text you.'**
  String accountPhoneLede(String phone);

  /// Account phone screen, when there is no number.
  ///
  /// In en, this message translates to:
  /// **'Add a number to sign in with a 6-digit code we text you.'**
  String get accountPhoneAddLede;

  /// Account phone screen button: replace the number.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get accountPhoneChange;

  /// Account phone screen button and dialog action.
  ///
  /// In en, this message translates to:
  /// **'Remove number'**
  String get accountPhoneRemove;

  /// Account phone screen when removing the number would leave no way to sign in.
  ///
  /// In en, this message translates to:
  /// **'This number is how you sign in. To remove it, first add an email and set a password.'**
  String get accountPhoneOnlyWay;

  /// Remove phone number dialog title.
  ///
  /// In en, this message translates to:
  /// **'Remove {phone}?'**
  String accountPhoneRemoveTitle(String phone);

  /// Remove phone number dialog body.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to sign in with this number any more. You can add it again later.'**
  String get accountPhoneRemoveBody;

  /// Remove phone number dialog: cancel.
  ///
  /// In en, this message translates to:
  /// **'Keep number'**
  String get keepNumber;

  /// Button label while removing.
  ///
  /// In en, this message translates to:
  /// **'Removing…'**
  String get removing;

  /// Snackbar after adding or changing the phone number.
  ///
  /// In en, this message translates to:
  /// **'Phone number saved.'**
  String get accountPhoneSaved;

  /// Snackbar after removing the phone number.
  ///
  /// In en, this message translates to:
  /// **'Phone number removed.'**
  String get accountPhoneRemoved;

  /// Adding a phone number that another account has.
  ///
  /// In en, this message translates to:
  /// **'That number is on another STAKA account.'**
  String get phoneTaken;

  /// Add email screen heading.
  ///
  /// In en, this message translates to:
  /// **'Add an email'**
  String get addEmailTitle;

  /// Add email screen lede.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a link to confirm it. Then you can also sign in with your email and a password.'**
  String get addEmailLede;

  /// Add email button.
  ///
  /// In en, this message translates to:
  /// **'Add email'**
  String get addEmail;

  /// Add email button while sending.
  ///
  /// In en, this message translates to:
  /// **'Adding email…'**
  String get addingEmail;

  /// Adding an email that another account has.
  ///
  /// In en, this message translates to:
  /// **'An account already uses this email.'**
  String get emailTaken;

  /// Snackbar after adding an email.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox: we sent a confirmation link to {email}.'**
  String emailAdded(String email);

  /// Set password screen heading.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get setPasswordTitle;

  /// Set password screen lede when the account has an email.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email and this password, as well as with your phone.'**
  String get setPasswordLede;

  /// Set password screen lede when the account has no email.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need an email too, to sign in with a password. You can add one in Account.'**
  String get setPasswordLedeNoEmail;

  /// Set password button.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get setPassword;

  /// Set password button while sending.
  ///
  /// In en, this message translates to:
  /// **'Setting password…'**
  String get settingPassword;

  /// Snackbar after setting a first password.
  ///
  /// In en, this message translates to:
  /// **'Password set.'**
  String get passwordSet;

  /// Account screen: heading above download and delete.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get accountSectionData;

  /// Account row: export the account's data.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get downloadData;

  /// Account row detail under Download my data.
  ///
  /// In en, this message translates to:
  /// **'Your profile, tags and claims as a file'**
  String get downloadDataDetail;

  /// Account row, and the delete screen's button.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccount;

  /// Delete account screen heading.
  ///
  /// In en, this message translates to:
  /// **'Delete your account'**
  String get deleteAccountTitle;

  /// Delete account screen lede.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone. Download your data first if you want a copy.'**
  String get deleteAccountLede;

  /// Delete account: what happens (1).
  ///
  /// In en, this message translates to:
  /// **'Your name, email and phone number are removed from STAKA.'**
  String get deleteAccountRemovesProfile;

  /// Delete account: what happens (2).
  ///
  /// In en, this message translates to:
  /// **'Your tags and share links stop working.'**
  String get deleteAccountStopsShares;

  /// Delete account: what happens (3).
  ///
  /// In en, this message translates to:
  /// **'Your receipts are deleted once we no longer have to keep them.'**
  String get deleteAccountDeletesReceipts;

  /// Delete account: what happens (4).
  ///
  /// In en, this message translates to:
  /// **'You\'re signed out on every device.'**
  String get deleteAccountSignsOut;

  /// Delete account: above the password field.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm.'**
  String get deleteAccountConfirmPassword;

  /// Delete account for an account without a password.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text a code to {phone} to confirm.'**
  String deleteAccountConfirmCode(String phone);

  /// Delete button while deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting account…'**
  String get deletingAccount;

  /// Delete account: wrong password.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t your password. Check it and try again.'**
  String get deleteAccountWrongPassword;

  /// Shown on the welcome screen after deleting the account.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;

  /// Account: section heading for the brand sign-up row.
  ///
  /// In en, this message translates to:
  /// **'For brands'**
  String get accountSectionBrands;

  /// Account row and screen title: apply to run a brand on STAKA (V2-12).
  ///
  /// In en, this message translates to:
  /// **'Bring your brand to STAKA'**
  String get bringYourBrand;

  /// Account: under the brand sign-up row.
  ///
  /// In en, this message translates to:
  /// **'Apply, or see how your application is going'**
  String get bringYourBrandDetail;

  /// Brand sign-up intro: first paragraph.
  ///
  /// In en, this message translates to:
  /// **'Once STAKA has checked your details, your team runs your brand here: no waiting on us.'**
  String get brandApplyIntroBody;

  /// Brand sign-up intro: what a brand gets (1).
  ///
  /// In en, this message translates to:
  /// **'Add your products and their sustainability figures.'**
  String get brandApplyBenefitCatalog;

  /// Brand sign-up intro: what a brand gets (2).
  ///
  /// In en, this message translates to:
  /// **'Check your shoppers\' proofs of purchase yourself.'**
  String get brandApplyBenefitClaims;

  /// Brand sign-up intro: what a brand gets (3).
  ///
  /// In en, this message translates to:
  /// **'Reward the people who buy and keep your clothes.'**
  String get brandApplyBenefitRewards;

  /// Brand sign-up intro: heading above what to have ready.
  ///
  /// In en, this message translates to:
  /// **'What we need'**
  String get brandApplyNeedsTitle;

  /// Brand sign-up intro: what to have ready.
  ///
  /// In en, this message translates to:
  /// **'Your brand\'s legal name and a contact email. A business document, such as your GST certificate, helps us check faster.'**
  String get brandApplyNeedsBody;

  /// Brand sign-up intro: button that opens the form.
  ///
  /// In en, this message translates to:
  /// **'Start your application'**
  String get brandApplyStart;

  /// Brand applications list: button under the list.
  ///
  /// In en, this message translates to:
  /// **'Apply for another brand'**
  String get brandApplyAnother;

  /// Brand application status chip: sent, not yet checked.
  ///
  /// In en, this message translates to:
  /// **'Being checked'**
  String get brandStatusPending;

  /// Brand application status chip: approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get brandStatusApproved;

  /// Brand application status chip: rejected.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get brandStatusRejected;

  /// Brand status chip: STAKA paused an approved brand.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get brandStatusSuspended;

  /// Brand application card: pending.
  ///
  /// In en, this message translates to:
  /// **'We\'re checking your details and will let you know.'**
  String get brandStatusPendingBody;

  /// Brand application card: approved.
  ///
  /// In en, this message translates to:
  /// **'{brand} is on STAKA. Your team can now run it.'**
  String brandStatusApprovedBody(String brand);

  /// Brand application card: rejected.
  ///
  /// In en, this message translates to:
  /// **'STAKA couldn\'t approve this application. Fix what\'s needed and send it again.'**
  String get brandStatusRejectedBody;

  /// Brand card: suspended.
  ///
  /// In en, this message translates to:
  /// **'STAKA has paused {brand}. Its products stay visible to shoppers.'**
  String brandStatusSuspendedBody(String brand);

  /// Brand application card: why STAKA rejected or paused it.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String brandStatusReason(String reason);

  /// Brand application card: when it was sent, e.g. "Applied 14 Nov 2026".
  ///
  /// In en, this message translates to:
  /// **'Applied {date}'**
  String brandAppliedOn(String date);

  /// Brand application card (rejected): opens the form to fix and resend.
  ///
  /// In en, this message translates to:
  /// **'Edit and resubmit'**
  String get brandEditAndResubmit;

  /// Brand application form: screen title.
  ///
  /// In en, this message translates to:
  /// **'Apply for your brand'**
  String get brandApplyTitle;

  /// Brand application form when resubmitting: screen title.
  ///
  /// In en, this message translates to:
  /// **'Edit your application'**
  String get brandEditTitle;

  /// Brand application form: progress above the step heading.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String brandApplyStepOf(int step, int total);

  /// Brand application form: step 1 heading.
  ///
  /// In en, this message translates to:
  /// **'Your brand'**
  String get brandStepBrand;

  /// Brand application form: step 2 heading.
  ///
  /// In en, this message translates to:
  /// **'How we reach you'**
  String get brandStepContact;

  /// Brand application form: step 2 text.
  ///
  /// In en, this message translates to:
  /// **'STAKA uses these only about your brand.'**
  String get brandStepContactBody;

  /// Brand application form: step 3 heading.
  ///
  /// In en, this message translates to:
  /// **'Logo and documents'**
  String get brandStepFiles;

  /// Brand application form: switch to claim a brand STAKA already lists.
  ///
  /// In en, this message translates to:
  /// **'My brand is already on STAKA'**
  String get brandAlreadyListed;

  /// Brand application form: under the claim switch.
  ///
  /// In en, this message translates to:
  /// **'Pick it to take it over with its products.'**
  String get brandAlreadyListedHint;

  /// Brand application form: brand list hint and its error.
  ///
  /// In en, this message translates to:
  /// **'Choose your brand'**
  String get chooseYourBrand;

  /// Brand application form: the brand list failed to load.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the brands on STAKA.'**
  String get listedBrandsFailed;

  /// Brand application form: registered company name.
  ///
  /// In en, this message translates to:
  /// **'Legal name'**
  String get fieldLegalName;

  /// Brand application form: under Legal name.
  ///
  /// In en, this message translates to:
  /// **'As on your business registration.'**
  String get legalNameHint;

  /// Brand application form: legal name empty.
  ///
  /// In en, this message translates to:
  /// **'Enter your brand\'s legal name'**
  String get validationLegalName;

  /// Brand application form: brand website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get fieldWebsite;

  /// Brand application form: website placeholder.
  ///
  /// In en, this message translates to:
  /// **'https://yourbrand.com'**
  String get websitePlaceholder;

  /// Brand application form: Indian GST number.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get fieldGstin;

  /// Brand application form: under GSTIN.
  ///
  /// In en, this message translates to:
  /// **'Optional. 15 characters, e.g. 22AAAAA0000A1Z5.'**
  String get gstinHint;

  /// Brand application form: GSTIN in the wrong format.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 15-character GSTIN'**
  String get validationGstin;

  /// Brand application form: email STAKA writes to about the brand.
  ///
  /// In en, this message translates to:
  /// **'Contact email'**
  String get fieldContactEmail;

  /// Brand application form: phone STAKA calls about the brand.
  ///
  /// In en, this message translates to:
  /// **'Contact phone'**
  String get fieldContactPhone;

  /// Brand application form: logo heading.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get brandLogo;

  /// Brand application form: logo help.
  ///
  /// In en, this message translates to:
  /// **'A square image, up to 2 MB. Optional.'**
  String get brandLogoHint;

  /// Brand application form: pick a logo from photos.
  ///
  /// In en, this message translates to:
  /// **'Choose logo'**
  String get chooseLogo;

  /// Brand application form: logo over the limit.
  ///
  /// In en, this message translates to:
  /// **'That image is larger than 2 MB. Choose a smaller one.'**
  String get logoTooLarge;

  /// Brand application form when resubmitting: a logo was sent before.
  ///
  /// In en, this message translates to:
  /// **'Leave this to keep the logo you sent.'**
  String get logoKept;

  /// Brand application form: business document heading.
  ///
  /// In en, this message translates to:
  /// **'Business document'**
  String get businessDocument;

  /// Brand application form: business document help.
  ///
  /// In en, this message translates to:
  /// **'GST certificate or company registration, as a PDF or photo, up to 5 MB. Optional, but it helps us check faster.'**
  String get businessDocumentHint;

  /// Brand application form: pick a business document.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addDocument;

  /// Brand application form: document over the limit.
  ///
  /// In en, this message translates to:
  /// **'That file is larger than 5 MB. Choose a smaller one.'**
  String get documentTooLarge;

  /// Brand application form when resubmitting.
  ///
  /// In en, this message translates to:
  /// **'Leave this to keep the document you sent, if any.'**
  String get documentKept;

  /// Brand application form: pick another file instead.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replaceFile;

  /// Brand application form: drop the picked file.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeFile;

  /// Brand application form: go to the next step.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueStep;

  /// Brand application form: last step button.
  ///
  /// In en, this message translates to:
  /// **'Send application'**
  String get sendApplication;

  /// Brand application form: button while sending.
  ///
  /// In en, this message translates to:
  /// **'Sending application…'**
  String get sendingApplication;

  /// Snackbar after sending a brand application.
  ///
  /// In en, this message translates to:
  /// **'Application sent. We\'ll let you know when STAKA has checked it.'**
  String get applicationSent;

  /// Brand application form: the API refused the name (409).
  ///
  /// In en, this message translates to:
  /// **'A brand with this name already runs itself on STAKA.'**
  String get brandNameOnStaka;

  /// Brand application edit: the id is not in the list.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that application.'**
  String get applicationNotFound;

  /// Brand application edit: under "We couldn't find that application."
  ///
  /// In en, this message translates to:
  /// **'It may have been withdrawn. Go back to see your applications.'**
  String get applicationNotFoundBody;

  /// Brand application form: under About the brand (the applicant describes their own brand).
  ///
  /// In en, this message translates to:
  /// **'Optional. One sentence on what you make and how.'**
  String get aboutYourBrandHint;

  /// Bottom bar tab for members of an approved brand (V2-12).
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get navBrand;

  /// Brand role: runs the team and settings too.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get brandRoleOwner;

  /// Brand role: products, import and claims.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get brandRoleStaff;

  /// Brand tab: opens the list of the person's brands.
  ///
  /// In en, this message translates to:
  /// **'Switch brand'**
  String get switchBrand;

  /// Brand switcher sheet: heading.
  ///
  /// In en, this message translates to:
  /// **'Your brands'**
  String get yourBrands;

  /// Brand tab: the brand is suspended.
  ///
  /// In en, this message translates to:
  /// **'STAKA has paused {brand}. Its products stay visible to shoppers, but your team can\'t make changes until STAKA reinstates it.'**
  String brandSuspendedBanner(String brand);

  /// Brand tab, paused brand: opens the application with the reason.
  ///
  /// In en, this message translates to:
  /// **'See why'**
  String get seeWhy;

  /// Brand hub: Products row.
  ///
  /// In en, this message translates to:
  /// **'Your products and their sustainability figures. A product\'s tag shows exactly what\'s recorded here.'**
  String get brandProductsDescription;

  /// Brand hub: Import row.
  ///
  /// In en, this message translates to:
  /// **'Add or update many of your products at once from a spreadsheet saved as CSV.'**
  String get brandImportDescription;

  /// Brand hub row and Team screen title.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get brandTeam;

  /// Brand hub: Team row.
  ///
  /// In en, this message translates to:
  /// **'Who runs {brand} with you.'**
  String brandTeamDescription(String brand);

  /// Brand hub row and Settings screen title (owners only).
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get brandSettings;

  /// Brand hub: Settings row.
  ///
  /// In en, this message translates to:
  /// **'Name, logo, description, website and contacts.'**
  String get brandSettingsDescription;

  /// Team screen: button for owners.
  ///
  /// In en, this message translates to:
  /// **'Invite someone'**
  String get inviteSomeone;

  /// Invite sheet: heading.
  ///
  /// In en, this message translates to:
  /// **'Invite to {brand}'**
  String inviteTitle(String brand);

  /// Invite sheet: text under the heading.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send them a link to join. They sign in to STAKA, or make an account, to accept it.'**
  String get inviteBody;

  /// Invite sheet: who to invite.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get fieldEmailOrPhone;

  /// Invite sheet: neither an email nor a number.
  ///
  /// In en, this message translates to:
  /// **'Enter an email address or a mobile number'**
  String get validationEmailOrPhone;

  /// Invite sheet: role choice label.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get inviteRole;

  /// Invite sheet: what an owner can do.
  ///
  /// In en, this message translates to:
  /// **'Also runs the team and settings.'**
  String get roleOwnerHint;

  /// Invite sheet: what staff can do.
  ///
  /// In en, this message translates to:
  /// **'Works on products, import and claims.'**
  String get roleStaffHint;

  /// Invite sheet: button.
  ///
  /// In en, this message translates to:
  /// **'Send invite'**
  String get sendInvite;

  /// Invite sheet: button while sending.
  ///
  /// In en, this message translates to:
  /// **'Sending invite…'**
  String get sendingInvite;

  /// Snackbar after an invite.
  ///
  /// In en, this message translates to:
  /// **'Invite sent to {who}.'**
  String inviteSent(String who);

  /// Team list: the signed-in person.
  ///
  /// In en, this message translates to:
  /// **'{name} (you)'**
  String memberYou(String name);

  /// Team list: remove button for screen readers.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the team'**
  String removeFromTeam(String name);

  /// Remove member dialog: heading.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String removeMemberTitle(String name);

  /// Remove member dialog: text.
  ///
  /// In en, this message translates to:
  /// **'They can no longer work on {brand}. You can invite them again later.'**
  String removeMemberBody(String brand);

  /// Remove member dialog: confirm button.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeMember;

  /// Remove member dialog: button while removing.
  ///
  /// In en, this message translates to:
  /// **'Removing…'**
  String get removingMember;

  /// Snackbar after removing a member.
  ///
  /// In en, this message translates to:
  /// **'{name} is no longer on the team.'**
  String memberRemoved(String name);

  /// Team screen for staff.
  ///
  /// In en, this message translates to:
  /// **'Only owners can invite or remove people.'**
  String get teamStaffNote;

  /// Approved application card: go to the brand portal.
  ///
  /// In en, this message translates to:
  /// **'Open the Brand tab'**
  String get openBrandTab;

  /// Approved card: the session does not list the brand yet.
  ///
  /// In en, this message translates to:
  /// **'Your brand isn\'t ready yet. Try again in a moment.'**
  String get brandNotReadyYet;

  /// Brand claims list: under the heading.
  ///
  /// In en, this message translates to:
  /// **'Shoppers who bought your products send a receipt. Approve it when it shows they bought this product: they become its verified owner. Order matches are approved automatically.'**
  String get brandClaimsDescription;

  /// Brand hub: Claims row when the count is unknown.
  ///
  /// In en, this message translates to:
  /// **'Check the proofs of purchase for your products.'**
  String get brandClaimsHubDescription;

  /// Brand hub: Claims row with how many wait.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing waiting. Proofs of purchase for your products show up here.} =1{1 proof of purchase is waiting for you.} other{{count} proofs of purchase are waiting for you.}}'**
  String brandClaimsWaiting(int count);

  /// Tag: verified by a receipt, naming who approved it (a brand or STAKA).
  ///
  /// In en, this message translates to:
  /// **'{decider} approved your receipt on {date}. It counts toward your wardrobe.'**
  String verifiedByDeciderOn(String decider, String date);

  /// Tag: verified by a receipt, undated.
  ///
  /// In en, this message translates to:
  /// **'{decider} approved your receipt. It counts toward your wardrobe.'**
  String verifiedByDecider(String decider);

  /// Tag: verified after the shopper asked STAKA to look again.
  ///
  /// In en, this message translates to:
  /// **'STAKA looked again and approved your receipt. It counts toward your wardrobe.'**
  String get verifiedAfterLookAgain;

  /// Tag: receipt waiting for the brand.
  ///
  /// In en, this message translates to:
  /// **'Sent {date}. Waiting for {brand} to check it; the result shows up here. {uploadsLeft}'**
  String pendingForBrand(String date, String brand, String uploadsLeft);

  /// Tag: receipt waiting for the brand, undated.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {brand} to check it; the result shows up here. {uploadsLeft}'**
  String pendingForBrandUndated(String brand, String uploadsLeft);

  /// Tag: the last receipt was turned down, naming who decided.
  ///
  /// In en, this message translates to:
  /// **'{decider} couldn\'t accept this receipt: {reason}. {uploadsLeft}'**
  String receiptRejectedBy(String decider, String reason, String uploadsLeft);

  /// Tag: blocked, naming who turned the last receipt down.
  ///
  /// In en, this message translates to:
  /// **'All 5 receipt uploads for it were used. {decider} couldn\'t accept the last one: {reason}. You can still keep its tag.'**
  String blockedBodyBy(String decider, String reason);

  /// Stands in for a brand name the API did not send, mid-sentence.
  ///
  /// In en, this message translates to:
  /// **'the brand'**
  String get theBrand;

  /// Tag: above Ask STAKA to look again.
  ///
  /// In en, this message translates to:
  /// **'Think {brand} got it wrong? STAKA can check the receipt again.'**
  String lookAgainLede(String brand);

  /// Tag: button and sheet title after a brand rejected the receipt.
  ///
  /// In en, this message translates to:
  /// **'Ask STAKA to look again'**
  String get askStakaToLookAgain;

  /// Tag: the shopper asked STAKA to look again.
  ///
  /// In en, this message translates to:
  /// **'STAKA is looking at this'**
  String get lookAgainOpenTitle;

  /// Tag: under STAKA is looking at this.
  ///
  /// In en, this message translates to:
  /// **'We\'ll check your receipt and the reason {brand} gave. The result shows up here.'**
  String lookAgainOpenBody(String brand);

  /// Tag: STAKA kept the brand decision.
  ///
  /// In en, this message translates to:
  /// **'STAKA looked again'**
  String get lookAgainUpheldTitle;

  /// Tag: STAKA kept the brand decision, with STAKA's note.
  ///
  /// In en, this message translates to:
  /// **'STAKA agrees with {brand}: {note}'**
  String lookAgainUpheld(String brand, String note);

  /// Tag: STAKA kept the brand decision, no note.
  ///
  /// In en, this message translates to:
  /// **'STAKA agrees with {brand}.'**
  String lookAgainUpheldNoNote(String brand);

  /// Ask STAKA sheet: under the title.
  ///
  /// In en, this message translates to:
  /// **'Tell us why this receipt shows you bought {product}. STAKA reads your message with the receipt and the reason {brand} gave, then decides. You can ask once.'**
  String lookAgainSheetBody(String product, String brand);

  /// Ask STAKA sheet: message field.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get fieldLookAgainMessage;

  /// Ask STAKA sheet: under the message field.
  ///
  /// In en, this message translates to:
  /// **'10 to 1,000 characters.'**
  String get lookAgainHelper;

  /// Ask STAKA sheet: message too short.
  ///
  /// In en, this message translates to:
  /// **'Write at least 10 characters.'**
  String get validationLookAgainShort;

  /// Ask STAKA sheet: message too long.
  ///
  /// In en, this message translates to:
  /// **'Keep it to 1,000 characters.'**
  String get validationLookAgainLong;

  /// Ask STAKA sheet: send button.
  ///
  /// In en, this message translates to:
  /// **'Send to STAKA'**
  String get sendToStaka;

  /// Ask STAKA sheet: send button while sending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sendingToStaka;

  /// Snackbar after asking STAKA to look again.
  ///
  /// In en, this message translates to:
  /// **'Sent. STAKA is looking at this.'**
  String get lookAgainSent;

  /// Tag: upload a receipt, when the API names the brand that checks it.
  ///
  /// In en, this message translates to:
  /// **'A clear photo or PDF showing the shop, the date and this piece. {brand} checks it. {uploadsLeft}'**
  String receiptBodyForBrand(String brand, String uploadsLeft);

  /// Admin products: under the heading (read-only, V2-12).
  ///
  /// In en, this message translates to:
  /// **'Every brand\'s products. Brands add and edit their own; tap one to hide it from shoppers or show it again.'**
  String get adminProductsReadOnlyDescription;

  /// Admin products: empty catalog.
  ///
  /// In en, this message translates to:
  /// **'Brands add their products from their Brand tab. They show up here.'**
  String get noProductsAdminBody;

  /// Admin products: pill on a product hidden from shoppers.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hiddenFromShoppers;

  /// Hide product dialog: title.
  ///
  /// In en, this message translates to:
  /// **'Hide {name}?'**
  String hideProductTitle(String name);

  /// Hide product dialog: body.
  ///
  /// In en, this message translates to:
  /// **'Shoppers won\'t see it on STAKA until you show it again. {brand} still sees it in its Brand tab.'**
  String hideProductBody(String brand);

  /// Hide product dialog: confirm.
  ///
  /// In en, this message translates to:
  /// **'Hide product'**
  String get hideProduct;

  /// Show product dialog: title.
  ///
  /// In en, this message translates to:
  /// **'Show {name} again?'**
  String showProductTitle(String name);

  /// Show product dialog: body.
  ///
  /// In en, this message translates to:
  /// **'Shoppers can find it on STAKA again.'**
  String get showProductBody;

  /// Show product dialog: confirm.
  ///
  /// In en, this message translates to:
  /// **'Show product'**
  String get showProduct;

  /// Snackbar after hiding a product.
  ///
  /// In en, this message translates to:
  /// **'{name} is hidden from shoppers.'**
  String productHidden(String name);

  /// Snackbar after showing a product again.
  ///
  /// In en, this message translates to:
  /// **'Shoppers can see {name} again.'**
  String productShown(String name);

  /// Reason or note sheet: too short.
  ///
  /// In en, this message translates to:
  /// **'Write at least 3 characters.'**
  String get noteTooShort;

  /// Reason or note sheet: too long.
  ///
  /// In en, this message translates to:
  /// **'Keep it to 500 characters.'**
  String get noteTooLong;

  /// Admin brands: under the heading (V2-12).
  ///
  /// In en, this message translates to:
  /// **'Brands apply to run themselves on STAKA. Check each application and its business document, then approve it or turn it down. Pause a brand that breaks the rules.'**
  String get adminBrandsReviewDescription;

  /// Admin brands tab: applications waiting.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get brandReviewPending;

  /// Admin brands tab and pill: approved brands.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get brandReviewActive;

  /// Admin brands tab and pill: suspended brands.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get brandReviewSuspended;

  /// Admin brands tab and pill: rejected applications.
  ///
  /// In en, this message translates to:
  /// **'Turned down'**
  String get brandReviewRejected;

  /// Admin brands: the status tabs, for screen readers.
  ///
  /// In en, this message translates to:
  /// **'Brand status'**
  String get brandStatusLabel;

  /// Admin brands: empty tab.
  ///
  /// In en, this message translates to:
  /// **'{status, select, pending{No applications are waiting.} approved{No active brands yet.} suspended{No paused brands.} other{No turned-down applications.}}'**
  String noBrandsInStatus(String status);

  /// Admin brands: when a brand applied.
  ///
  /// In en, this message translates to:
  /// **'Applied {date}'**
  String appliedOn(String date);

  /// Admin brands: how many people run a brand.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No team yet} =1{1 person} other{{count} people}}'**
  String brandMembers(int count);

  /// Admin brand: the brand description.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTheBrand;

  /// Admin brand: application date heading.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get appliedHeading;

  /// Admin brand: members heading.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamHeading;

  /// Admin brand: the application claims a listed brand.
  ///
  /// In en, this message translates to:
  /// **'Already on STAKA'**
  String get listedBrandHeading;

  /// Admin brand: what claiming a listed brand means.
  ///
  /// In en, this message translates to:
  /// **'Says it owns a brand STAKA already lists. Approving gives its team that brand and its products.'**
  String get claimsListedBrand;

  /// Admin brand: opens the private document.
  ///
  /// In en, this message translates to:
  /// **'View business document'**
  String get viewBusinessDocument;

  /// Admin brand: none sent.
  ///
  /// In en, this message translates to:
  /// **'No business document was sent.'**
  String get noBusinessDocument;

  /// Brand document viewer: title.
  ///
  /// In en, this message translates to:
  /// **'Business document'**
  String get businessDocumentTitle;

  /// Brand document viewer: failed.
  ///
  /// In en, this message translates to:
  /// **'The document couldn\'t be loaded.'**
  String get documentUnavailable;

  /// Admin brand: approve an application.
  ///
  /// In en, this message translates to:
  /// **'Approve brand'**
  String get approveBrand;

  /// Admin brand: reject an application.
  ///
  /// In en, this message translates to:
  /// **'Turn down'**
  String get rejectBrand;

  /// Reject brand sheet: title.
  ///
  /// In en, this message translates to:
  /// **'Turn down {brand}?'**
  String rejectBrandTitle(String brand);

  /// Reject brand sheet: body.
  ///
  /// In en, this message translates to:
  /// **'Its owners see your reason and can fix the application and send it again.'**
  String get rejectBrandBody;

  /// Admin brand: suspend an active brand.
  ///
  /// In en, this message translates to:
  /// **'Pause brand'**
  String get suspendBrand;

  /// Suspend brand sheet: title.
  ///
  /// In en, this message translates to:
  /// **'Pause {brand}?'**
  String suspendBrandTitle(String brand);

  /// Suspend brand sheet: body.
  ///
  /// In en, this message translates to:
  /// **'Its team can\'t use the Brand tab until you make it active again, and sees your reason. Its products stay visible to shoppers.'**
  String get suspendBrandBody;

  /// Admin brand: reinstate a paused brand.
  ///
  /// In en, this message translates to:
  /// **'Make active again'**
  String get reinstateBrand;

  /// Reject and suspend sheets: the field.
  ///
  /// In en, this message translates to:
  /// **'Reason the brand will see'**
  String get reasonForBrand;

  /// Admin brand: rejected, nothing to decide.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the brand to fix its application and send it again.'**
  String get rejectedBrandWaits;

  /// Snackbar after approving a brand.
  ///
  /// In en, this message translates to:
  /// **'{brand} is approved. Its team can now run it.'**
  String brandApproved(String brand);

  /// Snackbar after rejecting a brand.
  ///
  /// In en, this message translates to:
  /// **'{brand} was turned down. Its owners see your reason.'**
  String brandRejected(String brand);

  /// Snackbar after suspending a brand.
  ///
  /// In en, this message translates to:
  /// **'{brand} is paused.'**
  String brandSuspended(String brand);

  /// Snackbar after reinstating a brand.
  ///
  /// In en, this message translates to:
  /// **'{brand} is active again.'**
  String brandReinstated(String brand);

  /// Admin hub and page: shoppers asking STAKA to look again.
  ///
  /// In en, this message translates to:
  /// **'Disputes'**
  String get adminDisputes;

  /// Admin disputes: under the heading.
  ///
  /// In en, this message translates to:
  /// **'Shoppers who think a brand wrongly turned their receipt down. Read their message and the receipt, then keep the decision or approve it.'**
  String get adminDisputesDescription;

  /// Disputes tab: open.
  ///
  /// In en, this message translates to:
  /// **'To decide'**
  String get disputeOpen;

  /// Disputes tab: the brand decision was kept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get disputeUpheld;

  /// Disputes tab: the receipt was approved after all.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get disputeOverturned;

  /// Disputes: the status tabs, for screen readers.
  ///
  /// In en, this message translates to:
  /// **'Dispute status'**
  String get disputeStatusLabel;

  /// Disputes: empty tab.
  ///
  /// In en, this message translates to:
  /// **'{status, select, open{No disputes are waiting.} upheld{No kept decisions yet.} other{No approved disputes yet.}}'**
  String noDisputesInStatus(String status);

  /// Disputes row: the piece and its brand.
  ///
  /// In en, this message translates to:
  /// **'{product} · {brand}'**
  String disputeRowTitle(String product, String brand);

  /// Disputes row when the API sends no claim.
  ///
  /// In en, this message translates to:
  /// **'Receipt turned down by a brand'**
  String get disputeRowUntitled;

  /// Stands in for a shopper name the API did not send.
  ///
  /// In en, this message translates to:
  /// **'A shopper'**
  String get aShopper;

  /// Disputes: who asked and when.
  ///
  /// In en, this message translates to:
  /// **'{name} asked {date}'**
  String disputeAsked(String name, String date);

  /// Dispute: heading over the message.
  ///
  /// In en, this message translates to:
  /// **'What the shopper wrote'**
  String get shopperWrote;

  /// Dispute: heading over the brand's reason.
  ///
  /// In en, this message translates to:
  /// **'Why {brand} turned it down'**
  String brandReasonHeading(String brand);

  /// Dispute: overturn the brand decision.
  ///
  /// In en, this message translates to:
  /// **'Approve the receipt'**
  String get overturn;

  /// Dispute: uphold the brand decision.
  ///
  /// In en, this message translates to:
  /// **'Keep the decision'**
  String get uphold;

  /// Overturn sheet: title.
  ///
  /// In en, this message translates to:
  /// **'Approve this receipt?'**
  String get overturnTitle;

  /// Overturn sheet: body.
  ///
  /// In en, this message translates to:
  /// **'The shopper becomes the verified owner and gets the points. {brand} and the shopper see your note.'**
  String overturnBody(String brand);

  /// Uphold sheet: title.
  ///
  /// In en, this message translates to:
  /// **'Keep {brand}\'s decision?'**
  String upholdTitle(String brand);

  /// Uphold sheet: body.
  ///
  /// In en, this message translates to:
  /// **'The receipt stays turned down and the shopper can\'t ask again. They see your note.'**
  String get upholdBody;

  /// Dispute sheets: the field.
  ///
  /// In en, this message translates to:
  /// **'Note the shopper will see'**
  String get noteForShopper;

  /// Snackbar after overturning.
  ///
  /// In en, this message translates to:
  /// **'Approved. The shopper is now the verified owner.'**
  String get disputeOverturnedDone;

  /// Snackbar after upholding.
  ///
  /// In en, this message translates to:
  /// **'Decision kept. The shopper sees your note.'**
  String get disputeUpheldDone;

  /// Dispute settled: overturned.
  ///
  /// In en, this message translates to:
  /// **'You approved the receipt on {date}.'**
  String overturnedOn(String date);

  /// Dispute settled: overturned, no date.
  ///
  /// In en, this message translates to:
  /// **'The receipt was approved.'**
  String get overturnedUndated;

  /// Dispute settled: upheld.
  ///
  /// In en, this message translates to:
  /// **'The brand\'s decision was kept on {date}.'**
  String upheldOn(String date);

  /// Dispute settled: upheld, no date.
  ///
  /// In en, this message translates to:
  /// **'The brand\'s decision was kept.'**
  String get upheldUndated;

  /// Dispute settled: the note.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String noteSaid(String note);

  /// Claims: the shopper asked STAKA to look again.
  ///
  /// In en, this message translates to:
  /// **'Disputed by the shopper'**
  String get disputedByShopper;

  /// Admin claim: the overrule panel heading.
  ///
  /// In en, this message translates to:
  /// **'Overrule {brand}'**
  String overruleHeading(String brand);

  /// Admin claim: pending, why to overrule.
  ///
  /// In en, this message translates to:
  /// **'{brand} checks this claim. Decide here only when it is stuck, for example a paused brand or one with no team.'**
  String overrulePendingHint(String brand);

  /// Admin claim: decided, why to overrule.
  ///
  /// In en, this message translates to:
  /// **'Change what {brand} decided only when it was clearly wrong. Your reason is recorded.'**
  String overruleDecidedHint(String brand);

  /// Admin claim: overrule to approve.
  ///
  /// In en, this message translates to:
  /// **'Approve instead'**
  String get overruleApprove;

  /// Admin claim: overrule to reject.
  ///
  /// In en, this message translates to:
  /// **'Reject instead'**
  String get overruleReject;

  /// Overrule sheet: approve title.
  ///
  /// In en, this message translates to:
  /// **'Approve this claim?'**
  String get overruleApproveTitle;

  /// Overrule sheet: reject title.
  ///
  /// In en, this message translates to:
  /// **'Reject this claim?'**
  String get overruleRejectTitle;

  /// Overrule sheet: body.
  ///
  /// In en, this message translates to:
  /// **'{brand} and the shopper see your reason. It is recorded with your name.'**
  String overruleBody(String brand);

  /// Overrule sheet: the field.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get overruleReason;

  /// Admin claims list: under the heading (V2-12).
  ///
  /// In en, this message translates to:
  /// **'Every brand\'s claims. Brands approve or reject their own; overrule one only when it is stuck or clearly wrong.'**
  String get adminClaimsReadOnlyDescription;

  /// Admin hub: Brands row with how many wait.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No applications waiting.} =1{1 application is waiting.} other{{count} applications are waiting.}}'**
  String adminBrandsWaiting(int count);

  /// Admin hub: Disputes row with how many wait.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No disputes waiting.} =1{1 dispute is waiting.} other{{count} disputes are waiting.}}'**
  String adminDisputesWaiting(int count);

  /// No description provided for @categoryTops.
  ///
  /// In en, this message translates to:
  /// **'Tops'**
  String get categoryTops;

  /// No description provided for @categoryBottoms.
  ///
  /// In en, this message translates to:
  /// **'Bottoms'**
  String get categoryBottoms;

  /// No description provided for @categoryDresses.
  ///
  /// In en, this message translates to:
  /// **'Dresses'**
  String get categoryDresses;

  /// No description provided for @categoryOuterwear.
  ///
  /// In en, this message translates to:
  /// **'Outerwear'**
  String get categoryOuterwear;

  /// No description provided for @categoryFootwear.
  ///
  /// In en, this message translates to:
  /// **'Footwear'**
  String get categoryFootwear;

  /// No description provided for @categoryAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get categoryAccessories;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// A product variant's size, e.g. Size M.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String variantSize(String size);

  /// Size and colour together, e.g. Size M · Navy.
  ///
  /// In en, this message translates to:
  /// **'{first} · {second}'**
  String variantDetails(String first, String second);

  /// Screen reader label for a product's category chip.
  ///
  /// In en, this message translates to:
  /// **'Type: {category}'**
  String categoryLabel(String category);

  /// No description provided for @wardrobeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wardrobeFilterAll;

  /// No description provided for @wardrobeFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Show pieces by type'**
  String get wardrobeFilterLabel;

  /// No description provided for @wardrobeFilterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No {category} in your wardrobe yet.'**
  String wardrobeFilterEmpty(String category);

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Type of piece'**
  String get fieldCategory;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'Shoppers can sort their wardrobe by it.'**
  String get categoryHint;

  /// No description provided for @fieldStyleCode.
  ///
  /// In en, this message translates to:
  /// **'Style code'**
  String get fieldStyleCode;

  /// No description provided for @styleCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Your code for the style; each size and colour has its own SKU.'**
  String get styleCodeHint;

  /// No description provided for @variantsSection.
  ///
  /// In en, this message translates to:
  /// **'Sizes and colours'**
  String get variantsSection;

  /// No description provided for @variantsHint.
  ///
  /// In en, this message translates to:
  /// **'Each size or colour has its own barcode and SKU. Add at least one.'**
  String get variantsHint;

  /// No description provided for @variantHeading.
  ///
  /// In en, this message translates to:
  /// **'Size or colour {number}'**
  String variantHeading(int number);

  /// No description provided for @fieldSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fieldSize;

  /// No description provided for @sizeHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, e.g. M or 32/34.'**
  String get sizeHint;

  /// No description provided for @fieldColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get fieldColour;

  /// No description provided for @colourHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, e.g. Navy.'**
  String get colourHint;

  /// No description provided for @addVariant.
  ///
  /// In en, this message translates to:
  /// **'Add a size or colour'**
  String get addVariant;

  /// No description provided for @removeVariant.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeVariant;

  /// No description provided for @removeVariantLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove size or colour {number}'**
  String removeVariantLabel(int number);

  /// No description provided for @validationDuplicateBarcode.
  ///
  /// In en, this message translates to:
  /// **'Another size or colour already uses this barcode.'**
  String get validationDuplicateBarcode;

  /// No description provided for @validationDuplicateSku.
  ///
  /// In en, this message translates to:
  /// **'Another size or colour already uses this SKU.'**
  String get validationDuplicateSku;

  /// No description provided for @otherShopCodes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Other shop codes} other{Other shop codes ({count})}}'**
  String otherShopCodes(int count);

  /// No description provided for @otherShopCodesSaveFirst.
  ///
  /// In en, this message translates to:
  /// **'Save the product first to add codes other shops use.'**
  String get otherShopCodesSaveFirst;

  /// No description provided for @otherShopCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Other shop codes'**
  String get otherShopCodesTitle;

  /// No description provided for @otherShopCodesBody.
  ///
  /// In en, this message translates to:
  /// **'Codes other shops use for {variant}, so their orders and receipts match it.'**
  String otherShopCodesBody(String variant);

  /// No description provided for @thisVariant.
  ///
  /// In en, this message translates to:
  /// **'this size or colour'**
  String get thisVariant;

  /// No description provided for @aliasSource.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get aliasSource;

  /// No description provided for @aliasSourceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Myntra'**
  String get aliasSourceHint;

  /// No description provided for @aliasCode.
  ///
  /// In en, this message translates to:
  /// **'Their code'**
  String get aliasCode;

  /// No description provided for @addAlias.
  ///
  /// In en, this message translates to:
  /// **'Add code'**
  String get addAlias;

  /// No description provided for @addingAlias.
  ///
  /// In en, this message translates to:
  /// **'Adding…'**
  String get addingAlias;

  /// No description provided for @removeAliasLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove the {source} code {code}'**
  String removeAliasLabel(String source, String code);

  /// No description provided for @noAliases.
  ///
  /// In en, this message translates to:
  /// **'No other shop codes yet.'**
  String get noAliases;

  /// No description provided for @validationAliasSource.
  ///
  /// In en, this message translates to:
  /// **'Enter the shop name'**
  String get validationAliasSource;

  /// No description provided for @validationAliasCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get validationAliasCode;

  /// No description provided for @fileNeedsVariants.
  ///
  /// In en, this message translates to:
  /// **'Optional columns: style_code, size, colour, category. Rows with the same style_code become sizes or colours of one product.'**
  String get fileNeedsVariants;

  /// No description provided for @fileNeedsCategories.
  ///
  /// In en, this message translates to:
  /// **'category is one of TOPS, BOTTOMS, DRESSES, OUTERWEAR, FOOTWEAR, ACCESSORIES or OTHER (the default).'**
  String get fileNeedsCategories;

  /// V2-3: wardrobe card that opens the wardrobe share screen.
  ///
  /// In en, this message translates to:
  /// **'Share your wardrobe'**
  String get wardrobeShareCardTitle;

  /// V2-3: wardrobe share card, under the title.
  ///
  /// In en, this message translates to:
  /// **'One link to every verified piece you own.'**
  String get wardrobeShareCardBody;

  /// V2-3: wardrobe share screen title.
  ///
  /// In en, this message translates to:
  /// **'Share your wardrobe'**
  String get wardrobeShareTitle;

  /// V2-3: what the public wardrobe page shows.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the link sees your verified pieces and your first name. Never your email. Pieces still waiting for proof stay private.'**
  String get wardrobeShareBody;

  /// V2-3: how to hide one piece; quotes the switch label showInWardrobe.
  ///
  /// In en, this message translates to:
  /// **'To leave a piece out, open its tag and turn off Show in my public wardrobe.'**
  String get wardrobeShareHideHint;

  /// V2-3: button that shares the wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Create wardrobe link'**
  String get createWardrobeLink;

  /// V2-3: when the wardrobe link was created.
  ///
  /// In en, this message translates to:
  /// **'Shared since {date}'**
  String sharedSince(String date);

  /// V2-3: text sent with the wardrobe link in the share sheet.
  ///
  /// In en, this message translates to:
  /// **'My verified wardrobe on STAKA.'**
  String get wardrobeShareText;

  /// V2-3: subject sent with the wardrobe link (email apps).
  ///
  /// In en, this message translates to:
  /// **'My wardrobe on STAKA'**
  String get wardrobeShareSubject;

  /// V2-3: confirmation before the wardrobe link is turned off.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing your wardrobe?'**
  String get stopSharingWardrobeTitle;

  /// V2-3: what stopping the wardrobe link does.
  ///
  /// In en, this message translates to:
  /// **'The link stops working for everyone, including posts that already use it. Your tag links keep working. You can share again later with a new link.'**
  String get stopSharingWardrobeBody;

  /// V2-3: snackbar after the wardrobe link is created.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe link ready'**
  String get wardrobeLinkReady;

  /// V2-3: switch on a verified tag.
  ///
  /// In en, this message translates to:
  /// **'Show in my public wardrobe'**
  String get showInWardrobe;

  /// V2-3: under the Show in my public wardrobe switch.
  ///
  /// In en, this message translates to:
  /// **'When you share your wardrobe, this piece is on it.'**
  String get showInWardrobeBody;

  /// V2-4: channel row button; the app name, not translated.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get channelWhatsApp;

  /// V2-4: channel row button that shares the 9:16 story image; short so it fits under the round button.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get channelInstagram;

  /// V2-4: channel row button and the QR sheet title.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get channelQr;

  /// V2-4: channel row button that opens the phone share sheet.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get channelMore;

  /// V2-4: heading above the image format buttons.
  ///
  /// In en, this message translates to:
  /// **'Images to post'**
  String get shareImagesTitle;

  /// V2-4: tall image for stories.
  ///
  /// In en, this message translates to:
  /// **'Story (9:16)'**
  String get storyImageFormat;

  /// V2-4: square image for feed posts.
  ///
  /// In en, this message translates to:
  /// **'Post (1:1)'**
  String get postImageFormat;

  /// V2-4: screen-reader label for the QR code.
  ///
  /// In en, this message translates to:
  /// **'QR code for this link'**
  String get qrCodeLabel;

  /// V2-4: under the QR code in the sheet.
  ///
  /// In en, this message translates to:
  /// **'Let someone scan this with their phone camera to open the link.'**
  String get qrCodeHint;

  /// V2-4: opens the share sheet with the QR code as a PNG (Save to Photos, Files, chats).
  ///
  /// In en, this message translates to:
  /// **'Save or send image'**
  String get saveQrImage;

  /// V2-4: screen-reader name of the Instagram button.
  ///
  /// In en, this message translates to:
  /// **'Instagram story'**
  String get channelInstagramStory;

  /// V2-5: wardrobe impact card title.
  ///
  /// In en, this message translates to:
  /// **'Your impact'**
  String get impactTitle;

  /// V2-5: impact figure label.
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get impactPieces;

  /// V2-5: impact figure label.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get impactVerified;

  /// V2-5: impact figure label.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get impactShared;

  /// V2-5: impact figure label: views of public tags and the wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get impactViews;

  /// V2-5: impact figure label: carbon footprint of the owned pieces.
  ///
  /// In en, this message translates to:
  /// **'Footprint owned'**
  String get impactFootprint;

  /// V2-5: impact figure label.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get impactPoints;

  /// V2-5: impact card link to the Activity screen.
  ///
  /// In en, this message translates to:
  /// **'See your activity'**
  String get seeYourActivity;

  /// V2-5: Activity screen title.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// V2-5: Activity screen intro.
  ///
  /// In en, this message translates to:
  /// **'What happened with your pieces, newest first.'**
  String get activityBody;

  /// V2-5: Activity empty state title.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get activityEmptyTitle;

  /// V2-5: Activity empty state body.
  ///
  /// In en, this message translates to:
  /// **'Scan, add and share pieces, and it all shows up here.'**
  String get activityEmptyBody;

  /// V2-5: stands in for a product name the activity entry does not give.
  ///
  /// In en, this message translates to:
  /// **'a piece'**
  String get aPiece;

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Scanned {product}'**
  String activityScan(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Scanned a product STAKA doesn\'t know yet'**
  String get activityScanUnknown;

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Added {product} to your wardrobe'**
  String activityCardAdded(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'{product} was verified as yours'**
  String activityVerified(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Proof for {product} wasn\'t accepted'**
  String activityRejected(String product);

  /// V2-5: activity entry: a tag link was created.
  ///
  /// In en, this message translates to:
  /// **'Shared {product}'**
  String activityShared(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Shared your wardrobe'**
  String get activityWardrobeShared;

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Stopped sharing {product}'**
  String activityShareStopped(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Stopped sharing your wardrobe'**
  String get activityWardrobeShareStopped;

  /// V2-5: activity entry: a share button was used.
  ///
  /// In en, this message translates to:
  /// **'Sent the link to {product}'**
  String activityLinkSent(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Sent your wardrobe link'**
  String get activityWardrobeLinkSent;

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Someone viewed {product}'**
  String activityTagViewed(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Someone viewed your wardrobe'**
  String get activityWardrobeViewed;

  /// V2-5: activity entry: an embed was viewed.
  ///
  /// In en, this message translates to:
  /// **'{product} was viewed on another website'**
  String activityEmbedViewed(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Someone visited the brand from {product}'**
  String activityBrandLinkClicked(String product);

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Earned points'**
  String get activityPointsEarned;

  /// V2-5: activity entry.
  ///
  /// In en, this message translates to:
  /// **'Redeemed a voucher'**
  String get activityVoucherRedeemed;

  /// V2-5: activity entry of a type the app does not know.
  ///
  /// In en, this message translates to:
  /// **'Account activity'**
  String get activityOther;

  /// V2-5: how a link was shared or opened.
  ///
  /// In en, this message translates to:
  /// **'via {channel}'**
  String activityVia(String channel);

  /// V2-5: a number of points.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 point} other{{count} points}}'**
  String pointsCount(int count);

  /// V2-5: share channel name.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get channelFacebook;

  /// V2-5: share channel name (the former Twitter).
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get channelX;

  /// V2-5: share channel name.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get channelLinkedIn;

  /// V2-5: share channel name: the link was copied and pasted somewhere.
  ///
  /// In en, this message translates to:
  /// **'Copied link'**
  String get channelCopiedLink;

  /// V2-5: share channel name.
  ///
  /// In en, this message translates to:
  /// **'Website embed'**
  String get channelEmbed;

  /// V2-5: share channel name: the share sheet or an unknown place.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get channelOther;

  /// V2-5: tag stats heading in the share card.
  ///
  /// In en, this message translates to:
  /// **'How your link is doing'**
  String get tagStatsTitle;

  /// V2-5: tag stats figure.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get tagStatsViews;

  /// V2-5: tag stats figure: taps from the public page to the brand.
  ///
  /// In en, this message translates to:
  /// **'Visits to the brand'**
  String get tagStatsClicks;

  /// V2-5: above the per-channel bars.
  ///
  /// In en, this message translates to:
  /// **'Views by where you shared it'**
  String get tagStatsByChannel;

  /// V2-5: tag stats with no views.
  ///
  /// In en, this message translates to:
  /// **'No views yet. They show here once people open your link.'**
  String get tagStatsNoViews;

  /// Inbox heading and the bell's label with nothing unread (V2-9).
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread notification} other{{count} unread notifications}}'**
  String notificationsUnread(int count);

  /// No description provided for @notificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Decisions about your pieces, shares and rewards.'**
  String get notificationsBody;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know here when a receipt is checked or something happens with your tags.'**
  String get notificationsEmptyBody;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// Screen reader value on an unread notification.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationUnreadLabel;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSettingsDetail.
  ///
  /// In en, this message translates to:
  /// **'Push and email'**
  String get notificationSettingsDetail;

  /// No description provided for @notificationSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Choose how STAKA tells you about decisions, shares and rewards.'**
  String get notificationSettingsBody;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'On this phone, when something needs you.'**
  String get pushNotificationsBody;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Emails'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Decisions and reward news to your inbox.'**
  String get emailNotificationsBody;

  /// No description provided for @accountSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get accountSectionNotifications;

  /// No description provided for @notificationSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettingsTooltip;

  /// No description provided for @accountNotificationsDetail.
  ///
  /// In en, this message translates to:
  /// **'Choose what STAKA sends you'**
  String get accountNotificationsDetail;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @adminAnalyticsDescription.
  ///
  /// In en, this message translates to:
  /// **'From scan to share, across every brand.'**
  String get adminAnalyticsDescription;

  /// No description provided for @brandAnalyticsDescription.
  ///
  /// In en, this message translates to:
  /// **'How shoppers scan, verify and share your products.'**
  String get brandAnalyticsDescription;

  /// No description provided for @analyticsAdminBody.
  ///
  /// In en, this message translates to:
  /// **'How shoppers move from a scan to a shared tag, across every brand.'**
  String get analyticsAdminBody;

  /// No description provided for @analyticsBrandBody.
  ///
  /// In en, this message translates to:
  /// **'How shoppers move from a scan to a shared tag, for your products.'**
  String get analyticsBrandBody;

  /// No description provided for @analyticsPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get analyticsPeriodLabel;

  /// No description provided for @analyticsDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String analyticsDays(int days);

  /// No description provided for @analyticsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this period'**
  String get analyticsEmptyTitle;

  /// No description provided for @analyticsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No scans or shares yet. Try a longer period.'**
  String get analyticsEmptyBody;

  /// No description provided for @analyticsFunnelTitle.
  ///
  /// In en, this message translates to:
  /// **'From scan to share'**
  String get analyticsFunnelTitle;

  /// No description provided for @analyticsFunnelBody.
  ///
  /// In en, this message translates to:
  /// **'Each step, and how many of the step before made it.'**
  String get analyticsFunnelBody;

  /// No description provided for @funnelScanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get funnelScanned;

  /// No description provided for @funnelAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to a wardrobe'**
  String get funnelAdded;

  /// No description provided for @funnelVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get funnelVerified;

  /// No description provided for @funnelShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get funnelShared;

  /// No description provided for @funnelViewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed by others'**
  String get funnelViewed;

  /// No description provided for @analyticsFromStepBefore.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the step before'**
  String analyticsFromStepBefore(int percent);

  /// No description provided for @analyticsChannelsTitle.
  ///
  /// In en, this message translates to:
  /// **'By channel'**
  String get analyticsChannelsTitle;

  /// No description provided for @analyticsShares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get analyticsShares;

  /// No description provided for @analyticsViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get analyticsViews;

  /// No description provided for @analyticsNoneInPeriod.
  ///
  /// In en, this message translates to:
  /// **'None in this period.'**
  String get analyticsNoneInPeriod;

  /// No description provided for @analyticsTopProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top products'**
  String get analyticsTopProductsTitle;

  /// No description provided for @analyticsProductFigures.
  ///
  /// In en, this message translates to:
  /// **'{scans} scans · {verified} verified · {shared} shared'**
  String analyticsProductFigures(String scans, String verified, String shared);

  /// No description provided for @openNotification.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openNotification;

  /// No description provided for @pushAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Get a notification?'**
  String get pushAskTitle;

  /// No description provided for @pushAskBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tell you when your receipt has been checked, and when your tags get views or points.'**
  String get pushAskBody;

  /// No description provided for @pushAskYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, notify me'**
  String get pushAskYes;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @phonePushOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off on this phone'**
  String get phonePushOffTitle;

  /// No description provided for @phonePushOffAskBody.
  ///
  /// In en, this message translates to:
  /// **'Allow them to hear when a receipt is checked or your tags get views.'**
  String get phonePushOffAskBody;

  /// No description provided for @phonePushOffDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'To get them, turn on notifications for STAKA in your phone\'s settings.'**
  String get phonePushOffDeniedBody;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get allowNotifications;

  /// No description provided for @navRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get navRewards;

  /// No description provided for @rewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsTitle;

  /// No description provided for @rewardsBody.
  ///
  /// In en, this message translates to:
  /// **'Points for proving and sharing what you own, to swap for vouchers from brands on STAKA.'**
  String get rewardsBody;

  /// No description provided for @pointsBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Your points'**
  String get pointsBalanceLabel;

  /// No description provided for @pointsUnit.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{point} other{points}}'**
  String pointsUnit(int count);

  /// No description provided for @pointsExpireOn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 point expires on {date}} other{{count} points expire on {date}}}'**
  String pointsExpireOn(int count, String date);

  /// No description provided for @pointsSeeHistory.
  ///
  /// In en, this message translates to:
  /// **'See your points history'**
  String get pointsSeeHistory;

  /// No description provided for @howToEarn.
  ///
  /// In en, this message translates to:
  /// **'How to earn'**
  String get howToEarn;

  /// No description provided for @earnDailyCap.
  ///
  /// In en, this message translates to:
  /// **'Up to {cap} points a day'**
  String earnDailyCap(int cap);

  /// No description provided for @pointsSmallPrint.
  ///
  /// In en, this message translates to:
  /// **'Points expire 12 months after you earn them. They can\'t be cashed out, bought or passed on.'**
  String get pointsSmallPrint;

  /// No description provided for @earnPieceVerified.
  ///
  /// In en, this message translates to:
  /// **'Prove a piece is yours'**
  String get earnPieceVerified;

  /// No description provided for @earnFirstShare.
  ///
  /// In en, this message translates to:
  /// **'Share a verified piece for the first time'**
  String get earnFirstShare;

  /// No description provided for @earnWardrobeShared.
  ///
  /// In en, this message translates to:
  /// **'Share your wardrobe'**
  String get earnWardrobeShared;

  /// No description provided for @earnViews.
  ///
  /// In en, this message translates to:
  /// **'Every 10 views of a shared tag'**
  String get earnViews;

  /// No description provided for @earnPhoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Add and verify your phone number'**
  String get earnPhoneVerified;

  /// No description provided for @pointsOther.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsOther;

  /// No description provided for @pointsForVerified.
  ///
  /// In en, this message translates to:
  /// **'{product} was verified'**
  String pointsForVerified(String product);

  /// No description provided for @pointsForShare.
  ///
  /// In en, this message translates to:
  /// **'You shared {product}'**
  String pointsForShare(String product);

  /// No description provided for @pointsForWardrobeShare.
  ///
  /// In en, this message translates to:
  /// **'You shared your wardrobe'**
  String get pointsForWardrobeShare;

  /// No description provided for @pointsForViews.
  ///
  /// In en, this message translates to:
  /// **'10 more views of {product}'**
  String pointsForViews(String product);

  /// No description provided for @pointsForPhone.
  ///
  /// In en, this message translates to:
  /// **'You verified your phone number'**
  String get pointsForPhone;

  /// No description provided for @pointsUsedFor.
  ///
  /// In en, this message translates to:
  /// **'Used for {reward}'**
  String pointsUsedFor(String reward);

  /// No description provided for @pointsUsedForReward.
  ///
  /// In en, this message translates to:
  /// **'Used for a reward'**
  String get pointsUsedForReward;

  /// No description provided for @pointsTakenBack.
  ///
  /// In en, this message translates to:
  /// **'Taken back: {product} is no longer verified'**
  String pointsTakenBack(String product);

  /// No description provided for @pointsExpired.
  ///
  /// In en, this message translates to:
  /// **'Points expired'**
  String get pointsExpired;

  /// No description provided for @pointsAdjusted.
  ///
  /// In en, this message translates to:
  /// **'Adjusted by STAKA'**
  String get pointsAdjusted;

  /// No description provided for @pointsExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'expires {date}'**
  String pointsExpiresOn(String date);

  /// No description provided for @pointsHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Points history'**
  String get pointsHistoryTitle;

  /// No description provided for @pointsHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No points yet'**
  String get pointsHistoryEmptyTitle;

  /// No description provided for @pointsHistoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Prove a piece is yours or share it to earn your first points.'**
  String get pointsHistoryEmptyBody;

  /// No description provided for @adminBrandPortal.
  ///
  /// In en, this message translates to:
  /// **'Your brand'**
  String get adminBrandPortal;

  /// No description provided for @adminBrandPortalDescription.
  ///
  /// In en, this message translates to:
  /// **'Claims, products, rewards and team of the brands you belong to.'**
  String get adminBrandPortalDescription;

  /// V2-7: heading above the vouchers on the Rewards tab.
  ///
  /// In en, this message translates to:
  /// **'Swap your points'**
  String get rewardsCatalogTitle;

  /// No description provided for @rewardsCatalogEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No vouchers right now'**
  String get rewardsCatalogEmptyTitle;

  /// No description provided for @rewardsCatalogEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Brands add new ones often. Your points keep until they expire.'**
  String get rewardsCatalogEmptyBody;

  /// No description provided for @rewardOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get rewardOutOfStock;

  /// V2-7: how far the shopper is from a voucher.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more point} other{{count} more points}}'**
  String rewardNeedMore(int count);

  /// No description provided for @rewardEndsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String rewardEndsOn(String date);

  /// V2-7: the brand a voucher is for.
  ///
  /// In en, this message translates to:
  /// **'At {brand}'**
  String rewardAt(String brand);

  /// No description provided for @rewardTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get rewardTerms;

  /// No description provided for @rewardRedeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get rewardRedeem;

  /// No description provided for @rewardRedeeming.
  ///
  /// In en, this message translates to:
  /// **'Redeeming…'**
  String get rewardRedeeming;

  /// No description provided for @rewardConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Use your points?'**
  String get rewardConfirmTitle;

  /// V2-7: points is pointsCount, value the brand's own text.
  ///
  /// In en, this message translates to:
  /// **'Use {points} for {value} at {brand}? You can\'t undo this.'**
  String rewardConfirmBody(String points, String value, String brand);

  /// No description provided for @rewardConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Use points'**
  String get rewardConfirmYes;

  /// No description provided for @rewardDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Your voucher is ready'**
  String get rewardDoneTitle;

  /// No description provided for @rewardDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Use this code at checkout with {brand}. It\'s also kept in My vouchers.'**
  String rewardDoneBody(String brand);

  /// No description provided for @voucherCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get voucherCopy;

  /// No description provided for @voucherCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get voucherCopied;

  /// No description provided for @voucherUseBy.
  ///
  /// In en, this message translates to:
  /// **'Use by {date}'**
  String voucherUseBy(String date);

  /// No description provided for @voucherGotOn.
  ///
  /// In en, this message translates to:
  /// **'Got on {date}'**
  String voucherGotOn(String date);

  /// V2-7: for screen readers, before the voucher code.
  ///
  /// In en, this message translates to:
  /// **'Code {code}'**
  String voucherCodeLabel(String code);

  /// No description provided for @redeemNotEnough.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough points for this one yet.'**
  String get redeemNotEnough;

  /// No description provided for @redeemOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'This one just ran out. Pick another voucher.'**
  String get redeemOutOfStock;

  /// No description provided for @redeemEnded.
  ///
  /// In en, this message translates to:
  /// **'This voucher has ended.'**
  String get redeemEnded;

  /// No description provided for @rewardEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Voucher ended'**
  String get rewardEndedTitle;

  /// No description provided for @rewardEndedBody.
  ///
  /// In en, this message translates to:
  /// **'The brand has ended this voucher. Have a look at the others on the Rewards tab.'**
  String get rewardEndedBody;

  /// No description provided for @historyTabPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get historyTabPoints;

  /// No description provided for @historyTabVouchers.
  ///
  /// In en, this message translates to:
  /// **'My vouchers'**
  String get historyTabVouchers;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @vouchersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No vouchers yet'**
  String get vouchersEmptyTitle;

  /// No description provided for @vouchersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Vouchers you swap points for show up here with their codes.'**
  String get vouchersEmptyBody;

  /// V2-7: the Brand tab area for the brand's own rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get brandRewardsTitle;

  /// No description provided for @brandRewardsDescription.
  ///
  /// In en, this message translates to:
  /// **'Vouchers shoppers swap their STAKA points for, and the codes behind them.'**
  String get brandRewardsDescription;

  /// No description provided for @brandRewardsTabs.
  ///
  /// In en, this message translates to:
  /// **'Reward status'**
  String get brandRewardsTabs;

  /// No description provided for @brandRewardsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get brandRewardsActive;

  /// No description provided for @brandRewardsEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended or off'**
  String get brandRewardsEnded;

  /// No description provided for @newReward.
  ///
  /// In en, this message translates to:
  /// **'New reward'**
  String get newReward;

  /// No description provided for @editReward.
  ///
  /// In en, this message translates to:
  /// **'Edit reward'**
  String get editReward;

  /// No description provided for @noActiveRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'No active rewards'**
  String get noActiveRewardsTitle;

  /// No description provided for @noActiveRewardsBody.
  ///
  /// In en, this message translates to:
  /// **'Add a voucher for shoppers to swap their points for, then upload its codes.'**
  String get noActiveRewardsBody;

  /// No description provided for @noEndedRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing ended yet'**
  String get noEndedRewardsTitle;

  /// No description provided for @noEndedRewardsBody.
  ///
  /// In en, this message translates to:
  /// **'Rewards that end or are switched off show here.'**
  String get noEndedRewardsBody;

  /// No description provided for @rewardStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get rewardStatusOff;

  /// No description provided for @rewardStatusEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get rewardStatusEnded;

  /// No description provided for @rewardStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String rewardStatusScheduled(String date);

  /// No description provided for @rewardStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get rewardStatusLive;

  /// No description provided for @rewardRunsFrom.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String rewardRunsFrom(String date);

  /// No description provided for @rewardRunsFromTo.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String rewardRunsFromTo(String start, String end);

  /// No description provided for @fieldRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldRewardTitle;

  /// No description provided for @rewardTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What shoppers see in the list, e.g. ₹200 off your next order.'**
  String get rewardTitleHint;

  /// No description provided for @fieldRewardValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get fieldRewardValue;

  /// No description provided for @rewardValueHint.
  ///
  /// In en, this message translates to:
  /// **'Short, e.g. ₹200 off or Free shipping.'**
  String get rewardValueHint;

  /// No description provided for @fieldPointsCost.
  ///
  /// In en, this message translates to:
  /// **'Points it costs'**
  String get fieldPointsCost;

  /// No description provided for @fieldRewardDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldRewardDescription;

  /// No description provided for @fieldRewardTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get fieldRewardTerms;

  /// No description provided for @rewardTermsHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum order, where it works, what it can\'t be used with.'**
  String get rewardTermsHint;

  /// No description provided for @fieldStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Starts on'**
  String get fieldStartsOn;

  /// No description provided for @fieldEndsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends on'**
  String get fieldEndsOn;

  /// No description provided for @noEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get noEndDate;

  /// No description provided for @clearEndDate.
  ///
  /// In en, this message translates to:
  /// **'Remove end date'**
  String get clearEndDate;

  /// No description provided for @rewardActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Show to shoppers'**
  String get rewardActiveLabel;

  /// No description provided for @rewardActiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Off hides it from the Rewards tab. Codes already handed out still work.'**
  String get rewardActiveDescription;

  /// No description provided for @rewardTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get rewardTitleRequired;

  /// No description provided for @rewardValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter what it\'s worth.'**
  String get rewardValueRequired;

  /// No description provided for @pointsCostInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from 1 to 100,000.'**
  String get pointsCostInvalid;

  /// No description provided for @endBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end date must be after the start date.'**
  String get endBeforeStart;

  /// No description provided for @rewardCreated.
  ///
  /// In en, this message translates to:
  /// **'Reward added. Upload its codes next.'**
  String get rewardCreated;

  /// No description provided for @rewardStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Voucher codes'**
  String get rewardStatsTitle;

  /// No description provided for @rewardCodesLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get rewardCodesLeft;

  /// No description provided for @rewardCodesTotal.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get rewardCodesTotal;

  /// No description provided for @rewardRedeemedCount.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get rewardRedeemedCount;

  /// No description provided for @noCodesLeft.
  ///
  /// In en, this message translates to:
  /// **'No codes left: shoppers see this reward as out of stock until you upload more.'**
  String get noCodesLeft;

  /// No description provided for @uploadCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload codes'**
  String get uploadCodesTitle;

  /// No description provided for @uploadCodesBody.
  ///
  /// In en, this message translates to:
  /// **'A CSV with one code per row: code, then an optional expires_at date (YYYY-MM-DD). Codes already uploaded are skipped.'**
  String get uploadCodesBody;

  /// No description provided for @uploadingCodes.
  ///
  /// In en, this message translates to:
  /// **'Uploading {name}…'**
  String uploadingCodes(String name);

  /// No description provided for @codesAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 code added.} other{{count} codes added.}}'**
  String codesAdded(int count);

  /// No description provided for @codesDuplicates.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No duplicates.} =1{1 duplicate skipped.} other{{count} duplicates skipped.}}'**
  String codesDuplicates(int count);

  /// No description provided for @csvEmptyFile.
  ///
  /// In en, this message translates to:
  /// **'{name} is empty.'**
  String csvEmptyFile(String name);

  /// V2-8: the card above the decision on a claim.
  ///
  /// In en, this message translates to:
  /// **'Automatic check'**
  String get automaticCheckTitle;

  /// No description provided for @automaticCheckBody.
  ///
  /// In en, this message translates to:
  /// **'STAKA read the receipt and compared it with this claim. It only helps: you decide.'**
  String get automaticCheckBody;

  /// No description provided for @automaticCheckPending.
  ///
  /// In en, this message translates to:
  /// **'Still checking this receipt. Refresh in a minute, or decide without it.'**
  String get automaticCheckPending;

  /// No description provided for @automaticCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read this receipt. Check the shop, date and piece yourself.'**
  String get automaticCheckFailed;

  /// No description provided for @analysisShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get analysisShop;

  /// No description provided for @analysisBoughtOn.
  ///
  /// In en, this message translates to:
  /// **'Bought on'**
  String get analysisBoughtOn;

  /// No description provided for @analysisTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get analysisTotal;

  /// No description provided for @analysisNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get analysisNotFound;

  /// No description provided for @analysisBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand on the receipt'**
  String get analysisBrand;

  /// No description provided for @analysisProduct.
  ///
  /// In en, this message translates to:
  /// **'This piece on the receipt'**
  String get analysisProduct;

  /// No description provided for @analysisDateFits.
  ///
  /// In en, this message translates to:
  /// **'Bought before the claim'**
  String get analysisDateFits;

  /// No description provided for @analysisYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get analysisYes;

  /// No description provided for @analysisNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get analysisNo;

  /// No description provided for @analysisUnsure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get analysisUnsure;

  /// No description provided for @analysisScore.
  ///
  /// In en, this message translates to:
  /// **'Match score {score} of 100'**
  String analysisScore(int score);

  /// V2-8: on a claim in the list.
  ///
  /// In en, this message translates to:
  /// **'Score {score}'**
  String claimScoreShort(int score);

  /// V2-8: pill on a claim whose receipt file came with an earlier claim.
  ///
  /// In en, this message translates to:
  /// **'Reused receipt'**
  String get reusedReceipt;

  /// No description provided for @receiptUsedBefore.
  ///
  /// In en, this message translates to:
  /// **'This receipt was used before, for another claim.'**
  String get receiptUsedBefore;

  /// No description provided for @openEarlierClaim.
  ///
  /// In en, this message translates to:
  /// **'Open the earlier claim'**
  String get openEarlierClaim;

  /// No description provided for @claimSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get claimSortLabel;

  /// No description provided for @claimSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get claimSortNewest;

  /// No description provided for @claimSortScore.
  ///
  /// In en, this message translates to:
  /// **'Best match'**
  String get claimSortScore;
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
