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
