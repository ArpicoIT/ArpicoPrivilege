import 'package:flutter/material.dart';

import '../../core/handlers/callback_handler.dart';
import '../../core/utils/list_group_helper.dart';
import '../../data/mixin/ebill_mixin.dart';
import '../../data/models/eBill.dart';
import '../../data/repositories/ebill_repository.dart';
import '../../handler.dart';
import '../../shared/customize/custom_toast.dart';

// class EBillHistoryViewmodel  extends ChangeNotifier with EBillMixin {
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   EBillHistoryViewmodel(){
//     WidgetsBinding.instance.addPostFrameCallback((_){});
//   }
//
//   List<MapEntry<String, List<EBill>>> get groupedBills => ListGroupHelper<EBill>(
//     items: eBills,
//     dateExtractor: (EBill bill) => bill.datetime,
//   ).groupByDate();
//
// }

// Future<void> loadEBills(BuildContext context) async {
//   final toast = CustomToast.of(context);
//
//   try {
//     const int limit = 20;
//     final int offset = lastSuccessfulOffset;
//
//     final accessToken = await validAccessToken();
//     final user = await getUserFromStorage();
//
//     final resultEBills = await EBillRepository().getEBills(
//       custId: user.custId,
//       custMobile: user.custMobNo1,
//       ebillNo: filterParams["ebillNo"],
//       receiptNo: filterParams["receiptNo"],
//       curDate: filterParams["curDate"],
//       token: accessToken,
//       limit: limit,
//       offset: offset,
//     );
//
//     if (resultEBills is CallbackSuccess) {
//       if (resultEBills.data != null && resultEBills.data!.isNotEmpty) {
//
//         _eBills.addAll(resultEBills.data!);
//         lastSuccessfulOffset ++; // Increase offset only for new records
//         notifyListeners();
//
//       } else {
//         throw "No more E-Bills available.";
//       }
//     } else {
//       throw resultEBills.message;
//     }
//   } catch (e) {
//     toast.showPrimary(e.toString());
//   }
// }
//
// Future<void> refreshEBills (BuildContext context) async {
//   final toast = CustomToast.of(context);
//
//   try {
//     _resetParams();
//     filterParams = {};
//     await loadEBills(context);
//   } catch (e) {
//     toast.showPrimary(e.toString());
//   }
// }

/*Future<void> loadEBillsWithFilters (BuildContext context, Map<String, dynamic> filters) async {
    final toast = CustomToast.of(context);

    try {
      _resetParams();
      filterParams = filters;
      await loadEBills(context);
      notifyListeners();
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }*/

/*int getYourEarnings(BuildContext context, DateFilterRange filterRange){
    try {
      final list = Filters.byDate<EBill>(
        items: _eBills,
        filterFn: (e) => e.datetime!,
        range: filterRange
      );
      int value = 0;
      for (var e in list) {
        // value += e.loyalty?.billEarnPoints??0 ;
        value += 0 ;
      }
      return value;
    } catch (e){
      debugPrint(e.toString());
    }
    return 0;
  }*/