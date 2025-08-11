import 'dart:async';
import 'dart:io';
import 'package:arpicoprivilege/shared/customize/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../core/handlers/callback_handler.dart';
import '../../core/handlers/error_handler.dart';
import '../../core/utils/list_helper.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../../handler.dart';
import '../../shared/customize/custom_alert.dart';
import '../../shared/customize/custom_toast.dart';

mixin ProductMixin on ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;
  set products (List<Product> value){
    _products = value;
    notifyListeners();
  }

  Product _product = Product();
  Product get product => _product;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  final int _limit = 10;
  int _offset = 0;

  String? _searchKey;
  String? get searchKey => _searchKey;
  set searchKey(String? value) {
    _searchKey = value;
  }



  List<Product> productsByTab(int tabIndex) => _products.where((e) {
    switch (tabIndex) {
      case 1: return (e.itemDisPrice ?? 0) > 0;
      case 2: return e.averageRating > 3;
      default: return true;
    }
  }).toList();

  void _handleList() {
    final mappedList = ListHelper.paginationList<Product>(
        data: _products, whereFn: (i, e) => i.id == e.id, limit: _limit);

    _products = mappedList['data'];
    _offset = mappedList['offset'];
  }

  Future<List<Product>> _getProducts() async {
    try {
      final accessToken = await getValidAccessToken();

      final result = await ProductRepository().getProducts(
          token: accessToken,
          limit: _limit,
          offset: _offset,
          search: _searchKey);

      if (result is CallbackSuccess) {
        if (result.data?.isNotEmpty == true) {
          return result.data!;
        } else {
          throw CallbackError("No more products available.", 404);
        }
      } else {
        throw result;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadProducts() async {
    try {
      _products.addAll(await _getProducts());
      _handleList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshProducts() async {
    try {
      _offset = 0;

      final newProds = await _getProducts();

      if (newProds.isNotEmpty) {
        _products = newProds;
        _handleList();
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadProduct(String? itemCode) async {
    try {
      final accessToken = await getValidAccessToken();

      if (itemCode == null) {
        throw "Item not found";
      }

      final prodResult = await ProductRepository()
          .getProduct(token: accessToken, itemCode: itemCode);

      if (prodResult is CallbackSuccess) {
        _product = prodResult.data ?? Product();
        notifyListeners();
      } else {
        throw prodResult.message;
      }
    } catch (e) {
      rethrow;
    }
  }
}

/*Future<void> loadProducts(BuildContext context) async {
    final toast = CustomToast.of(context);
    try {
      int befLength = _products.length;

      _products.addAll(await _getProducts());
      _handleList();

      // if(befLength == _products.length){
      //   throw CallbackError("No more products", 404);
      // }
      //
      // _hasMoreData = true;
      notifyListeners();
    } catch (e) {
      if(e is CallbackError && e.code == 404){
        return;
      }
      toast.showPrimary(e.toString());
    }
  }*/

/*Future<Product> loadProductOld (BuildContext context, String? itemCode) async {
    final toast = CustomToast.of(context);

    try {
      final accessToken = await validAccessToken();

      if(itemCode == null){
        throw "Item not found.";
      }

      final prodResult = await ProductRepository().getProductNew(
          token: accessToken,
          itemCode: itemCode
      );

      if(prodResult is CallbackSuccess){
        _product = prodResult.data ?? Product();
        return _product;
      } else {
        throw prodResult.message;
      }

    } catch (e) {
      toast.showPrimary(e.toString());
    }

    return Product();
  }*/
