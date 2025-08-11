import 'package:arpicoprivilege/core/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/handlers/error_handler.dart';
import '../../core/utils/validates.dart';
import '../../data/repositories/authentication_repository.dart';
import '../../handler.dart';
import '../../shared/customize/custom_alert.dart';
import '../../shared/customize/custom_loader.dart';
import '../../shared/customize/custom_toast.dart';
import '../../core/services/storage_service.dart';
import '../repositories/app_cache_repository.dart';

enum LoginWith { phone, nic }

mixin AuthenticationMixin {
  void logout(BuildContext context) async {
    final alert = CustomAlert.of(context);
    final navigator = Navigator.of(context);

    if (await alert.openDialog(
            title: "Log out",
            message: "Are you sure you want to log out?",
            confirmText: "Log out",
            isCanceled: true) == "OK") {

      final bool result = await requestLogout();

      // if(result){
      //   return;
      // }

      StorageService.instance.deleteAll();
      SharedPrefsService.clearAll();
      navigator.pushNamedAndRemoveUntil(AppRoutes.intro, (route) => false);

    } else {
      return;
    }
  }

  Future<bool> requestLogout() async {
    try {
      final accessToken = await getValidAccessToken();
      final loginUser = await decodeValidLoginUser();
      final uuid = await getDeviceId();

      final result = await AuthenticationRepository().logout(
          custId: loginUser.loginCustId!,
          mobile: loginUser.loginCustMobNo!,
          uuid: uuid,
          token: accessToken
      );

      return result is CallbackSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestPhoneOtp(BuildContext context, String mobile) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);
    try {
      await loader.show();

      final loginUser = await decodeValidLoginUser();

      final requestOtpResult = await AuthenticationRepository().requestOtp(
          nic: loginUser.loginCustNic!,
          mobile: mobile,
          uuid: loginUser.loginCustUuid!);

      await loader.close();

      toast.showPrimary(requestOtpResult.message);

      return requestOtpResult is CallbackSuccess;
    } catch (e) {
      // toast.showPrimary(e.toString());
      await loader.close();
      rethrow;
    }
    return false;
  }

  Future<bool> verifyPhoneOtp(
      BuildContext context, String mobile, String otpCode) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);
    try {
      await loader.show();

      final loginUser = await decodeValidLoginUser();

      final verifyOtpResult = await AuthenticationRepository().verifyOtp(
          nic: loginUser.loginCustNic!, mobile: mobile, otp: otpCode);

      await loader.close();

      toast.showPrimary(verifyOtpResult.message);

      return verifyOtpResult is CallbackSuccess;
    } catch (e) {
      // toast.showPrimary(e.toString());
      await loader.close();
      rethrow;
    }
    return false;
  }

  Future<bool> requestEmailOtp(BuildContext context, String email) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);
    try {
      await loader.show();

      final loginUser = await decodeValidLoginUser();

      final requestOtpResult = await AuthenticationRepository().requestOtp(
          nic: loginUser.loginCustNic!,
          email: email,
          uuid: loginUser.loginCustUuid!);

      await loader.close();

      toast.showPrimary(requestOtpResult.message);
      return requestOtpResult is CallbackSuccess;
    } catch (e) {
      // toast.showPrimary(e.toString());
      await loader.close();
      rethrow;
    }
    return false;
  }

  Future<bool> verifyEmailOtp(
      BuildContext context, String email, String otpCode) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);
    try {
      await loader.show();

      final loginUser = await decodeValidLoginUser();

      final verifyOtpResult = await AuthenticationRepository()
          .verifyOtp(nic: loginUser.loginCustNic!, email: email, otp: otpCode);

      await loader.close();

      toast.showPrimary(verifyOtpResult.message);

      return verifyOtpResult is CallbackSuccess;
    } catch (e) {
      // toast.showPrimary(e.toString());
      await loader.close();
      rethrow;
    }
    return false;
  }

  Future<CallbackResult> requestLogin(BuildContext context, {required LoginWith loginWith, required String loginAddress}) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);

    try {
      await loader.show();

      late CallbackResult<Map<String, dynamic>> result;

      switch (loginWith) {
        case LoginWith.phone:
          result = await AuthenticationRepository().requestLogin(phone: loginAddress);
          break;
        case LoginWith.nic:
          if(Validates.isValidNic(loginAddress)){
            result = await AuthenticationRepository().requestLogin(nic: loginAddress);
            break;
          }
          else if(Validates.isValidLoyaltyCard(loginAddress)){
            result = await AuthenticationRepository().requestLogin(custId: loginAddress);
            break;
          }
          else {
            throw "Invalid login address";
          }
      }
      await loader.close();
      toast.showPrimary(result.message);
      return result;
    } catch (e) {
      await loader.close();
      rethrow;
      await loader.close();
      toast.showPrimary(e.toString());
      return CallbackError(e.toString(), 400);
    }
  }

  Future<CallbackResult> verifyLogin(BuildContext context,
      {required LoginWith loginWith,
      required String otp,
      required String loginAddress}) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);

    try {
      await loader.show();
      late CallbackResult<Map<String, dynamic>> result;
      switch (loginWith) {
        case LoginWith.phone:
          result = await AuthenticationRepository()
              .verifyLogin(otp: otp, phone: loginAddress);
          break;
        case LoginWith.nic:
          if(Validates.isValidNic(loginAddress)){
            result = await AuthenticationRepository().verifyLogin(otp: otp, nic: loginAddress);
            break;
          }
          else if(Validates.isValidLoyaltyCard(loginAddress)){
            result = await AuthenticationRepository().verifyLogin(otp: otp, custId: loginAddress);
            break;
          }
          else {
            throw "Invalid login address";
          }
      }
      await loader.close();

      // check result status
      if (result is CallbackSuccess) {
        final accessToken = result.data!["token"];
        // save token in storage
        await saveAccessToken(accessToken);
        return result;
      } else {
        throw result.message;
      }
    } catch (e) {
      await loader.close();
      rethrow;
      await loader.close();
      toast.showPrimary(e.toString());
      return CallbackError(e.toString(), 400);
    }
  }

  Future<CallbackResult> requestRegistration(
    BuildContext context, {
    required String custId,
    required String nic,
    required String mobile,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);

    try {
      await loader.show();

      final String uuid = await getDeviceId();

      final result = await AuthenticationRepository()
          .requestRegistration(
              custId: custId,
              nic: nic,
              mobile: mobile,
              email: email,
              firstName: firstName,
              lastName: lastName,
              uuid: uuid
      );

      await loader.close();
      toast.showPrimary(result.message);

      return result;
    } catch (e) {
      await loader.close();
      rethrow;
    }
  }

  Future<CallbackResult> verifyRegistration(BuildContext context, String code,
      {required String token}) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);

    try {
      await loader.show();

      if (token.startsWith("Bearer ")) {
        token = token.replaceFirst('Bearer ', '');
      }

      final result = await AuthenticationRepository()
          .verifyRegistration(otp: code, token: token);

      await loader.close();
      toast.showPrimary(result.message);

      return result;
    } catch (e) {
      await loader.close();
      rethrow;
    }
  }
}
