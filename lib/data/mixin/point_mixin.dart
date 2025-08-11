// import 'package:arpicoprivilege/handler.dart';
// import 'package:flutter/material.dart';
//
// import '../../core/handlers/callback_handler.dart';
// import '../../data/models/points.dart';
// import '../../data/repositories/points_repository.dart';
// import '../../shared/widgets/custom_alert.dart';
// import '../../shared/widgets/custom_loader.dart';
// import '../../shared/widgets/custom_toast.dart';
//
// mixin PointMixin on ChangeNotifier {
//   Points points = Points();
//
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   setLoading(bool value){
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> getPointsBalance() async {
//     try {
//       final accessToken = await accessTokenValidation();
//       final loginUser = await validLoginUser();
//
//       final resultPoints = await PointsRepository().getUserPointsBalance(token: accessToken, custId: loginUser.loginCustId!);
//
//       if (resultPoints is CallbackSuccess) {
//         points = resultPoints.data!;
//         notifyListeners();
//       }
//       else {
//         throw resultPoints.message;
//       }
//     } catch (e) {
//       toast.showPrimary(e.toString());
//     } finally {
//       // setLoading(false);
//     }
//   }
// }
