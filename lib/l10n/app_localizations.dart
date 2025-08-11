import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si')
  ];

  /// No description provided for @alerts_failed_title.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get alerts_failed_title;

  /// No description provided for @alerts_failed_description.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get alerts_failed_description;

  /// No description provided for @alerts_not_found_title.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get alerts_not_found_title;

  /// No description provided for @alerts_not_found_description.
  ///
  /// In en, this message translates to:
  /// **'The requested data was not found.'**
  String get alerts_not_found_description;

  /// No description provided for @alerts_no_content_title.
  ///
  /// In en, this message translates to:
  /// **'No Content'**
  String get alerts_no_content_title;

  /// No description provided for @alerts_no_content_description.
  ///
  /// In en, this message translates to:
  /// **'There is nothing to display.'**
  String get alerts_no_content_description;

  /// No description provided for @alerts_timeout_title.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get alerts_timeout_title;

  /// No description provided for @alerts_timeout_description.
  ///
  /// In en, this message translates to:
  /// **'The connection timed out. Please try again.'**
  String get alerts_timeout_description;

  /// No description provided for @alerts_connection_error_title.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get alerts_connection_error_title;

  /// No description provided for @alerts_connection_error_description.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Please check your connection.'**
  String get alerts_connection_error_description;

  /// No description provided for @alerts_internal_server_error_title.
  ///
  /// In en, this message translates to:
  /// **'Internal Server Error'**
  String get alerts_internal_server_error_title;

  /// No description provided for @alerts_internal_server_error_description.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again later.'**
  String get alerts_internal_server_error_description;

  /// No description provided for @alerts_empty_bills_title.
  ///
  /// In en, this message translates to:
  /// **'No E-Bills Found'**
  String get alerts_empty_bills_title;

  /// No description provided for @alerts_empty_bills_description.
  ///
  /// In en, this message translates to:
  /// **'You haven’t received any e-bills yet.'**
  String get alerts_empty_bills_description;

  /// No description provided for @alerts_empty_promotions_title.
  ///
  /// In en, this message translates to:
  /// **'No Promotions'**
  String get alerts_empty_promotions_title;

  /// No description provided for @alerts_empty_promotions_description.
  ///
  /// In en, this message translates to:
  /// **'There are no promotions available at this time.'**
  String get alerts_empty_promotions_description;

  /// No description provided for @alerts_empty_notifications_title.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get alerts_empty_notifications_title;

  /// No description provided for @alerts_empty_notifications_description.
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications.'**
  String get alerts_empty_notifications_description;

  /// No description provided for @alerts_empty_reviews_title.
  ///
  /// In en, this message translates to:
  /// **'No Reviews'**
  String get alerts_empty_reviews_title;

  /// No description provided for @alerts_empty_reviews_description.
  ///
  /// In en, this message translates to:
  /// **'There are no reviews for this item.'**
  String get alerts_empty_reviews_description;

  /// No description provided for @alerts_empty_transactions_title.
  ///
  /// In en, this message translates to:
  /// **'No Transactions'**
  String get alerts_empty_transactions_title;

  /// No description provided for @alerts_empty_transactions_description.
  ///
  /// In en, this message translates to:
  /// **'You have no transactions.'**
  String get alerts_empty_transactions_description;

  /// No description provided for @alerts_issue_submitted_title.
  ///
  /// In en, this message translates to:
  /// **'Issue Submitted'**
  String get alerts_issue_submitted_title;

  /// No description provided for @alerts_issue_submitted_description.
  ///
  /// In en, this message translates to:
  /// **'Your issue has been successfully submitted.'**
  String get alerts_issue_submitted_description;

  /// No description provided for @alerts_feedback_submitted_title.
  ///
  /// In en, this message translates to:
  /// **'Feedback Submitted'**
  String get alerts_feedback_submitted_title;

  /// No description provided for @alerts_feedback_submitted_description.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has been successfully received.'**
  String get alerts_feedback_submitted_description;

  /// No description provided for @alerts_profile_updated_title.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated'**
  String get alerts_profile_updated_title;

  /// No description provided for @alerts_profile_updated_description.
  ///
  /// In en, this message translates to:
  /// **'Your profile has been updated successfully.'**
  String get alerts_profile_updated_description;

  /// No description provided for @alerts_ebill_registered_title.
  ///
  /// In en, this message translates to:
  /// **'You\'re Now Registered for E-Bills'**
  String get alerts_ebill_registered_title;

  /// No description provided for @alerts_ebill_registered_description.
  ///
  /// In en, this message translates to:
  /// **'Your bills will now appear right in the app and may also be sent via SMS. Enjoy clutter-free convenience!'**
  String get alerts_ebill_registered_description;

  /// No description provided for @actions_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actions_retry;

  /// No description provided for @actions_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actions_refresh;

  /// No description provided for @actions_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actions_ok;

  /// No description provided for @actions_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actions_cancel;

  /// No description provided for @actions_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actions_done;

  /// No description provided for @actions_got_it.
  ///
  /// In en, this message translates to:
  /// **'Got It'**
  String get actions_got_it;
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
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
