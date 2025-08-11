import 'dart:convert';

import 'package:arpicoprivilege/core/constants/app_consts.dart';
import 'package:http/http.dart' as http;
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';
import '../models/app_notification.dart';
import '../models/eBill.dart';


class NotificationRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String NOTIFICATIONS = '/notifications';

  Future<CallbackResult<List<AppNotification>>> getNotifications(String token) async {
    try {
      final url = Uri.parse('$hostUrl$NOTIFICATIONS');

      final response = await http.get(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, AppNotification.mapFromList(result.data));
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }
}