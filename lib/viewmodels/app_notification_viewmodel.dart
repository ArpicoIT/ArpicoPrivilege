
import 'package:arpicoprivilege/data/models/app_notification.dart';
import 'package:arpicoprivilege/data/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../core/handlers/callback_handler.dart';
import '../core/handlers/error_handler.dart';
import '../core/utils/list_helper.dart';
import '../handler.dart';
import '../shared/customize/custom_toast.dart';
import 'base_viewmodel.dart';

class AppNotificationViewmodel extends BaseViewModel {
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;


  Future<List<AppNotification>> _getNotifications() async {
    final toast = CustomToast.of(context);
    final errorHandler = ErrorHandler.of(context);

    try {
      final accessToken = await getValidAccessToken();

      final result = await NotificationRepository().getNotifications(accessToken);

      if (result is CallbackSuccess) {
        _notifications = result.data ?? [];
        notifyListeners();
      } else {
        throw result.message;
      }

      if (result is CallbackSuccess) {
        if (result.data?.isNotEmpty == true) {
          return result.data!;
          // model.data += result.data!;
          //
          // final mappedList = ListHelper.paginationList<Notification>(
          //     data: model.data,
          //     whereFn: (i, e) => i.id == e.id, limit: model.limit);
          //
          // model.data = mappedList['data'];
          // model.offset = mappedList['offset'];
          //
          // return model;
        } else {
          throw CallbackError("No more notifications available", 404);
        }
      } else {
        throw result;
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      if(error == null || error is CallbackError && error.code == 404){
        debugPrint(error.toString());
      } else {
        toast.showPrimary(error.toString());
      }
      return [];
    }
  }

  Future<void> refreshNotifications() async {
    _notifications = await _getNotifications();
    setLoading(false);
  }

  Future<void> loadInitialNotifications() async {
    setLoading(true);
    _notifications = await _getNotifications();
    setLoading(false);
  }

  Future<void> loadMoreNotifications(int index) async {
    _notifications = await _getNotifications();
    notifyListeners();
  }

}