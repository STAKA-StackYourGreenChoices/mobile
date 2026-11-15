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

  /// Opens the phone's share sheet. Same as the website's share panel.
  ///
  /// In en, this message translates to:
  /// **'Share…'**
  String get shareEllipsis;

  /// Same as the website's share panel. On the phone it opens the share sheet with the image.
  ///
  /// In en, this message translates to:
  /// **'Image for Instagram stories'**
  String get storyImage;

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
