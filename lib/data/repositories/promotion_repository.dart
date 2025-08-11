import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';
import '../models/promotion.dart';

class PromotionRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String PROMOTIONS = '/promotion_details';

  Future<CallbackResult<List<Promotion>>> getPromotions(
      {required String token, int? limit, int? offset, String? sortType, String? sortOrder}) async {
    try {
      final url = Uri.parse('$hostUrl$PROMOTIONS').replace(queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'sortype': sortType.toString(),
        'sortOrder': sortOrder.toString()
      });

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        },
      ).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(
            result.message,
            result.statusCode,
            Promotion.mapFromList(result.data)
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

  Future<CallbackResult<Promotion>> getPromotion(
      {required String token, required String proCode}) async {
    try {
      final url = Uri.parse('$hostUrl$PROMOTIONS/$proCode');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token'
        },
      ).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(
            result.message,
            result.statusCode,
            (result.data is List) ? Promotion.fromJson((result.data as List).first) : Promotion.fromJson(result.data)
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

  // Future<CallbackResult<List<PromotionCategory>>> getPromotionCategories(
  //     {required String token, int? limit, int? offset}) async {
  //   try {
  //     final url = Uri.parse('$hostUrl$PROMOTIONS')
  //         .replace(queryParameters: {'limit': limit.toString(), 'offset': offset.toString()});
  //
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token'
  //       },
  //     );
  //
  //     final result = HttpService.fromResponse(response);
  //
  //     if (result is Success) {
  //       return CallbackSuccess(
  //           result.message,
  //           result.statusCode,
  //           PromotionCategory.mapFromList(result.data)
  //       );
  //     } else if (result is Error) {
  //       return CallbackError(result.error, result.statusCode);
  //     } else {
  //       throw result;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
