import 'dart:convert';

import 'package:arpicoprivilege/core/extentions/string_extensions.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_consts.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/services/configure_service.dart';
import '../../core/services/http_service.dart';

class AuthenticationRepository {
  /// Host url
  final hostUrl = ConfigService().getConfig('appDomain');

  /// Api endpoints
  static const String PING = '/ping';
  static const String REFRESH_TOKEN = '/refresh_token';
  static const String UPDATE_FCM_TOKEN = '/fcm_token_update';

  static const String REQUEST_OTP = '/privilege_registration/request_otp';
  static const String VERIFY_OTP = '/privilege_registration/verify_otp';
  static const String VERIFY_NIC = '/privilege_registration/verify_nic';
  static const String VERIFY_MOBILE = '/privilege_registration/verify_mobile';

  static const String REQUEST_LOGIN = '/login';
  static const String VERIFY_LOGIN = '/login_verify';
  static const String REQUEST_REGISTRATION = '/privilege_registration/request_registration';
  static const String VERIFY_REGISTRATION = '/privilege_registration/verify_registration';
  static const String LOGOUT = '/logout';


  Future<CallbackResult<bool>> ping() async {
    try {
      final url = Uri.parse('$hostUrl$PING');

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
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

  Future<CallbackResult<Map<String, dynamic>>> refreshToken(
      String accessToken) async {
    try {
      final url = Uri.parse('$hostUrl$REFRESH_TOKEN');

      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, result.data);
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<bool>> updateFcmToken(
      {required String fcmToken, required String accessToken}) async {
    try {
      final url = Uri.parse('$hostUrl$UPDATE_FCM_TOKEN');

      final response = await http.post(url,
          body: json.encode({
            "fcm_token": fcmToken,
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken"
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

  Future<CallbackResult<bool>> requestOtp(
      {required String nic,
      String? mobile,
      String? email,
      required String uuid}) async {
    try {
      final url = Uri.parse('$hostUrl$REQUEST_OTP');

      if (mobile != null && mobile.startsWith('+')) {
        mobile = mobile.substring(1);
      }

      final response = await http.post(url,
          body: json.encode({
            "custNic": nic,
            "custMobNo": mobile ?? "",
            "custEmail": email ?? "",
            "uuid": uuid
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic YXJwaWNvOkFSUGdpdDY3MzMj",
            "x-api-key": "ARPgit6733#"
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

  Future<CallbackResult<String>> verifyOtp(
      {required String nic,
      String? mobile,
      String? email,
      required String otp}) async {
    try {
      final url = Uri.parse('$hostUrl$VERIFY_OTP');

      if (mobile != null && mobile.startsWith('+')) {
        mobile = mobile.substring(1);
      }

      final response = await http.post(url,
          body: json.encode({
            "custNic": nic,
            "custMobNo": mobile ?? "",
            "custEmail": email ?? "",
            "otp": otp
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic YXJwaWNvOkFSUGdpdDY3MzMj",
            "x-api-key": "ARPgit6733#"
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode);
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<Map<String, dynamic>>> verifyMobileNumber(
      String mobile) async {
    try {
      final url = Uri.parse('$hostUrl$VERIFY_MOBILE');

      final response = await http.post(url,
          body: json.encode({
            "custMobNo": mobile,
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic YXJwaWNvOkFSUGdpdDY3MzMj",
            "x-api-key": "ARPgit6733#"
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, result.data);
      } else if (result is Error) {
        return CallbackError(
          result.error,
          result.statusCode,
        );
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<Map<String, dynamic>>> verifyNicNumber(
      String nic, String uuid) async {
    try {
      final url = Uri.parse('$hostUrl$VERIFY_NIC');

      final response = await http.post(url,
          body: json.encode({"custNic": nic, "uuid": uuid}),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Basic YXJwaWNvOkFSUGdpdDY3MzMj",
            "x-api-key": "ARPgit6733#"
          }).timeout(kDefaultTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, result.data);
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<Map<String, dynamic>>> requestLogin(
      {String? custId, String? phone, String? nic}) async {
    try {
      final url = Uri.parse('$hostUrl$REQUEST_LOGIN');

      final response = await http.post(url,
          body: json.encode({
            "custId": custId ?? "",
            "custMobNo": phone != null ? phone.countryCodePrefix.toString() : "",
            "custNic": nic ?? "",
          }),
          headers: {
            "Content-Type": "application/json",
          }).timeout(kLongTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode,
            result.data as Map<String, dynamic>);
      } else if (result is Error) {
        return CallbackError(
            result.error, result.statusCode, {"isLogged": false});
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<Map<String, dynamic>>> verifyLogin(
      {String? custId, String? phone, String? nic, required String otp}) async {
    try {
      final url = Uri.parse('$hostUrl$VERIFY_LOGIN');

      final response = await http.post(url,
          body: json.encode({
            "custId": custId ?? "",
            "custMobNo": phone != null ? phone.countryCodePrefix.toString() : "",
            "custNic": nic ?? "",
            "custOTP": otp,
          }),
          headers: {
            "Content-Type": "application/json",
          }).timeout(kLongTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, {
          "isLogged": result.data["isLogged"],
          "token": result.data["data"]["token"]
        });
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<Map<String, dynamic>>> requestRegistration({
    String? custId,
    required String nic,
    required String mobile,
    required String firstName,
    required String lastName,
    String? email,
    required String uuid
  }) async {
    try {
      final url = Uri.parse('$hostUrl$REQUEST_REGISTRATION');

      final response = await http.post(url,
          body: json.encode({
            "custId": custId,
            "custNic": nic,
            "custMobNo": mobile,
            "custFName": firstName,
            "custLName": lastName,
            "custEmail": email,
            "uuid": uuid
          }),
          headers: {
            "Content-Type": "application/json",
          }).timeout(kLongTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, result.data);
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<Map<String, dynamic>>> verifyRegistration({
    required String otp,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$hostUrl$VERIFY_REGISTRATION');

      final response = await http.post(url,
          body: json.encode({
            "otp": otp,
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }).timeout(kLongTimeout);

      final result = HttpService.fromResponse(response);

      if (result is Success) {
        return CallbackSuccess(result.message, result.statusCode, result.data);
      } else if (result is Error) {
        return CallbackError(result.error, result.statusCode);
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CallbackResult<bool>> logout(
      {required String custId,
        required String mobile,
        required String uuid,
        required String token}) async {
    try {
      final url = Uri.parse('$hostUrl$LOGOUT');

      final response = await http.post(url,
          body: json
              .encode({"custId": custId, "custMobNo": mobile, "uuid": uuid}),
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


// Future<CallbackResult<Map<String, dynamic>>> loyaltyRegister(
//     {required String nic,
//     required String mobile,
//     required String firstName,
//     required String lastName,
//     required String email,
//     required String uuid}) async {
//   try {
//     final url = Uri.parse('$hostUrl$LOYALTY_REGISTRATION');
//
//     final response = await http.post(url,
//         body: json.encode({
//           "custNic": nic,
//           "custMobNo": mobile,
//           "custFName": firstName,
//           "custLName": lastName,
//           "custEmail": email,
//           "uuid": uuid
//         }),
//         headers: {
//           "Content-Type": "application/json",
//         });
//
//     final result = HttpService.fromResponse(response);
//
//     if (result is Success) {
//       return CallbackSuccess(result.message, result.statusCode, {
//         "isLogged": result.data["isLogged"],
//         "token": result.data["data"]["token"]
//       });
//     } else if (result is Error) {
//       return CallbackError(result.error, result.statusCode);
//     } else {
//       throw result;
//     }
//   } catch (e) {
//     rethrow;
//   }
// }
