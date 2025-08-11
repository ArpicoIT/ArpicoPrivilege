// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//
// import '../../data/mixin/product_mixin.dart';
// import '../../data/models/product.dart';
//
// class RatingsAndReviewsViewmodel extends ChangeNotifier with ProductMixin{
//   final refreshController = RefreshController();
//
//   final List<String> tabItems = ['All', '5', '4', '3', '2', '1'];
//
//   int _tabIndex = 0;
//   set tabIndex(int value){
//     _tabIndex = value;
//     notifyListeners();
//   }
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   RatingsAndReviewsViewmodel(){
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       product = ModalRoute.of(_context)?.settings.arguments as Product;
//       // await loadProduct(_context, product.itemCode);
//     });
//   }
//
//   List<Review> get filterByTabs {
//     final tabValue = tabItems[_tabIndex];
//     if (tabValue == 'All') {
//       return product.reviews;
//     }
//     else if(int.tryParse(tabValue) is int) {
//       return product.reviews
//           .where((e) => e.rating > int.parse(tabValue)-1 && e.rating <= int.parse(tabValue))
//           .toList();
//     } else {
//       return [];
//     }
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