import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';

class SettingsRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String FEEDBACK_DETAILS = '/feedback_details';
  static const String HELP_SUPPORT = '/help_support';


  Future<CallbackResult<bool>> setFeedback({
    required String feedback,
    required String token
  }) async {
    try {
      final url = Uri.parse('$hostUrl$FEEDBACK_DETAILS');

      final response = await http.post(url, body: json.encode({
        "feedDesc": feedback
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, true);
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<bool>> setQuestion({
    required String custId,
    required String custName,
    required String custContact,
    required String content,
    required String token
  }) async {
    try {
      final url = Uri.parse('$hostUrl$HELP_SUPPORT');

      final response = await http.post(url, body: json.encode({
        "custId": custId,
        "custName": custName,
        "custContact": custContact,
        "supportDesc": content,
      }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, true);
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