import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

class AppTranslator {
  final BuildContext context;
  late final AppLocalizations _l10n;

  AppTranslator(this.context) {
    _l10n = AppLocalizations.of(context)!;
  }

  /// Access using: AppTranslator.of(context).call('key')
  static AppTranslator of(BuildContext context) => AppTranslator(context);

  String call(String key) {
    switch (key) {
      case 'alerts_failed_title':
        return _l10n.alerts_failed_title;
      case 'alerts_failed_description':
        return _l10n.alerts_failed_description;

      case 'alerts_not_found_title':
        return _l10n.alerts_not_found_title;
      case 'alerts_not_found_description':
        return _l10n.alerts_not_found_description;

      case 'alerts_no_content_title':
        return _l10n.alerts_no_content_title;
      case 'alerts_no_content_description':
        return _l10n.alerts_no_content_description;

      case 'alerts_timeout_title':
        return _l10n.alerts_timeout_title;
      case 'alerts_timeout_description':
        return _l10n.alerts_timeout_description;

      case 'alerts_connection_error_title':
        return _l10n.alerts_connection_error_title;
      case 'alerts_connection_error_description':
        return _l10n.alerts_connection_error_description;

      case 'alerts_internal_server_error_title':
        return _l10n.alerts_internal_server_error_title;
      case 'alerts_internal_server_error_description':
        return _l10n.alerts_internal_server_error_description;

      case 'alerts_empty_bills_title':
        return _l10n.alerts_empty_bills_title;
      case 'alerts_empty_bills_description':
        return _l10n.alerts_empty_bills_description;

      case 'alerts_empty_promotions_title':
        return _l10n.alerts_empty_promotions_title;
      case 'alerts_empty_promotions_description':
        return _l10n.alerts_empty_promotions_description;

      case 'alerts_empty_notifications_title':
        return _l10n.alerts_empty_notifications_title;
      case 'alerts_empty_notifications_description':
        return _l10n.alerts_empty_notifications_description;

      case 'alerts_empty_reviews_title':
        return _l10n.alerts_empty_reviews_title;
      case 'alerts_empty_reviews_description':
        return _l10n.alerts_empty_reviews_description;

      case 'alerts_empty_transactions_title':
        return _l10n.alerts_empty_transactions_title;
      case 'alerts_empty_transactions_description':
        return _l10n.alerts_empty_transactions_description;

      case 'alerts_issue_submitted_title':
        return _l10n.alerts_issue_submitted_title;
      case 'alerts_issue_submitted_description':
        return _l10n.alerts_issue_submitted_description;

      case 'alerts_feedback_submitted_title':
        return _l10n.alerts_feedback_submitted_title;
      case 'alerts_feedback_submitted_description':
        return _l10n.alerts_feedback_submitted_description;

      case 'alerts_profile_updated_title':
        return _l10n.alerts_profile_updated_title;
      case 'alerts_profile_updated_description':
        return _l10n.alerts_profile_updated_description;

      case 'alerts_ebill_registered_title':
        return _l10n.alerts_ebill_registered_title;
      case 'alerts_ebill_registered_description':
        return _l10n.alerts_ebill_registered_description;

      case 'actions_retry':
        return _l10n.actions_retry;
      case 'actions_refresh':
        return _l10n.actions_refresh;
      case 'actions_ok':
        return _l10n.actions_ok;
      case 'actions_cancel':
        return _l10n.actions_cancel;
      case 'actions_done':
        return _l10n.actions_done;
      case 'actions_got_it':
        return _l10n.actions_got_it;

      default:
        return key;
    }
  }
}
