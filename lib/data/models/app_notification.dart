import 'dart:convert';

List<AppNotification> mockNotifications = List.filled(20, AppNotification(
    notifyId: "2",
    title: "New App Promo",
    message: "Get Firest Login Promo",
    executedDateTime: DateTime.parse("2025-03-25T04:32:52.556Z"),
    messageType: "info",
    status: "scheduled",
    repeatType: "daily",
    createDate: DateTime.parse("2025-03-24T12:00:15.473Z"))
);


class AppNotification {
  final String? id;
  final String? notifyId;
  final String? title;
  final String? message;
  final OnclickAction? onclickAction;
  final DateTime? executedDateTime;
  final String? messageType;
  final String? status;
  final String? repeatType;
  final DateTime? createDate;

  AppNotification({
    this.id,
    this.notifyId,
    this.title,
    this.message,
    this.onclickAction,
    this.executedDateTime,
    this.messageType,
    this.status,
    this.repeatType,
    this.createDate,
  });

  factory AppNotification.fromRawJson(String str) => AppNotification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<AppNotification> mapFromList(List list) =>
      list.whereType<Map<String, dynamic>>().map((x) => AppNotification.fromJson(x)).toList();

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json["_id"],
    notifyId: json["notifyId"],
    title: json["title"],
    message: json["message"],
    onclickAction: json["onclickAction"] == null ? null : OnclickAction.fromJson(json["onclickAction"]),
    executedDateTime: json["executedDateTime"] == null ? null : DateTime.parse(json["executedDateTime"]),
    messageType: json["messageType"],
    status: json["status"],
    repeatType: json["repeatType"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "notifyId": notifyId,
    "title": title,
    "message": message,
    "onclickAction": onclickAction?.toJson(),
    "executedDateTime": executedDateTime?.toIso8601String(),
    "messageType": messageType,
    "status": status,
    "repeatType": repeatType,
    "createDate": createDate?.toIso8601String(),
  };
}

class OnclickAction {
  final String? url;

  OnclickAction({
    this.url,
  });

  factory OnclickAction.fromRawJson(String str) => OnclickAction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OnclickAction.fromJson(Map<String, dynamic> json) => OnclickAction(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}