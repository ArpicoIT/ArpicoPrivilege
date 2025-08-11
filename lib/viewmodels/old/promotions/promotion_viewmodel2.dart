// import 'dart:io';
//
// import 'package:arpicoprivilege/core/handlers/error_handler.dart';
// import 'package:arpicoprivilege/data/repositories/app_cache_repository.dart';
// import 'package:arpicoprivilege/shared/widgets/custom_alert.dart';
// import 'package:arpicoprivilege/shared/widgets/custom_loader.dart';
// import 'package:flutter/material.dart';
//
// import '../../handler.dart';
// import '../../core/handlers/callback_handler.dart';
// import '../../core/utils/list_helper.dart';
// import '../../data/models/promotion.dart';
// import '../../data/repositories/promotion_repository.dart';
// import '../../shared/widgets/custom_toast.dart';
//
// class PromotionViewmodel extends ChangeNotifier {
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   List<Promotion> _promotions = [];
//   List<Promotion> get promotions => _promotions;
//
//   Promotion _promotion = Promotion();
//   Promotion get promotion => _promotion;
//   set promotion (Promotion value){
//     _promotion = value;
//     notifyListeners();
//   }
//
//   List<Promotion> get activePromos => _promotions.where((e) => e.proStatus == "ACT").toList();
//
//   final int _limit = 20;
//   int _offset = 0;
//   set lastSuccessfulOffset(int value) {
//     _offset = value;
//   }
//
//   Future<List<Promotion>> getPromotions() async {
//     final toast = CustomToast.of(_context);
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       final accessToken = await accessTokenValidation();
//
//       final result = await PromotionRepository().getPromotions(
//         token: accessToken,
//         limit: _limit,
//         offset: _offset,
//         sortType: "ACT",
//         sortOrder: "desc"
//       );
//
//       if(result is CallbackSuccess){
//         if (result.data != null && result.data!.isNotEmpty) {
//           return result.data!;
//         } else {
//           throw CallbackError("No more promotions available.", 404);
//         }
//       } else {
//         throw result;
//       }
//     } catch (e) {
//       final error = await errorHandler.show(e);
//       (error is CallbackError && error.code == 404) ? null : toast.showPrimary(error.toString());
//     }
//     return [];
//   }
//
//
//   void _handleList(List<Promotion> list){
//     _promotions.addAll(list);
//
//     final mappedList = ListHelper.paginationList<Promotion>(
//         data: _promotions,
//         whereFn: (i, e) => i.id == e.id,
//         limit: _limit
//     );
//
//     _promotions = mappedList['data'];
//     _offset = mappedList['offset'];
//   }
//
//   Future<void> loadActivePromotions() async {
//     final data = await getPromotions();
//     _handleList(data);
//     setLoading(false);
//   }
//
//   Future<void> refreshActivePromotions() async {
//     // setLoading(true);
//     _offset = 0;
//
//     final data = await getPromotions();
//
//     if (data.isNotEmpty) {
//       _promotions.clear();
//       _handleList(data);
//     }
//     setLoading(false);
//   }
//
//   // Future<void> loadPromotions() async {
//   //   try {
//   //     _promotions.addAll(await _getPromotions());
//   //     _handleList();
//   //     notifyListeners();
//   //   } catch (e) {
//   //     rethrow;
//   //   }
//   // }
//   //
//   // Future<void> refreshPromotions() async {
//   //   try {
//   //     _offset = 0;
//   //
//   //     final newPromos = await _getPromotions();
//   //
//   //     if(newPromos.isNotEmpty){
//   //       _promotions = newPromos;
//   //       _handleList();
//   //     }
//   //     notifyListeners();
//   //   } catch (e) {
//   //     rethrow;
//   //   }
//   // }
//
//   Future<void> loadPromotion(String? proCode) async {
//     try {
//       final accessToken = await accessTokenValidation();
//
//       if (proCode == null) {
//         throw "Item not found";
//       }
//
//       final promoResult = await PromotionRepository().getPromotion(token: accessToken, proCode: proCode);
//
//       if (promoResult is CallbackSuccess) {
//         _promotion = promoResult.data ?? Promotion();
//         notifyListeners();
//       } else {
//         throw promoResult.message;
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }