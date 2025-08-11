import 'dart:convert';

import 'package:arpicoprivilege/core/handlers/callback_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_consts.dart';
import '../../core/services/http_service.dart';
import '../../core/services/configure_service.dart';
import '../../data/models/product.dart';


class RatingsAndReviewsRepository {

  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String PRODUCT_REVIEWS = '/product_reviews';

  Future<CallbackResult<bool>> saveProductReview({
    required List<XFile> images,
    required Map<String, dynamic> data,
    required String token
  }) async {
    try {
      final url = Uri.parse('$hostUrl$PRODUCT_REVIEWS');
      var request = http.MultipartRequest('POST', url);

      // Add Authorization header with Bearer token
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add images to the request
      for (var image in images) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image', // The key your server expects
          image.path,
          filename: image.name,
          contentType: (image.mimeType != null) ? MediaType.parse(image.mimeType!) : null,
        );
        request.files.add(multipartFile);
      }

      // Add additional data as a field
      request.fields['data'] = jsonEncode(data);

      // Send the request
      var response = await request.send().timeout(kDefaultTimeout);

      final result = await HttpService.fromStreamedResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, true);
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode, false);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// not use
  Future<Product> getProductReviews(String itemCode) async {
    try {
      final url = Uri.parse('$hostUrl$PRODUCT_REVIEWS/$itemCode');

      final response = await http.get(
          url,
          headers: {}
      );

      final result = HttpService.fromResponse(response);

      if(result is Success){
        debugPrint(result.message);
      } else if(result is Error){
        debugPrint(result.error);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }

    return Product();
  }

  /// not use
  Future<void> deleteProductReview(String itemCode, String userId) async {
    try {
      final url = Uri.parse('$hostUrl$PRODUCT_REVIEWS/$itemCode/$userId');

      final response = await http.delete(url, headers: {});

      final result = HttpService.fromResponse(response);

      if(result is Success){
        debugPrint(result.message);
      } else if(result is Error){
        debugPrint(result.error);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// not use
  Future<void> updateProductReview(List<XFile> images, Review review) async {
    try {
      final url = Uri.parse('$hostUrl$PRODUCT_REVIEWS');
      var request = http.MultipartRequest('PUT', url);

      // Add images to the request
      for (var image in images) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image', // The key your server expects
          image.path,
          filename: image.name,
          contentType: (image.mimeType != null) ? MediaType.parse(image.mimeType!) : null,
        );
        request.files.add(multipartFile);
      }

      // Add additional data as a field
      request.fields['data'] = jsonEncode(review.toJson());

      // Send the request
      var response = await request.send();

      final result = await HttpService.fromStreamedResponse(response);

      if(result is Success){
        debugPrint(result.message);
      } else if(result is Error){
        debugPrint(result.error);
      } else {
        throw result;
      }

    } catch (e) {
      rethrow;
    }
  }

}