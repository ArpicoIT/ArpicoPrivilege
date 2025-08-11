import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:arpicoprivilege/shared/customize/custom_toast.dart';
import 'package:flutter/material.dart';

import '../../shared/customize/custom_alert.dart';

class ErrorHandler {
  final BuildContext context;

  ErrorHandler._(this.context);

  static ErrorHandler of(BuildContext context) {
    return ErrorHandler._(context);
  }

  Future showDialog(dynamic error) async {
    try {
      if (error is SocketException) {
        CustomAlert.of(context).openDialog(
            title: "No Internet Connection",
            message: "Please check your connection and try again.",
            allowMultiple: false,
            isCanceled: true,
            confirmText: 'Settings',
            onConfirm: (ctx) {
              // Navigator.of(ctx).pop();
              AppSettings.openAppSettings(
                  type: AppSettingsType.generalSettings);
            });
      } else if (error is TimeoutException) {
        CustomAlert.of(context).openDialog(
            title: "Request Timed Out",
            message: "The request took too long to respond.",
            allowMultiple: false,
            isCanceled: true,
            confirmText: 'Settings',
            onConfirm: (ctx) {
              Navigator.of(ctx).pop();
              AppSettings.openAppSettings(
                  type: AppSettingsType.generalSettings);
            });
      } else {
        return error; // default fallback
      }
    } catch (e) {
      return e;
    }
    return null;
  }

  dynamic showToast(dynamic error) {
    try {
      if (error is SocketException) {
        CustomToast.of(context).showPrimary(
            "No Internet Connection");
      } else if (error is TimeoutException) {
        CustomToast.of(context).showPrimary(
            "Request Timed Out");
      } else {
        return error; // default fallback
      }
    } catch (e) {
      return e;
    }
    return null;
  }
}
