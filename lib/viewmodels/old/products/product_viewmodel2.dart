import 'package:arpicoprivilege/views/products/product_center.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../app/app_routes.dart';
import '../../../core/handlers/callback_handler.dart';
import '../../../core/utils/list_helper.dart';
import '../../../data/mixin/product_mixin.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../handler.dart';


// class ProductDescriptionViewmodel extends ChangeNotifier with ProductMixin {
//   final refreshController = RefreshController();
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   ProductDescriptionViewmodel() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       product = ModalRoute.of(_context)?.settings.arguments as Product;
//       await loadProduct(product.itemCode);
//     });
//   }
//
//   void onRefresh(BuildContext context) async {
//     /// refresh product
//     await loadProduct(product.itemCode);
//
//     /// if failed,use refreshFailed()
//     refreshController.refreshCompleted();
//   }
//
// }







// class ProductViewmodel extends ChangeNotifier {
//   List<Product> products = [];
//
//   int lastSuccessfulOffset = 0;
//   Future<void> loadProducts (BuildContext context) async {
//     final toast = CustomToast.of(context);
//
//     try {
//       final int limit = 20;
//       final int offset = lastSuccessfulOffset;
//
//       final accessToken = await getAccessTokenFromStorage();
//
//       final resultProds = await ProductRepository().getProductsNew(
//         token: accessToken,
//         limit: limit,
//         offset: offset,
//       );
//
//       if(resultProds is CallbackSuccess){
//         if (resultProds.data != null && resultProds.data!.isNotEmpty) {
//           products += resultProds.data!;
//           lastSuccessfulOffset ++;
//           notifyListeners();
//         } else {
//           throw "No more products available.";
//         }
//       } else {
//         throw resultProds.message;
//       }
//
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<void> refreshProducts (BuildContext context) async {
//     final toast = CustomToast.of(context);
//
//     try {
//       lastSuccessfulOffset = 0;
//       products.clear();
//       await loadProducts(context);
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   Future<Product> loadProduct (BuildContext context, String? itemCode) async {
//     final toast = CustomToast.of(context);
//
//     try {
//       final accessToken = await getAccessTokenFromStorage();
//
//       if(itemCode == null){
//         throw "Item not found.";
//       }
//
//       final resultProd = await ProductRepository().getProductNew(
//           token: accessToken,
//           itemCode: itemCode
//       );
//
//       if(resultProd is CallbackSuccess){
//         return resultProd.data ?? Product();
//       } else {
//         throw resultProd.message;
//       }
//
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     }
//
//     return Product();
//   }
//
// }