import 'package:arpicoprivilege/viewmodels/ebill/eBill_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../core/handlers/callback_handler.dart';
import '../../core/utils/list_helper.dart';
import '../../handler.dart';
import '../../shared/customize/custom_toast.dart';
import '../models/eBill.dart';
import '../repositories/ebill_repository.dart';



/*
mixin EBillMixin2 on ChangeNotifier {
  List<EBill> _eBills = [];
  List<EBill> get eBills => _eBills;

  final int _limit = 10;
  int _offset = 0;

  Map<String, dynamic> _filters = {};
  Map<String, dynamic> get filters => _filters;
  set filters(Map<String, dynamic> value) {
    _filters = value;
  }


  Future<List<EBill>> _getEBills (BuildContext context) async {
    final toast = CustomToast.of(context);

    try {
      final accessToken = await getValidAccessToken();
      final loginUser = await getValidLoginUser();

      final resultEBills = await EBillRepository().getEBills(
        custId: loginUser.loginCustId,
        custMobile: loginUser.loginCustMobNo,
        ebillNo: filters["ebillNo"],
        receiptNo: filters["receiptNo"],
        curDate: filters["curDate"],
        token: accessToken,
        limit: _limit,
        offset: _offset,
      );

      if (resultEBills is CallbackSuccess) {
        if (resultEBills.data != null && resultEBills.data!.isNotEmpty) {
          return resultEBills.data!;
        } else {
          throw "No more E-Bills available.";
        }
      } else {
        throw resultEBills.message;
      }
    } catch (e) {
      toast.showPrimary(e.toString());
    }
    return [];
  }

  void _handleList(){
    final mappedList = ListHelper.paginationList<EBill>(
        data: _eBills,
        whereFn: (i, e) => i.eBillUrl == e.eBillUrl,
        limit: _limit
    );

    _eBills = mappedList['data'];
    _offset = mappedList['offset'];
  }

  Future<void> loadEBills (BuildContext context) async {
    final toast = CustomToast.of(context);

    try {
      _eBills.addAll(await _getEBills(context));
      _handleList();
      notifyListeners();
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

  Future<void> refreshEBills (BuildContext context) async {
    final toast = CustomToast.of(context);

    try {
      _offset = 0;
      _filters = {};

      final newBills = await _getEBills(context);

      if(newBills.isNotEmpty){
        _eBills = newBills;
        _handleList();
      }
      notifyListeners();
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

}

mixin EBillMixin on ChangeNotifier {
  List<EBill> _eBills = [];
  List<EBill> get eBills => _eBills;

  final int _limit = 10;
  int _offset = 0;

  Map<String, dynamic> _filters = {};
  Map<String, dynamic> get filters => _filters;
  set filters(Map<String, dynamic> value) {
    _filters = value;
  }


  Future<List<EBill>> _getEBills (BuildContext context) async {
    final toast = CustomToast.of(context);

    try {
      final accessToken = await getValidAccessToken();
      final user = await getUserFromStorage();

      final resultEBills = await EBillRepository().getEBills(
        custId: user.custId,
        custMobile: user.custMobNo1,
        ebillNo: filters["ebillNo"],
        receiptNo: filters["receiptNo"],
        curDate: filters["curDate"],
        token: accessToken,
        limit: _limit,
        offset: _offset,
      );

      if (resultEBills is CallbackSuccess) {
        if (resultEBills.data != null && resultEBills.data!.isNotEmpty) {
          return resultEBills.data!;
        } else {
          throw "No more E-Bills available.";
        }
      } else {
        throw resultEBills.message;
      }
    } catch (e) {
      toast.showPrimary(e.toString());
    }
    return [];
  }

  void _handleList(){
    final mappedList = ListHelper.paginationList<EBill>(
        data: _eBills,
        whereFn: (i, e) => i.eBillUrl == e.eBillUrl,
        limit: _limit
    );

    _eBills = mappedList['data'];
    _offset = mappedList['offset'];
  }

  Future<void> loadEBills (BuildContext context) async {
    final toast = CustomToast.of(context);

    try {
      _eBills.addAll(await _getEBills(context));
      _handleList();
      notifyListeners();
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

  Future<void> refreshEBills (BuildContext context) async {
    final toast = CustomToast.of(context);

    try {
      _offset = 0;
      _filters = {};

      final newBills = await _getEBills(context);

      if(newBills.isNotEmpty){
        _eBills = newBills;
        _handleList();
      }
      notifyListeners();
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

}*/
