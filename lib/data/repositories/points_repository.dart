import 'package:http/http.dart' as http;

import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';
import '../models/points.dart';

class PointsRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String POINTS_BALANCE = '/points_balance';

  Future<CallbackResult<Points>> getUserPointsBalance(
      {required String token, required String custId}) async {
    try {
      final url = Uri.parse('$hostUrl$POINTS_BALANCE/$custId');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(
          result.message,
          result.statusCode,
          (result.data is List)
              ? Points.fromJson(result.data[0])
              : Points.fromJson(result.data),
        );
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
