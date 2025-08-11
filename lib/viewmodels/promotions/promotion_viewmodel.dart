import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/handlers/error_handler.dart';
import '../../data/models/paginated_data.dart';
import '../../handler.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/utils/list_helper.dart';
import '../../data/models/promotion.dart';
import '../../data/repositories/promotion_repository.dart';
import '../../shared/enum.dart';
import '../../shared/customize/custom_toast.dart';

typedef PromotionData = PaginatedData<Promotion>;

class PromotionCollectionViewmodel extends ChangeNotifier {
  late BuildContext _context;
  void setContext(BuildContext context) {
    _context = context;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  PromotionCollectionViewmodel(){
    _dataModelList = List.generate(
        PromotionTypes.values.length, (i) =>
        PromotionData(
            sortType: PromotionTypes.values[i].key,
            data: []
        ));
  }

  late List<PromotionData> _dataModelList;


  PromotionData getCurrentDataModel(int index) => _dataModelList[index];

  Future<PromotionData> _getPromotions(PromotionData model) async {
    final toast = CustomToast.of(_context);
    final errorHandler = ErrorHandler.of(_context);

    try {
      final accessToken = await getValidAccessToken();

      final result = await PromotionRepository().getPromotions(
          token: accessToken,
          limit: model.limit,
          offset: model.offset,
          sortType: model.sortType,
          sortOrder: model.sortOrder
      );

      if (result is CallbackSuccess) {
        if (result.data?.isNotEmpty == true) {
          model.data += result.data!;

          final mappedList = ListHelper.paginationList<Promotion>(
              data: model.data,
              whereFn: (i, e) => i.id == e.id, limit: model.limit);

          model.data = mappedList['data'];
          model.offset = mappedList['offset'];

          return model;
        } else {
          throw CallbackError("No more promotions available", 404);
        }
      } else {
        throw result;
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      if(error == null || error is CallbackError && error.code == 404){
        debugPrint(error.toString());
      } else {
        toast.showPrimary(error.toString());
      }
      return model;
    }
  }

  Future<void> loadInitialPromotions(int index) async {
    setLoading(true);
    final currentModel = _dataModelList[index];
    _dataModelList[index] = await _getPromotions(currentModel);
    setLoading(false);
  }

  Future<void> loadMorePromotions(int index) async {
    final currentModel = _dataModelList[index];
    _dataModelList[index] = await _getPromotions(currentModel);
    notifyListeners();
  }

  Future<void> refreshPromotions(int index) async {
    final currentModel = _dataModelList[index].copyWith(
        offset: 0,
        data: []
    );

    _dataModelList[index] = await _getPromotions(currentModel);
    notifyListeners();
  }

  void onTapPromotion(Promotion item) async =>
      await Navigator.of(_context)
          .pushNamed(AppRoutes.promotionDetails, arguments: item);
}

class PromotionDetailViewModel extends ChangeNotifier {
  late BuildContext _context;
  void setContext(BuildContext context) {
    _context = context;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Promotion? _promotion;
  Promotion? get promotion => _promotion;
  set promotion(Promotion? value){
    _promotion = value;
    notifyListeners();
  }

  Future<Promotion?> getPromotion(String? proCode) async {
    final toast = CustomToast.of(_context);
    final errorHandler = ErrorHandler.of(_context);

    try {
      final accessToken = await getValidAccessToken();

      if (proCode == null) {
        throw "Item not found";
      }

      final result = await PromotionRepository().getPromotion(token: accessToken, proCode: proCode);

      if (result is CallbackSuccess) {
        return result.data;
      } else {
        throw result.message;
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
      return null;
    }
  }

  Future<void> loadPromotion(String? proCode) async {
    _promotion = await getPromotion(proCode) ?? _promotion;
    setLoading(false);
  }

}

// Future<void> loadPromotion(String? proCode) async {
//   try {
//     final accessToken = await accessTokenValidation();
//
//     if (proCode == null) {
//       throw "Item not found";
//     }
//
//     final promoResult = await PromotionRepository().getPromotion(token: accessToken, proCode: proCode);
//
//     if (promoResult is CallbackSuccess) {
//       _promotion = promoResult.data ?? Promotion();
//       notifyListeners();
//     } else {
//       throw promoResult.message;
//     }
//   } catch (e) {
//     rethrow;
//   }
// }

//
  // List<Promotion> _promotions = [];
  // List<Promotion> get promotions => _promotions;
  //
  // Promotion _promotion = Promotion();
  // Promotion get promotion => _promotion;
  // set promotion (Promotion value){
  //   _promotion = value;
  //   notifyListeners();
  // }
  //
  // List<Promotion> get activePromos => _promotions.where((e) => e.proStatus == "ACT").toList();
  //
  // final int _limit = 20;
  // int _offset = 0;
  // set lastSuccessfulOffset(int value) {
  //   _offset = value;
  // }
  //
  // Future<List<Promotion>> getPromotions() async {
  //   final toast = CustomToast.of(_context);
  //   final errorHandler = ErrorHandler.of(_context);
  //
  //   try {
  //     final accessToken = await accessTokenValidation();
  //
  //     final result = await PromotionRepository().getPromotions(
  //         token: accessToken,
  //         limit: _limit,
  //         offset: _offset,
  //         sortType: "ACT",
  //         sortOrder: "desc"
  //     );
  //
  //     if(result is CallbackSuccess){
  //       if (result.data != null && result.data!.isNotEmpty) {
  //         return result.data!;
  //       } else {
  //         throw CallbackError("No more promotions available.", 404);
  //       }
  //     } else {
  //       throw result;
  //     }
  //   } catch (e) {
  //     final error = await errorHandler.show(e);
  //     (error is CallbackError && error.code == 404) ? null : toast.showPrimary(error.toString());
  //   }
  //   return [];
  // }
  //
  //
  // void _handleList(List<Promotion> list){
  //   _promotions.addAll(list);
  //
  //   final mappedList = ListHelper.paginationList<Promotion>(
  //       data: _promotions,
  //       whereFn: (i, e) => i.id == e.id,
  //       limit: _limit
  //   );
  //
  //   _promotions = mappedList['data'];
  //   _offset = mappedList['offset'];
  // }
  //
  // Future<void> loadActivePromotions() async {
  //   final data = await getPromotions();
  //   _handleList(data);
  //   setLoading(false);
  // }
  //
  // Future<void> refreshActivePromotions() async {
  //   // setLoading(true);
  //   _offset = 0;
  //
  //   final data = await getPromotions();
  //
  //   if (data.isNotEmpty) {
  //     _promotions.clear();
  //     _handleList(data);
  //   }
  //   setLoading(false);
  // }
  //
  // // Future<void> loadPromotions() async {
  // //   try {
  // //     _promotions.addAll(await _getPromotions());
  // //     _handleList();
  // //     notifyListeners();
  // //   } catch (e) {
  // //     rethrow;
  // //   }
  // // }
  // //
  // // Future<void> refreshPromotions() async {
  // //   try {
  // //     _offset = 0;
  // //
  // //     final newPromos = await _getPromotions();
  // //
  // //     if(newPromos.isNotEmpty){
  // //       _promotions = newPromos;
  // //       _handleList();
  // //     }
  // //     notifyListeners();
  // //   } catch (e) {
  // //     rethrow;
  // //   }
  // // }
  //

