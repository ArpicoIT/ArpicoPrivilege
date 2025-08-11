import 'dart:convert';

import 'package:arpicoprivilege/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';

class UserRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String GET_VALID_USER_DETAILS = '/valid_user_details';
  static const String UPDATE_PROFILE_PICTURES = '/privilege_registration/profile_pictures';
  static const String UPDATE_USER_DETAILS = '/privilege_registration/additional_data';


  Future<CallbackResult<User>> getValidUser(String token) async {
    try {
      final url = Uri.parse('$hostUrl$GET_VALID_USER_DETAILS');

      final response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(
            result.message,
            result.statusCode,
            User.fromJson(result.data)
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

  Future<CallbackResult<bool>> updateUserProfilePictures({required String token, required List<XFile> images, required Map<String, dynamic> data}) async {
    try {
      final url = Uri.parse('$hostUrl$UPDATE_PROFILE_PICTURES');
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

  Future<CallbackResult<bool>> updateUserDetails({
    required String? custId,
    String? title,
    String? firstName,
    String? lastName,
    String? gender,
    String? mobile,
    String? address1,
    String? address2,
    String? address3,
    String? email,
    String? city,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$hostUrl$UPDATE_USER_DETAILS');

      final response = await http.post(url,
          body: json.encode({
            "custId": custId,
            "custTitle": title,
            "custFName": firstName,
            "custLName": lastName,
            "custSex": gender,
            "custMobNo": mobile, // not update
            "custHmAdd1": address1,
            "custHmAdd2": address2,
            "custHmAdd3": address3,
            "custEmail1": email, // not update
            "custCity": city
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

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
}
