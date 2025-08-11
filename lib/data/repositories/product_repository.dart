import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';
import '../models/product.dart';


class ProductRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String PRODUCTS = '/product_details';
  static const String SEARCH = '/product_search';


  Future<CallbackResult<List<Product>>> getProducts(
      {required String token, int? limit, int? offset, String? search, String? sortType, String? sortOrder}) async {
    try {
      final url = Uri.parse('$hostUrl$PRODUCTS').replace(queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
        'search': search,
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
            Product.mapFromList(result.data)
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

  Future<CallbackResult<Product>> getProduct(
      {required String token, required String itemCode}) async {
    try {
      final url = Uri.parse('$hostUrl$PRODUCTS/$itemCode');

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
            (result.data is List) ? Product.fromJson((result.data as List).first) : Product.fromJson(result.data)
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

  // Future<CallbackResult<List<Product>>> searchProducts(
  //     {required String token, required String searchKey}) async {
  //   try {
  //     final url = Uri.parse('$hostUrl$SEARCH')
  //         .replace(queryParameters: {'search': searchKey});
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
  //           Product.mapFromList(result.data)
  //       );
  //     } else if (result is Error) {
  //       return CallbackError(result.error, result.statusCode);
  //     } else if (result is HttpException) {
  //       throw result.exception;
  //     } else {
  //       throw result.toString();
  //     }
  //   } catch (e) {
  //     throw CallbackException(e.toString());
  //   }
  // }

}