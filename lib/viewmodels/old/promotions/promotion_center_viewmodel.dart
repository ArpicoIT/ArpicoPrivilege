// import 'package:flutter/material.dart';
//
// import '../../data/mixin/promotion_mixin.dart';
// import '../../data/models/promotion.dart';
//
// class PromotionCenterViewmodel extends ChangeNotifier with PromotionMixin {
//   int _tabIndex = 0;
//   void setTabIndex(int value){
//     _tabIndex = value;
//     notifyListeners();
//   }
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   PromotionCenterViewmodel(){
//     WidgetsBinding.instance.addPostFrameCallback((_){});
//   }
//
//   List<Promotion> get promosByStatus => promotions.where((e) {
//     switch(_tabIndex){
//       case 0: return true;
//       case 1: return e.proStatus == "ACT";
//       case 2: return e.proStatus == "UPC";
//       case 3: return e.proStatus == "EXP";
//       default: return e.proStatus == "ACT";
//     }
//   }).toList();
//
//
//
// }
//
// // class A extends ChangeNotifier {
// //   int _avValue = 0;
// //   set avValue(int val){
// //     _avValue = val;
// //     notifyListeners();
// //   }
// //   int calAverage(){
// //     // some calculation here
// //     return _avValue;
// //   }
// // }
// // class B extends ChangeNotifier {
// //   String _person = "new person";
// //   set person(String val){
// //     _person = val;
// //     notifyListeners();
// //   }
// //   String name() {
// //     // some calculation here
// //     return _person;
// //   }
// // }
// // class C extends ChangeNotifier {
// //   int age() {
// //     // some calculation here
// //     return 40;
// //   }
// // }
// //
// //
// // class D extends A {
// //
// //   void buildPerson() {
// //     avValue = 40;
// //     int avr = calAverage();
// //
// //     person = "Jhone";
// //     String per = name();
// //   }
// // }