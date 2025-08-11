import 'package:flutter/material.dart';

import '../../core/handlers/callback_handler.dart';
import '../../core/handlers/error_handler.dart';
import '../../core/utils/list_group_helper.dart';
import '../../data/models/eBill.dart';
import '../../data/models/paginated_data.dart';
import '../../data/repositories/ebill_repository.dart';
import '../../handler.dart';
import '../../shared/customize/custom_toast.dart';
import '../base_viewmodel.dart';

typedef EBillData = PaginatedData<EBill>;

class EBillViewmodel extends BaseViewModel {
  EBillData _dataModel = EBillData(data: [], filters: {});
  EBill? lastEBill;

  Map<String, dynamic> get filters => _dataModel.filters;
  setFilters(Map<String, dynamic> value) {
    _dataModel = _dataModel.copyWith(filters: value);
    notifyListeners();
  }

  List<MapEntry<String, List<EBill>>> get groupedBills =>
      ListGroupHelper<EBill>(
        items: _dataModel.data,
        dateExtractor: (EBill bill) => bill.datetime,
      ).groupByDate();

  Future<List<EBill>> getEBills(EBillData model) async {
    final toast = CustomToast.of(context);
    final errorHandler = ErrorHandler.of(context);

    try {
      final accessToken = await getValidAccessToken();
      final loginUser = await decodeValidLoginUser();

      final result = await EBillRepository().getEBills(
        custId: loginUser.loginCustId,
        custMobile: loginUser.loginCustMobNo,
        ebillNo: model.filters["ebillNo"],
        receiptNo: model.filters["receiptNo"],
        curDate: model.filters["curDate"],
        token: accessToken,
        limit: model.limit,
        offset: model.offset,
      );

      if (result is CallbackSuccess) {
        if (result.data?.isNotEmpty == true) {
          return result.data!;
        } else {
          throw CallbackError("No more E-Bills available", 404);
        }
      } else {
        throw result;
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      if (error == null || error is CallbackError && error.code == 404) {
        debugPrint(error.toString());
      } else {
        toast.showPrimary(error.toString());
      }
      return model.data;
    }
  }

  Future<void> loadLastEBill({bool hasLoading = false}) async {
    final currentModel = EBillData(data: [], offset: 0, limit: 1);
    final data = await getEBills(currentModel);
    lastEBill = data.isNotEmpty ? data.first : null;

    hasLoading ? setLoading(false) : notifyListeners();
  }

  Future<void> loadEBills({bool hasLoading = false}) async {
    final toast = CustomToast.of(context);

    try {
      final data = await getEBills(_dataModel);
      _dataModel =
          _dataModel.paginationList(newData: data, whereFn: EBill.isDuplicate);

      hasLoading ? setLoading(false) : notifyListeners();
    } catch (e) {
      if (e is CallbackError && e.code == 404) {
        debugPrint(e.toString());
      } else {
        toast.showPrimary(e.toString());
      }
    }
  }

  Future<void> refreshEBills() async {
    final toast = CustomToast.of(context);

    try {
      _dataModel = _dataModel.copyWith(
        offset: 0,
        filters: {},
        data: [],
      );
      final data = await getEBills(_dataModel);

      _dataModel =
          _dataModel.paginationList(newData: data, whereFn: EBill.isDuplicate);

      notifyListeners();
    } catch (e) {
      if (e is CallbackError && e.code == 404) {
        debugPrint(e.toString());
      } else {
        toast.showPrimary(e.toString());
      }
    }
  }

  Future<void> filterEBills(Map<String, dynamic> filters) async {
    final toast = CustomToast.of(context);

    _dataModel = _dataModel.copyWith(
      offset: 0,
      filters: filters,
      data: [],
    );

    try {
      final data = await getEBills(_dataModel);
      _dataModel =
          _dataModel.paginationList(newData: data, whereFn: EBill.isDuplicate);
    } catch (e) {
      final message = (e is CallbackError && e.code == 404)
          ? "Filtered E-Bills not available"
          : e.toString();

      toast.showPrimary(message);
    }
    notifyListeners();
  }
}

