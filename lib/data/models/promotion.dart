import 'dart:convert';

List<Promotion> mockPromotions = List.filled(20, Promotion(
  id: '1',
  proId: 'PROMO001',
  proDescri: 'Buy 1 Get 1 Free on selected items',
  proStartDate: DateTime(2025, 6, 1),
  proEndDate: DateTime(2025, 6, 15),
  proStatus: 'ACT',
  proRepeat: 'Weekly',
  proDisplayPlu: 'PLU12345',
  proReference: 'REF001',
  createdBy: 'admin',
  createDate: DateTime(2025, 5, 25),
  timeStamp: 1717473600,
  imageUrl: [
    //'https://example.com/promo/bogo1.jpg',
  ],
  reviews: [],
));

class Promotion {
  final String? id;
  final String? proId;
  final String? proDescri;
  final DateTime? proStartDate;
  final DateTime? proEndDate;
  final String? proStatus;
  final String? proRepeat;
  final String? proDisplayPlu;
  final String? proReference;
  final String? createdBy;
  final DateTime? createDate;
  final int? timeStamp;
  final List<String> imageUrl;
  final List<dynamic>? reviews;

  Promotion({
    this.id,
    this.proId,
    this.proDescri,
    this.proStartDate,
    this.proEndDate,
    this.proStatus,
    this.proRepeat,
    this.proDisplayPlu,
    this.proReference,
    this.createdBy,
    this.createDate,
    this.timeStamp,
    this.imageUrl = const <String>[],
    this.reviews,
  });

  Duration? get expDateRange {
    if(proEndDate == null){
      return null;
    }

    final now = DateTime.now();
    return proEndDate!.difference(DateTime(now.year, now.month, now.day));
  }

  static List<Promotion> mapFromList(List list) =>
      List<Promotion>.from(list.map((x) => Promotion.fromJson(x)));

  factory Promotion.fromRawJson(String str) => Promotion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  static Promotion def = Promotion();

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
    id: json["_id"],
    proId: json["proId"],
    proDescri: json["proDescri"],
    proStartDate: json["proStartDate"] == null ? null : DateTime.tryParse(json["proStartDate"]),
    proEndDate: json["proEndDate"] == null ? null : DateTime.tryParse(json["proEndDate"]),
    proStatus: json["proStatus"],
    proRepeat: json["proRepeat"],
    proDisplayPlu: json["proDisplayPlu"],
    proReference: json["proReference"],
    createdBy: json["createdBy"],
    createDate: json["createDate"] == null ? null : DateTime.tryParse(json["createDate"]),
    timeStamp: json["timeStamp"],
    imageUrl: json["imageUrl"] == null ? [] : List<String>.from(json["imageUrl"].map((x) => x)),
    // reviews: json["reviews"] == null ? [] : List<dynamic>.from(json["reviews"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "proId": proId,
    "proDescri": proDescri,
    "proStartDate": "${proStartDate!.year.toString().padLeft(4, '0')}-${proStartDate!.month.toString().padLeft(2, '0')}-${proStartDate!.day.toString().padLeft(2, '0')}",
    "proEndDate": "${proEndDate!.year.toString().padLeft(4, '0')}-${proEndDate!.month.toString().padLeft(2, '0')}-${proEndDate!.day.toString().padLeft(2, '0')}",
    "proStatus": proStatus,
    "proRepeat": proRepeat,
    "proDisplayPlu": proDisplayPlu,
    "proReference": proReference,
    "createdBy": createdBy,
    "createDate": createDate?.toIso8601String(),
    "timeStamp": timeStamp,
    "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x)),
  };
}