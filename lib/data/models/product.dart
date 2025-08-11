import 'dart:convert';
import 'package:intl/intl.dart';

Product productNewFromJson(String str) => Product.fromJson(json.decode(str));

String productNewToJson(Product data) => json.encode(data.toJson());

List<Product> mockProducts = List.filled(20, Product(
  id: '1',
  pluCode: 'PLU12345',
  itemCode: 'ITM001',
  itemDesc: 'Wireless Mouse',
  itemPrice: 1500.00,
  itemDisPrice: 1299.00,
  itemGroup: 'Electronics',
  itemOnhand: 25,
  proHighlights: 'Ergonomic design, Long battery life',
  proDescription: 'A comfortable wireless mouse with advanced optical tracking.',
  createdBy: 'admin',
  createDate: DateTime(2024, 5, 12),
  timeStamp: 1715500000,
  imageUrl: [
    'assets/images/super-centre-placeholder.jpg',
  ],
  reviews: List.filled(10, Review(
      userId: "0065087646",
      userName: "GAYAN WEERA",
      profilePic: "",
      review: "",
      comment: "",
      reply: "",
      reportAbuse: "",
      rating: 4,
      like: 0,
      datetime: 1748335461919,
      images: []
  )),
  currency: 'LKR',
));

class Product {
  final String? id;
  final String? pluCode;
  final String? itemCode;
  final String? itemDesc;
  final num? itemPrice;
  final num? itemDisPrice;
  final String? itemGroup;
  final int? itemOnhand;
  final String? proHighlights;
  final String? proDescription;
  final String? createdBy;
  final DateTime? createDate;
  final int? timeStamp;
  final List<String> imageUrl;
  final List<Review> reviews;
  final String? currency;

  Product({
    this.id,
    this.pluCode,
    this.itemCode,
    this.itemDesc,
    this.itemPrice,
    this.itemDisPrice,
    this.itemGroup,
    this.itemOnhand,
    this.proHighlights,
    this.proDescription,
    this.createdBy,
    this.createDate,
    this.timeStamp,
    this.imageUrl = const <String>[],
    this.reviews = const <Review>[],
    this.currency = 'Rs',
  });

  static List<Product> mapFromList(List list) =>
      List<Product>.from(list.map((x) => Product.fromJson(x)));

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      pluCode: json["pluCode"],
      itemCode: json["itemCode"],
      itemDesc: json["itemDesc"],
      itemPrice: json["itemPrice"]?.toDouble(),
      itemDisPrice: json["itemDisPrice"],
      itemGroup: json["itemGroup"],
      itemOnhand: json["itemOnhand"],
      proHighlights: json["proHighlights"],
      proDescription: json["proDescription"],
      createdBy: json["createdBy"],
      createDate: json["createDate"] == null ? null : DateTime.tryParse(json["createDate"]),
      timeStamp: json["timeStamp"],
      imageUrl: json["imageUrl"] == null ? [] :  (json["imageUrl"] is String) ? [json["imageUrl"] as String] : List<String>.from(json["imageUrl"]),
      reviews: json["reviews"] == null
          ? []
          : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "pluCode": pluCode,
    "itemCode": itemCode,
    "itemDesc": itemDesc,
    "itemPrice": itemPrice,
    "itemDisPrice": itemDisPrice,
    "itemGroup": itemGroup,
    "itemOnhand": itemOnhand,
    "proHighlights": proHighlights,
    "proDescription": proDescription,
    "createdBy": createdBy,
    "createDate": createDate?.toIso8601String(),
    "timeStamp": timeStamp,
    "imageUrl": imageUrl,
    "reviews": reviews.map((e) => e.toJson()).toList(),
  };

  /// Computed properties
  int get discountPct {
    if (itemPrice != null && itemDisPrice != null) {
      return (((itemPrice! - itemDisPrice!) * 100) / itemPrice!).toInt();
    }
    return 0;
  }

  String get highlightedPriceStr {
    if (itemDisPrice != null && itemDisPrice! > 0) {
      return itemDisPriceStr;
    } else if (itemPrice != null && itemPrice! > 0) {
      return itemPriceStr;
    } else {
      return '0.00';
    }
  }

  String? get lineThroughPriceStr {
    if (itemDisPrice != null && itemDisPrice! > 0) {
      return itemPriceStr;
    }
    return null;
  }

  int get totalReviews => reviews.length;

  double get averageRating {
    if (reviews.isEmpty) {
      return 0.0;
    }

    final num sum = reviews.map((e) => e.rating).toList().reduce((a, b) => a + b);
    final count = reviews.length;

    return (sum / count).toDouble();
  }

  Map<String, dynamic> get countByRating {
    if (reviews.isEmpty) {
      return {
        "all": 0,
        "5": 0,
        "4": 0,
        "3": 0,
        "2": 0,
        "1": 0,
      };
    }

    return {
      "all": reviews.length,
      "5": reviews.where((e) => e.rating > 4 && e.rating <= 5).length,
      "4": reviews.where((e) => e.rating > 3 && e.rating <= 4).length,
      "3": reviews.where((e) => e.rating > 2 && e.rating <= 3).length,
      "2": reviews.where((e) => e.rating > 1 && e.rating <= 2).length,
      "1": reviews.where((e) => e.rating > 0 && e.rating <= 1).length,
    };
  }

  String get itemDisPriceStr =>
      "$currency ${NumberFormat("#,##0.00").format(itemDisPrice)}";

  String get itemPriceStr =>
      "$currency ${NumberFormat("#,##0.00").format(itemPrice)}";

}

class Review {
  final String? userId;
  final String? userName;
  final String? profilePic;
  final String? review;
  final String? comment;
  final String? reply;
  final String? reportAbuse;
  final num rating;
  final int like;
  final int? datetime;
  final List<String> images;

  Review({
    this.userId,
    this.userName,
    this.profilePic,
    this.review,
    this.comment,
    this.reply,
    this.reportAbuse,
    this.rating = 0,
    this.like = 0,
    this.datetime,
    this.images = const <String> [],
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["userId"],
        userName: json["userName"],
        profilePic: json["profilePic"],
        review: json["review"],
        comment: json["comment"],
        reply: json["reply"],
        reportAbuse: json["reportAbuse"],
        rating: json["rating"],
        like: json["like"],
        datetime: json["datetime"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "profilePic": profilePic,
        "review": review,
        "comment": comment,
        "reply": reply,
        "reportAbuse": reportAbuse,
        "rating": rating,
        "like": like,
        "datetime": datetime,
        "images": images,
      };
}
