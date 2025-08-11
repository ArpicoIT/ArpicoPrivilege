import 'package:flutter/material.dart';

import '../../core/services/shared_prefs_service.dart';
import '../models/product.dart';
import '../models/promotion.dart';
import '../models/user.dart';

class AppCacheRepository {
  static const String PROMOTIONS = "current_promotions";
  static const String PRODUCTS = "current_products";
  static const String VALIDUSER = "valid_user";
  static const String SEARCHEDPRODUCTHISTORY = "searched_product_history";

  // load[Feature]Cache()
  // save[Feature]Cache()

  /// promotions
  static List<Promotion> loadPromotionsCache() =>
      SharedPrefsService.getModelList<Promotion>(PROMOTIONS, (e) => Promotion.fromJson(e));

  static Future<bool> savePromotionsCache(List<Promotion> data) async {
    try {
      await SharedPrefsService.saveModelList<Promotion>(PROMOTIONS, data, (e) => e.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// products
  static List<Product> loadProductsCache() =>
      SharedPrefsService.getModelList<Product>(PRODUCTS, (e) => Product.fromJson(e));

  static Future<bool> saveProductsCache(List<Product> data) async {
    try {
      await SharedPrefsService.saveModelList<Product>(PRODUCTS, data, (e) => e.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// notifications
  static List<Product> loadNotificationsCache() =>
      SharedPrefsService.getModelList<Product>(PRODUCTS, (e) => Product.fromJson(e));

  static Future<bool> saveNotificationsCache(List<Product> data) async {
    try {
      await SharedPrefsService.saveModelList<Product>(PRODUCTS, data, (e) => e.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// user
  static User? loadUserCache() => SharedPrefsService.getModel(VALIDUSER, (e) => User.fromJson(e));

  static Future<bool> saveUserCache(User data) async {
    try {
      await SharedPrefsService.saveModel(VALIDUSER, data, (e) => e.toJson());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// searched history
  static List<String> loadSearchedHistoryCache() =>
      SharedPrefsService.getStringList(SEARCHEDPRODUCTHISTORY);

  static Future<bool> saveSearchedHistoryCache(List<String> data) async {
    try {
      await SharedPrefsService.saveStringList(SEARCHEDPRODUCTHISTORY, data);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> deleteSearchedHistoryCache() async {
    try {
      await SharedPrefsService.remove(SEARCHEDPRODUCTHISTORY);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
