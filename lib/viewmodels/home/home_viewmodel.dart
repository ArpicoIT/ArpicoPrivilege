import 'package:arpicoprivilege/data/models/promotion.dart';
import 'package:arpicoprivilege/data/repositories/app_cache_repository.dart';
import 'package:arpicoprivilege/shared/customize/custom_toast.dart';
import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/handlers/error_handler.dart';
import '../../data/mixin/product_mixin.dart';
import '../../data/mixin/promotion_mixin.dart';
import '../../data/models/product.dart';

/// v 1.1
// class HomeViewmodel extends ChangeNotifier with PromotionMixin, ProductMixin {
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   /// promotions
//   void initializeCachedPromotions() {
//     promotions = AppCacheRepository.loadPromotionsCache();
//   }
//
//   Future<void> loadAndCachePromotions() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // get latest promotions
//       await loadPromotions();
//
//       // save latest promotions to cache
//       if (promotions.isNotEmpty) {
//         await AppCacheRepository.savePromotionsCache(promotions);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   Future<void> refreshAndCachePromotions() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // refresh latest promotions
//       await refreshPromotions();
//
//       // save latest promotions to cache
//       if (promotions.isNotEmpty) {
//         await AppCacheRepository.savePromotionsCache(promotions);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   /// products
//   void initializeCachedProducts() {
//     products = AppCacheRepository.loadProductsCache();
//   }
//
//   Future<void> loadAndCacheProducts() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // get latest products
//       await loadProducts();
//
//       // save latest products to cache
//       if (products.isNotEmpty) {
//         await AppCacheRepository.saveProductsCache(products);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   Future<void> refreshAndCacheProducts() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // refresh latest products
//       await refreshProducts();
//
//       // save latest products to cache
//       if (products.isNotEmpty) {
//         await AppCacheRepository.saveProductsCache(products);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   void onTapProduct(Product item) async => await Navigator.of(_context)
//       .pushNamed(AppRoutes.productDetails, arguments: item);
//
//   void onTapPromotion(Promotion item) async => await Navigator.of(_context)
//       .pushNamed(AppRoutes.promotionDetails, arguments: item);
// }

/// v 1.0
// class HomeViewmodel extends ChangeNotifier with PromotionMixin, ProductMixin {
//   // final ValueNotifier<String> curPromoImageNotifier = ValueNotifier<String>('');
//   // final ValueNotifier<Color?> promoColorNotifier = ValueNotifier<Color?>(null);
//   // List<Map<String, dynamic>> promoColors = [];
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   /// promotions
//   void initializeCachedPromotions() {
//     promotions = AppCacheRepository.loadPromotionsCache();
//   }
//
//   Future<void> loadAndCachePromotions() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // get latest promotions
//       await loadPromotions();
//
//       // save latest promotions to cache
//       if (promotions.isNotEmpty) {
//         await AppCacheRepository.savePromotionsCache(promotions);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   Future<void> refreshAndCachePromotions() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // refresh latest promotions
//       await refreshPromotions();
//
//       // save latest promotions to cache
//       if (promotions.isNotEmpty) {
//         await AppCacheRepository.savePromotionsCache(promotions);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   /// products
//   void initializeCachedProducts() {
//     products = AppCacheRepository.loadProductsCache();
//   }
//
//   Future<void> loadAndCacheProducts() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // get latest products
//       await loadProducts();
//
//       // save latest products to cache
//       if (products.isNotEmpty) {
//         await AppCacheRepository.saveProductsCache(products);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   Future<void> refreshAndCacheProducts() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       // refresh latest products
//       await refreshProducts();
//
//       // save latest products to cache
//       if (products.isNotEmpty) {
//         await AppCacheRepository.saveProductsCache(products);
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       if(error is CallbackError && error.code == 404){
//         return;
//       } else {
//         toast.showPrimary(error.toString());
//       }
//     }
//   }
//
//   void onTapProduct(Product item) async => await Navigator.of(_context)
//       .pushNamed(AppRoutes.productDetails, arguments: item);
//
//   void onTapPromotion(Promotion item) async => await Navigator.of(_context)
//       .pushNamed(AppRoutes.promotionDetails, arguments: item);
//
//   // Future<void> _setPromoColors() async {
//   //   try {
//   //     final List promoImages = promotions
//   //         .map((e) => e.imageUrl)
//   //         .where((e) => e.isNotEmpty)
//   //         .toSet()
//   //         .toList();
//   //
//   //
//   //     // Use Future.wait to handle async operations inside map()
//   //     promoColors = await Future.wait(promoImages.map((e) async =>
//   //     {"image": e, "color": await ImageHandler.getBackgroundColor(e)}));
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //   }
//   // }
//   //
//   // Color _getPromoColor(BuildContext context, String image) {
//   //   Color surface = Theme.of(context).colorScheme.surface;
//   //
//   //   try {
//   //     if (promoColors.isEmpty) {
//   //       return surface;
//   //     }
//   //
//   //     return promoColors.firstWhere(
//   //           (element) => element["image"] == image,
//   //       orElse: () => {"color": surface}, // If not found, return null color
//   //     )["color"];
//   //   } catch (e) {
//   //     debugPrint("Error finding color: $e");
//   //     return surface;
//   //   }
//   // }
// }
