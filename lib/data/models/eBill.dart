// import 'dart:convert';
//
// EBill eBillFromJson(String str) => EBill.fromJson(json.decode(str));
//
// String eBillToJson(EBill data) => json.encode(data.toJson());
//
// // class EBill {
// //   final DateTime? date;
// //   final int? points;
// //   final String? location;
// //   final dynamic amount;
// //
// //   EBill({
// //     this.date,
// //     this.points,
// //     this.location,
// //     this.amount,
// //   });
// //
// //   factory EBill.fromJson(Map<String, dynamic> json) => EBill(
// //     date: json["date"] == null ? null : DateTime.parse(json["date"]),
// //     points: json["points"],
// //     location: json["location"],
// //     amount: json["amount"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
// //     "points": points,
// //     "location": location,
// //     "amount": amount,
// //   };
// // }
//
// class EBill {
//   final DateTime? date;
//   final int? points;
//   final String? location;
//   final dynamic amount;
//
//   EBill({
//     this.date,
//     this.points,
//     this.location,
//     this.amount,
//   });
//
//   // Factory constructor to create an instance from a JSON map
//   factory EBill.fromJson(Map<String, dynamic> json) {
//     return EBill(
//       date: json['date'] != null ? DateTime.parse(json['date']) : null,
//       points: json['points'] as int?,
//       location: json['location'] as String?,
//       amount: json['amount'],
//     );
//   }
//
//   // Method to convert an instance to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       'date': date?.toIso8601String(),
//       'points': points,
//       'location': location,
//       'amount': amount,
//     };
//   }
// }

import 'dart:convert';
import 'dart:math';

import '../../core/utils/date_helper.dart';

List<EBill> mockEBills = List.filled(20, EBill(
  datetime: DateHelper.getRandomDate(start: DateTime(2022, 3, 14), end: DateTime.now()),
  locCode: '10',
  location: 'Navinna, Maharagama',
  totalDiscount: 0,
  grossAmount: 0,
  billValue: 1000.0,
  netBillValue: 0,
  total: 0,
  loyalty: Loyalty(
    billEarnPoints: Random().nextInt(100),
  ),
  eBillUrl: '',
));

class EBill {
  final int? receiptNo;
  final DateTime? datetime;
  final String? locCode;
  final String? location;
  final num? totalDiscount;
  final num? grossAmount;
  final num? billValue;
  final num? netBillValue;
  final num? total;
  final Loyalty? loyalty;
  final String? eBillUrl;

  EBill({
    this.receiptNo,
    this.datetime,
    this.locCode,
    this.location,
    this.totalDiscount,
    this.grossAmount,
    this.billValue,
    this.netBillValue,
    this.total,
    this.loyalty,
    this.eBillUrl,
  });

  static bool isDuplicate(EBill a, EBill b) {
    return a.eBillUrl == b.eBillUrl;
  }

  factory EBill.fromRawJson(String str) => EBill.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static List<EBill> mapFromList(List list) =>
      list.whereType<Map<String, dynamic>>().map((x) => EBill.fromJson(x)).toList();

  factory EBill.fromJson(Map<String, dynamic> json) => EBill(
    receiptNo: json["receiptNo"],
    datetime: json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
    locCode: json["locCode"],
    location: json["location"],
    totalDiscount: json["totalDiscount"]?.toDouble(),
    grossAmount: json["grossAmount"]?.toDouble(),
    billValue: json["billValue"]?.toDouble(),
    netBillValue: json["netBillValue"],
    total: json["total"],
    loyalty: json["loyality"] == null ? null : Loyalty.fromJson(json["loyality"]),
    eBillUrl: json["ebillURL"],
  );

  Map<String, dynamic> toJson() => {
    "receiptNo": receiptNo,
    "datetime": "${datetime!.year.toString().padLeft(4, '0')}-${datetime!.month.toString().padLeft(2, '0')}-${datetime!.day.toString().padLeft(2, '0')}",
    "locCode": locCode,
    "location": location,
    "totalDiscount": totalDiscount,
    "grossAmount": grossAmount,
    "billValue": billValue,
    "netBillValue": netBillValue,
    "total": total,
    "loyality": loyalty?.toJson(),
    "ebillURL": eBillUrl,
  };
}

class Loyalty {
  final String? cardId;
  final String? mobileNo;
  final String? name;
  final num? currPointBalance;
  final num? billEarnPoints;
  final num? redeemPoints;
  final num? billPurchasePoints;
  final num? totalPoint;

  Loyalty({
    this.cardId,
    this.mobileNo,
    this.name,
    this.currPointBalance,
    this.billEarnPoints,
    this.redeemPoints,
    this.billPurchasePoints,
    this.totalPoint,
  });

  factory Loyalty.fromRawJson(String str) => Loyalty.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Loyalty.fromJson(Map<String, dynamic> json) => Loyalty(
    cardId: json["cardId"],
    mobileNo: json["mobileNo"],
    name: json["name"],
    currPointBalance: json["currPointBalance"],
    billEarnPoints: json["billEarnPoints"],
    redeemPoints: json["redeemPoints"],
    billPurchasePoints: json["billPurchasePoints"],
    totalPoint: json["totalPoint"],
  );

  Map<String, dynamic> toJson() => {
    "cardId": cardId,
    "mobileNo": mobileNo,
    "name": name,
    "currPointBalance": currPointBalance,
    "billEarnPoints": billEarnPoints,
    "redeemPoints": redeemPoints,
    "billPurchasePoints": billPurchasePoints,
    "totalPoint": totalPoint,
  };
}

