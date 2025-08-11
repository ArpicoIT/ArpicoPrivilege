import 'dart:convert';

import 'package:arpicoprivilege/core/extentions/string_extensions.dart';

class User {
  final String? id;
  final dynamic? sbuCode;
  final String? custTitle;
  final String? custFirstName;
  final String? custLastName;
  final String? custId;
  final String? custLocCode;
  final DateTime? custDob;
  final String? custNic;
  final String? custSex;
  final String? custMobNo1;
  final String? custMobNo2;
  final String? custEmail1;
  final String? custPreAdd1;
  final String? custPreAdd2;
  final String? custPreAdd3;
  final String? custPreCity;
  final String? cardTypeId;
  final String? parentNo;
  final String? oldCardNo;
  final List<dynamic>? ebillDetails;
  final List<dynamic>? loyalityPoints;
  final List<dynamic>? loyalityPromotions;

  User({
    this.id,
    this.sbuCode,
    this.custTitle,
    this.custFirstName,
    this.custLastName,
    this.custId,
    this.custLocCode,
    this.custDob,
    this.custNic,
    this.custSex,
    this.custMobNo1,
    this.custMobNo2,
    this.custEmail1,
    this.custPreAdd1,
    this.custPreAdd2,
    this.custPreAdd3,
    this.custPreCity,
    this.cardTypeId,
    this.parentNo,
    this.oldCardNo,
    this.ebillDetails,
    this.loyalityPoints,
    this.loyalityPromotions,
  });

  User copyWith({
    String? id,
    String? sbuCode,
    String? custTitle,
    String? custFirstName,
    String? custLastName,
    String? custId,
    String? custLocCode,
    DateTime? custDob,
    String? custNic,
    String? custSex,
    String? custMobNo1,
    String? custMobNo2,
    String? custEmail1,
    String? custPreAdd1,
    String? custPreAdd2,
    String? custPreAdd3,
    String? custPreCity,
    String? cardTypeId,
    String? parentNo,
    String? oldCardNo,
    List<dynamic>? ebillDetails,
    List<dynamic>? loyalityPoints,
    List<dynamic>? loyalityPromotions,
  }) {
    return User(
      id: id ?? this.id,
      sbuCode: sbuCode ?? this.sbuCode,
      custTitle: custTitle ?? this.custTitle,
      custFirstName: custFirstName ?? this.custFirstName,
      custLastName: custLastName ?? this.custLastName,
      custId: custId ?? this.custId,
      custLocCode: custLocCode ?? this.custLocCode,
      custDob: custDob ?? this.custDob,
      custNic: custNic ?? this.custNic,
      custSex: custSex ?? this.custSex,
      custMobNo1: custMobNo1 ?? this.custMobNo1,
      custMobNo2: custMobNo2 ?? this.custMobNo2,
      custEmail1: custEmail1 ?? this.custEmail1,
      custPreAdd1: custPreAdd1 ?? this.custPreAdd1,
      custPreAdd2: custPreAdd2 ?? this.custPreAdd2,
      custPreAdd3: custPreAdd3 ?? this.custPreAdd3,
      custPreCity: custPreCity ?? this.custPreCity,
      cardTypeId: cardTypeId ?? this.cardTypeId,
      parentNo: parentNo ?? this.parentNo,
      oldCardNo: oldCardNo ?? this.oldCardNo,
      ebillDetails: ebillDetails ?? this.ebillDetails,
      loyalityPoints: loyalityPoints ?? this.loyalityPoints,
      loyalityPromotions: loyalityPromotions ?? this.loyalityPromotions,
    );
  }

  String? get custFullName =>
      [custFirstName, custLastName].where((e) => e != null).join(' ').trim().isEmpty
          ? null
          : [custFirstName, custLastName].whereType<String>().join(' ');

  // String? get custFullName {
  //   if (custFirstName != null && custLastName != null) {
  //     return "$custFirstName $custLastName";
  //   } else if(custFirstName != null) {
  //     return custFirstName;
  //   } else if(custLastName != null) {
  //     return custLastName;
  //   }
  //   else {
  //     return null;
  //   }
  // }

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    sbuCode: json["sbuCode"],
    custTitle: json["custTitle"],
    custFirstName: json["custFName"],
    custLastName: json["custLName"],
    custId: json["custId"],
    custLocCode: json["custLocCode"],
    custDob: json["custDob"] == null ? null : DateTime.parse(json["custDob"]),
    custNic: json["custNic"],
    custSex: json["custSex"],
    custMobNo1: json["custMobNo1"],
    custMobNo2: json["custMobNo2"],
    custEmail1: json["custEmail1"],
    custPreAdd1: json["custPreAdd1"],
    custPreAdd2: json["custPreAdd2"],
    custPreAdd3: json["custPreAdd3"],
    custPreCity: json["custPreCity"],
    cardTypeId: json["cardTypeId"],
    parentNo: json["parentNo"],
    oldCardNo: json["oldCardNo"],
    // ebillDetails: json["ebillDetails"] == null ? [] : List<dynamic>.from(json["ebillDetails"].map((x) => x)),
    // loyalityPoints: json["loyalityPoints"] == null ? [] : List<dynamic>.from(json["loyalityPoints"]!.map((x) => x)),
    // loyalityPromotions: json["loyalityPromotions"] == null ? [] : List<dynamic>.from(json["loyalityPromotions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "sbuCode": sbuCode,
    "custTitle": custTitle,
    "custFName": custFirstName,
    "custLName": custLastName,
    "custId": custId,
    "custLocCode": custLocCode,
    "custDob": "${custDob!.year.toString().padLeft(4, '0')}-${custDob!.month.toString().padLeft(2, '0')}-${custDob!.day.toString().padLeft(2, '0')}",
    "custNic": custNic,
    "custSex": custSex,
    "custMobNo1": custMobNo1,
    "custMobNo2": custMobNo2,
    "custEmail1": custEmail1,
    "custPreAdd1": custPreAdd1,
    "custPreAdd2": custPreAdd2,
    "custPreAdd3": custPreAdd3,
    "custPreCity": custPreCity,
    "cardTypeId": cardTypeId,
    "parentNo": parentNo,
    "oldCardNo": oldCardNo,
    "ebillDetails": ebillDetails == null ? [] : List<dynamic>.from(ebillDetails!.map((x) => x)),
    "loyalityPoints": loyalityPoints == null ? [] : List<dynamic>.from(loyalityPoints!.map((x) => x)),
    "loyalityPromotions": loyalityPromotions == null ? [] : List<dynamic>.from(loyalityPromotions!.map((x) => x)),
  };
}

class LoginUser {
  final String? loginCustId;
  final String? loginCustName;
  final String? loginCustLastName;
  final String? loginCustNic;
  final String? loginCustMobNo;
  final String? loginCustEmail;
  final String? loginCustUuid;
  final bool loginCustIsEbill;
  final bool loginCustIsLoyalty;
  final int? iat;
  final int? exp;

  LoginUser({
    this.loginCustId,
    this.loginCustName,
    this.loginCustLastName,
    this.loginCustNic,
    this.loginCustMobNo,
    this.loginCustEmail,
    this.loginCustUuid,
    this.loginCustIsEbill = false,
    this.loginCustIsLoyalty = false,
    this.iat,
    this.exp,
  });

  String? get loginCustFullName =>
      [loginCustName, loginCustLastName].where((e) => e != null).join(' ').trim().isEmpty
          ? null
          : [loginCustName, loginCustLastName].whereType<String>().join(' ');

  // String? get loginCustFullName {
  //   if (loginCustName != null && loginCustLastName != null) {
  //     return "$loginCustName $loginCustLastName";
  //   } else if(loginCustName != null) {
  //     return loginCustName;
  //   } else if(loginCustLastName != null) {
  //     return loginCustLastName;
  //   }
  //   else {
  //     return null;
  //   }
  // }

  factory LoginUser.fromRawJson(String str) => LoginUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    loginCustId: json["loginCustId"],
    loginCustName: json["loginCustName"],
    loginCustLastName: json["loginCustLastName"],
    loginCustNic: json["loginCustNic"],
    loginCustMobNo: json["loginCustMobNo"],
    loginCustEmail: json["loginCustEmail"],
    loginCustUuid: json["loginCustUuid"],
    loginCustIsEbill: json["loginCustIsEbill"] ?? false,
    loginCustIsLoyalty: json["loginCustIsLoyalty"] ?? false,
    iat: json["iat"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "loginCustId": loginCustId,
    "loginCustName": loginCustName,
    "loginCustLastName": loginCustLastName,
    "loginCustNic": loginCustNic,
    "loginCustMobNo": loginCustMobNo,
    "loginCustEmail": loginCustEmail,
    "loginCustUuid": loginCustUuid,
    "loginCustIsEbill": loginCustIsEbill,
    "loginCustIsLoyalty": loginCustIsLoyalty,
    "iat": iat,
    "exp": exp,
  };
}

/*class User {
  final String? custId;
  final String? custLocCode;
  final String? custTitle;
  final String? custName;
  final String? custOthName;
  final String? custCity;
  final DateTime? custDob;
  final String? custSex;
  final String? custNic;
  final dynamic custPasptNo;
  final String? custMobNo1;
  final dynamic custMobNo2;
  final String? custTelNo1;
  final dynamic custTelNo2;
  String? custEmail1;
  final dynamic custEmail2;
  final String? custOccu;
  final String? custType;
  final String? empRpg;
  final String? custInit;
  final String? custAppName;
  final String? custPreAdd1;
  final dynamic custPreAdd2;
  final dynamic custPreAdd3;
  final String? custPrefFlg;
  final DateTime? expdt;
  final String? parentNo;
  final String? cardTypeId;
  final String? custPreCity;
  final String? custStat1;

  final String? custLastName;
  final String? custUuid;
  final String? custFcmToken;
  final bool custIsEbill;
  final bool custIsLoyalty;

  final int? iat;
  final int? exp;

  User({
    this.custId,
    this.custLocCode,
    this.custTitle,
    this.custName,
    this.custOthName,
    this.custCity,
    this.custDob,
    this.custSex,
    this.custNic,
    this.custPasptNo,
    this.custMobNo1,
    this.custMobNo2,
    this.custTelNo1,
    this.custTelNo2,
    this.custEmail1,
    this.custEmail2,
    this.custOccu,
    this.custType,
    this.empRpg,
    this.custInit,
    this.custAppName,
    this.custPreAdd1,
    this.custPreAdd2,
    this.custPreAdd3,
    this.custPrefFlg,
    this.expdt,
    this.parentNo,
    this.cardTypeId,
    this.custPreCity,
    this.custStat1,

    this.custLastName,
    this.custUuid,
    this.custFcmToken,
    this.custIsEbill = false,
    this.custIsLoyalty = false,

    this.iat,
    this.exp,
  });

  // String? get fullName {
  //   return "";
  //   // if (firstName == null && lastName == null) return null;
  //   // return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  // }

  String? get custFullName {
    if(custAppName != null) {
      return custAppName;
    } else if (custName != null && custLastName != null) {
      return "$custName $custLastName";
    } else {
      return null;
    }
  }

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    custId: json["custId"] ?? json["loginCustId"],
    custLocCode: json["custLocCode"],
    custTitle: json["custTitle"],
    custName: json["custName"] ?? json["loginCustName"],
    custLastName: json["loginCustLastName"],

    custOthName: json["custOthName"],
    custCity: json["custCity"],
    custDob: json["custDob"] == null ? null : DateTime.parse(json["custDob"]),
    custSex: json["custSex"],
    custNic: json["custNic"] ?? json["loginCustNic"],
    custPasptNo: json["custPasptNo"],
    custMobNo1: (json["custMobNo1"] != null) ? json["custMobNo1"].toString().toNormalizeMobileNumber() : (json["loginCustMobNo"] != null) ? json["loginCustMobNo"].toString().toNormalizeMobileNumber() : null,
    custMobNo2: (json["custMobNo2"] != null) ? json["custMobNo2"].toString().toNormalizeMobileNumber() : null,
    custTelNo1: json["custTelNo1"],
    custTelNo2: json["custTelNo2"],
    custEmail1: json["custEmail1"] ?? json["loginCustEmail"],
    custEmail2: json["custEmail2"],
    custOccu: json["custOccu"],
    custType: json["custType"],
    empRpg: json["empRpg"],
    custInit: json["custInit"],
    custAppName: json["custAppName"],
    custPreAdd1: json["custPreAdd1"],
    custPreAdd2: json["custPreAdd2"],
    custPreAdd3: json["custPreAdd3"],
    custPrefFlg: json["custPrefFlg"],
    expdt: json["expdt"] == null ? null : DateTime.parse(json["expdt"]),
    parentNo: json["parentNo"],
    cardTypeId: json["cardTypeId"],
    custPreCity: json["custPreCity"],
    custStat1: json["custStat1"],

    custUuid: json["loginCustUuid"],
    custFcmToken: json["loginCustFcmToken"],
    custIsEbill: json["loginCustIsEbill"] == "true",
    custIsLoyalty: json["loginCustIsLoyalty"] == "true",

    iat: json["iat"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "custId": custId,
    "custLocCode": custLocCode,
    "custTitle": custTitle,
    "custName": custName,
    "custOthName": custOthName,
    "custCity": custCity,
    "custDob": custDob?.toIso8601String(),
    "custSex": custSex,
    "custNic": custNic,
    "custPasptNo": custPasptNo,
    "custMobNo1": custMobNo1,
    "custMobNo2": custMobNo2,
    "custTelNo1": custTelNo1,
    "custTelNo2": custTelNo2,
    "custEmail1": custEmail1,
    "custEmail2": custEmail2,
    "custOccu": custOccu,
    "custType": custType,
    "empRpg": empRpg,
    "custInit": custInit,
    "custAppName": custAppName,
    "custPreAdd1": custPreAdd1,
    "custPreAdd2": custPreAdd2,
    "custPreAdd3": custPreAdd3,
    "custPrefFlg": custPrefFlg,
    "expdt": expdt?.toIso8601String(),
    "parentNo": parentNo,
    "cardTypeId": cardTypeId,
    "custPreCity": custPreCity,
    "custStat1": custStat1,

    "loginCustId": custId,
    "loginCustName": custName,
    "loginCustLastName": custLastName,
    "loginCustNic": custNic,
    "loginCustMobNo": custMobNo1,
    "loginCustEmail": custEmail1,
    "loginCustUuid": custUuid,
    "loginCustFcmToken": custFcmToken,
    "loginCustIsEbill": custIsEbill,
    "loginCustIsLoyalty": custIsLoyalty,

    "iat": iat,
    "exp": exp,
  };
}*/

/*class LoginUser {
  final String? loginCustId;
  final String? loginCustName;
  final String? loginCustLastName;
  final String? loginCustNic;
  final String? loginCustMobNo;
  final String? loginCustEmail;
  final int? loginCustUuid;
  final int? iat;
  final int? exp;

  LoginUser({
    this.loginCustId,
    this.loginCustName,
    this.loginCustLastName,
    this.loginCustNic,
    this.loginCustMobNo,
    this.loginCustEmail,
    this.loginCustUuid,
    this.iat,
    this.exp,
  });

  factory LoginUser.fromRawJson(String str) => LoginUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    loginCustId: json["loginCustId"],
    loginCustName: json["loginCustName"],
    loginCustLastName: json["loginCustLastName"],
    loginCustNic: json["loginCustNic"],
    loginCustMobNo: json["loginCustMobNo"],
    loginCustEmail: json["loginCustEmail"],
    loginCustUuid: json["loginCustUuid"],
    iat: json["iat"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "loginCustId": loginCustId,
    "loginCustName": loginCustName,
    "loginCustLastName": loginCustLastName,
    "loginCustNic": loginCustNic,
    "loginCustMobNo": loginCustMobNo,
    "loginCustEmail": loginCustEmail,
    "loginCustUuid": loginCustUuid,
    "iat": iat,
    "exp": exp,
  };
}*/
