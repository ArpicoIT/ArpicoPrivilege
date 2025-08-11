import 'dart:convert';

class Points {
  final String? sbuCode;
  final String? custId;
  final String? loyalType;
  final num? loyalPoints;
  final num? cummPoints;
  final num? cummRedem;
  final num? minPointbal;
  final DateTime? lastPurDate;
  final DateTime? lastRedDate;
  final String? status;
  final num? promoPoints;
  final num? cummExpoints;

  Points({
    this.sbuCode,
    this.custId,
    this.loyalType,
    this.loyalPoints,
    this.cummPoints,
    this.cummRedem,
    this.minPointbal,
    this.lastPurDate,
    this.lastRedDate,
    this.status,
    this.promoPoints,
    this.cummExpoints,
  });

  factory Points.fromRawJson(String str) => Points.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    sbuCode: json["sbuCode"],
    custId: json["custId"],
    loyalType: json["loyalType"],
    loyalPoints: json["loyalPoints"],
    cummPoints: json["cummPoints"],
    cummRedem: json["cummRedem"],
    minPointbal: json["minPointbal"],
    lastPurDate: json["lastPurDate"] == null ? null : DateTime.parse(json["lastPurDate"]),
    lastRedDate: json["lastRedDate"] == null ? null : DateTime.parse(json["lastRedDate"]),
    status: json["status"],
    promoPoints: json["promoPoints"],
    cummExpoints: json["cummExpoints"],
  );

  Map<String, dynamic> toJson() => {
    "sbuCode": sbuCode,
    "custId": custId,
    "loyalType": loyalType,
    "loyalPoints": loyalPoints,
    "cummPoints": cummPoints,
    "cummRedem": cummRedem,
    "minPointbal": minPointbal,
    "lastPurDate": lastPurDate?.toIso8601String(),
    "lastRedDate": lastRedDate?.toIso8601String(),
    "status": status,
    "promoPoints": promoPoints,
    "cummExpoints": cummExpoints,
  };
}
