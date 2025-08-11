import 'dart:convert';
import 'dart:io';
import 'package:arpicoprivilege/core/constants/app_consts.dart';
import 'package:arpicoprivilege/core/handlers/callback_handler.dart';
import 'package:arpicoprivilege/core/services/jwt_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/services/configure_service.dart';
import 'core/services/jwt_service_old.dart';
import 'core/services/storage_service.dart';
import 'data/models/user.dart';
import 'data/repositories/app_cache_repository.dart';
import 'data/repositories/authentication_repository.dart';
import 'data/repositories/user_repository.dart';

// String TEST_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbkN1c3RJZCI6IjAwNjUwODc2NDYiLCJsb2dpbkN1c3ROYW1lIjoiR0FZQU4iLCJsb2dpbkN1c3RMYXN0TmFtZSI6IldFRVJBU0lOR0hFIiwibG9naW5DdXN0TmljIjoiOTUyNDAwMDYxViIsImxvZ2luQ3VzdE1vYk5vIjoiOTQ3MTA5MzA0NDQiLCJsb2dpbkN1c3RFbWFpbCI6IndtZ2F5YW5jdzk1QGdtYWlsLmNvbSIsImxvZ2luQ3VzdFV1aWQiOiIxMjM0NTY3ODkiLCJsb2dpbkN1c3RJc0ViaWxsIjp0cnVlLCJsb2dpbkN1c3RJc0xveWFsdHkiOnRydWUsImlhdCI6MTc0NDE3MTU2NSwiZXhwIjoxNzQ0MjU3OTY1fQ.KgqlTHjwrr7Bi0fCshekv2zQezHCp3cSEg3azU44Nk0";
String TEST_TOKEN =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbkN1c3RJZCI6IjAwNjUwODc2NDYiLCJsb2dpbkN1c3ROYW1lIjoiR0FZQU4iLCJsb2dpbmN1c3RMTmFtZSI6IldFRVJBIiwibG9naW5DdXN0TmljIjoiOTUyNDAwMDYxViIsImxvZ2luQ3VzdE1vYk5vIjoiOTQ3MTA5MzA0NDQiLCJsb2dpbkN1c3RFbWFpbCI6IiIsImxvZ2luQ3VzdFV1aWQiOiJVVEFTMzQuODItOTctMyIsImxvZ2luQ3VzdElzRWJpbGwiOnRydWUsImxvZ2luQ3VzdElzTG95YWx0eSI6dHJ1ZSwiaWF0IjoxNzQ4MzM0MTA2LCJleHAiOjE3NDg0MjA1MDZ9.hKhQqjzrneV4hp-C9Uuu9eq6EHQ7M7slD_ufHVHZbrk";
String MY_CUST_ID = "0065087646";
String MY_MOBILE_NUM = "0710930444";
String MY_OFFICE_NUM = "0762973681";

// String UUID = "123456789";

/// Saves the access token to secure storage
Future<bool> saveAccessToken(String token) async {
  try {
    await StorageService.instance.write("access_token", token);
    return true;
  } catch (e) {
    rethrow;
  }
}

/// Reads the access token from storage
Future<String?> loadAccessToken() async {
  return await StorageService.instance.read("access_token");
}

/// Refreshes the access token using the provided or stored token,
/// and saves the refreshed one.
Future<String> refreshAndSaveAccessToken([String? token]) async {
  try {
    final currentToken = token ?? await loadAccessToken();

    if (currentToken == null) {
      throw "Access token not found";
    }

    final result = await AuthenticationRepository().refreshToken(currentToken);

    if (result is CallbackSuccess) {
      final String newToken = result.data!['token'];
      await saveAccessToken(newToken);
      return newToken;
    } else {
      throw result.message ?? "Failed to refresh token";
    }
  } catch (e) {
    rethrow;
  }
}

/// Returns a valid access token:
/// - uses the current token if still valid
/// - otherwise refreshes and returns the new one
Future<String> getValidAccessToken() async {
  try {
    final token = await loadAccessToken();

    if (token == null) {
      throw "Access token not found";
    }

    final isExpired = JWTService.instance.hasExpired(token);
    return isExpired ? await refreshAndSaveAccessToken(token) : token;
  } catch (e) {
    rethrow;
  }
}

/// Fetches the currently logged-in user using a valid access token
/// and caches the user data locally.
Future<User> getAndCacheValidUser() async {
  try {
    final token = await getValidAccessToken();
    final result = await UserRepository().getValidUser(token);

    if (result is! CallbackSuccess) {
      throw result.message ?? "Failed to fetch user";
    }

    final user = result.data;

    if (user is! User) {
      throw "Valid user not found";
    }

    await AppCacheRepository.saveUserCache(user);
    return user;
  } catch (e) {
    rethrow;
  }
}

/// Decodes a valid access token (or uses a provided one)
/// and returns a LoginUser object.
Future<LoginUser> decodeValidLoginUser([String? token]) async {
  try {
    final validToken = token ?? await getValidAccessToken();
    final decodedPayload = JWTService.instance.decode(validToken);

    return LoginUser.fromJson(decodedPayload);
  } catch (e) {
    rethrow;
  }
}

/// Fetches the current FCM token and updates it on the server.
/// Returns the token if successful.
Future<String> refreshAndSyncFcmToken() async {
  try {
    final accessToken = await getValidAccessToken();
    final String? fcmToken;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {

      fcmToken = await FirebaseMessaging.instance
          .getAPNSToken()
          .onError((error, _) => null)
          .timeout(kDefaultTimeout);
    } else {
      fcmToken = await FirebaseMessaging.instance
          .getToken()
          .onError((error, _) => null)
          .timeout(kDefaultTimeout);
    }

    print(fcmToken);
    if (fcmToken == null) {
      throw "Unable to retrieve FCM token.";
    }

    final result = await AuthenticationRepository().updateFcmToken(
      fcmToken: fcmToken,
      accessToken: accessToken,
    );

    if (result is! CallbackSuccess) {
      throw result.message ?? "Failed to update FCM token on server.";
    }

    return fcmToken;
  } catch (e) {
    rethrow;
  }
}

/// account settings handlers
Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final String def = 'UnknownDevice';

  try {
    if (kIsWeb) {
      WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      return webInfo.userAgent ?? def;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo
          .id; // OR use androidInfo.androidId (deprecated but sometimes used)
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? def;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      return macInfo.systemGUID ?? def;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId ?? def;
    }

    return 'UnknownPlatform';
  } catch (e) {
    debugPrint("Failed to get device ID: $e");
    return def;
  }
}

/// connectivity
/*Future<bool> checkInternetConnectivity() async {
  return true;

  try {
    final hostUrl = ConfigService().getConfig('appDomain');

    final result = await InternetAddress.lookup(Uri.parse(hostUrl).host);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true; // Connected to the internet
    }
  } on SocketException catch (e) {
    return false; // No internet connection
  }
  return false;
}*/

/*Future<bool> checkServerConnectivity() async {
  try {
    final result = await AuthenticationRepository().serverConnectivity();

    if (result is CallbackSuccess) {
      return true;
    }
    return false;
  } catch (e) {
    return false;
    // rethrow;
  }
}*/
