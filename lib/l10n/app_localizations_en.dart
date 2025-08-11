// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get alerts_failed_title => 'Something Went Wrong';

  @override
  String get alerts_failed_description =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get alerts_not_found_title => 'Not Found';

  @override
  String get alerts_not_found_description =>
      'The requested data was not found.';

  @override
  String get alerts_no_content_title => 'No Content';

  @override
  String get alerts_no_content_description => 'There is nothing to display.';

  @override
  String get alerts_timeout_title => 'Timeout';

  @override
  String get alerts_timeout_description =>
      'The connection timed out. Please try again.';

  @override
  String get alerts_connection_error_title => 'Connection Error';

  @override
  String get alerts_connection_error_description =>
      'Network connection failed. Please check your connection.';

  @override
  String get alerts_internal_server_error_title => 'Internal Server Error';

  @override
  String get alerts_internal_server_error_description =>
      'A server error occurred. Please try again later.';

  @override
  String get alerts_empty_bills_title => 'No E-Bills Found';

  @override
  String get alerts_empty_bills_description =>
      'You haven’t received any e-bills yet.';

  @override
  String get alerts_empty_promotions_title => 'No Promotions';

  @override
  String get alerts_empty_promotions_description =>
      'There are no promotions available at this time.';

  @override
  String get alerts_empty_notifications_title => 'No Notifications';

  @override
  String get alerts_empty_notifications_description =>
      'You have no new notifications.';

  @override
  String get alerts_empty_reviews_title => 'No Reviews';

  @override
  String get alerts_empty_reviews_description =>
      'There are no reviews for this item.';

  @override
  String get alerts_empty_transactions_title => 'No Transactions';

  @override
  String get alerts_empty_transactions_description =>
      'You have no transactions.';

  @override
  String get alerts_issue_submitted_title => 'Issue Submitted';

  @override
  String get alerts_issue_submitted_description =>
      'Your issue has been successfully submitted.';

  @override
  String get alerts_feedback_submitted_title => 'Feedback Submitted';

  @override
  String get alerts_feedback_submitted_description =>
      'Your feedback has been successfully received.';

  @override
  String get alerts_profile_updated_title => 'Profile Updated';

  @override
  String get alerts_profile_updated_description =>
      'Your profile has been updated successfully.';

  @override
  String get alerts_ebill_registered_title =>
      'You\'re Now Registered for E-Bills';

  @override
  String get alerts_ebill_registered_description =>
      'Your bills will now appear right in the app and may also be sent via SMS. Enjoy clutter-free convenience!';

  @override
  String get actions_retry => 'Retry';

  @override
  String get actions_refresh => 'Refresh';

  @override
  String get actions_ok => 'OK';

  @override
  String get actions_cancel => 'Cancel';

  @override
  String get actions_done => 'Done';

  @override
  String get actions_got_it => 'Got It';
}
