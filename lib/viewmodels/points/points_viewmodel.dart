import 'package:flutter/material.dart';

import '../../core/handlers/callback_handler.dart';
import '../../core/handlers/error_handler.dart';
import '../../data/models/points.dart';
import '../../data/repositories/points_repository.dart';
import '../../handler.dart';
import '../../shared/customize/custom_toast.dart';

class PointsViewmodel extends ChangeNotifier {
  late BuildContext _context;
  void setContext(BuildContext context) {
    _context = context;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  Points? loyaltyPoints;


  Future<void> getPointsBalance() async {
    final toast = CustomToast.of(_context);
    final errorHandler = ErrorHandler.of(_context);

    try {
      final accessToken = await getValidAccessToken();
      final loginUser = await decodeValidLoginUser();

      final resultPoints = await PointsRepository().getUserPointsBalance(token: accessToken, custId: loginUser.loginCustId!);

      if (resultPoints is CallbackSuccess) {
        loyaltyPoints = resultPoints.data!;
        notifyListeners();
      }
      else {
        throw resultPoints.message;
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    } finally {
      _isLoading ? setLoading(false) : null;
    }
  }
}
