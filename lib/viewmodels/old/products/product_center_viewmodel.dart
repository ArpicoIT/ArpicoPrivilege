// import 'package:arpicoprivilege/core/handlers/error_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//
// import '../../app/app.dart';
// import '../../app/app_routes.dart';
// import '../../data/mixin/product_mixin.dart';
// import '../../data/models/product.dart';
//
// class ProductCenterViewmodel extends ChangeNotifier with ProductMixin {
//   final ScrollController scrollController = ScrollController();
//   final RefreshController refreshController = RefreshController();
//
//   bool showInitialSearchAlert = false;
//
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
//   ProductCenterViewmodel(){
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final errorHandler = ErrorHandler.of(_context);
//
//       try {
//         // set search key
//         searchKey = ModalRoute.of(_context)?.settings.arguments as String?;
//         notifyListeners();
//
//         // load initial products
//         await loadProducts();
//
//         // load again products if searchKey not empty
//         if(_context.mounted && (searchKey??"").isNotEmpty && products.isEmpty){
//           searchKey = "";
//           await loadProducts();
//           showInitialSearchAlert = true;
//         }
//       } catch (e) {
//         final error = await errorHandler.show(e);
//       }
//
//     });
//   }
//
//   List<Product> get tabProducts => productsByTab(_tabIndex);
//
//   List<Product> get productsByTabWithoutDuplicates {
//     final Set<String?> seenIds = {}; // Allow nullable String IDs
//
//     return products.where((e) {
//       bool matchesFilter;
//       switch (_tabIndex) {
//         case 0:
//           matchesFilter = true;
//           break;
//         case 1:
//           matchesFilter = (e.itemDisPrice ?? 0) > 0;
//           break;
//         case 2:
//           matchesFilter = e.averageRating > 3;
//           break;
//         default:
//           matchesFilter = true;
//           break;
//       }
//
//       // Ensure product ID is unique (allow only one null)
//       if (matchesFilter && (e.id == null || seenIds.add(e.id))) {
//         return true;
//       }
//       return false;
//     }).toList();
//   }
//
//   void onCancelSearchAlert() {
//     showInitialSearchAlert = false;
//     notifyListeners();
//   }
//
//   void onRefresh() async{
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       await refreshProducts();
//       refreshController.refreshCompleted();
//     } catch (e) {
//       refreshController.refreshFailed();
//       errorHandler.show(e);
//     }
//
//   }
//
//   void onLoading() async{
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       await loadProducts();
//       refreshController.loadComplete();
//     } catch (e) {
//       refreshController.loadFailed();
//       errorHandler.show(e);
//     }
//   }
//
//   void onTapSearchField(BuildContext context) {
//     String? previousRoute = RouteObserverService.previousRoute;
//     if(previousRoute == AppRoutes.search){
//       Navigator.of(context).pop();
//     } else {
//       Navigator.of(context).pushNamed(AppRoutes.search);
//     }
//   }
//
//   void onClearSearchField() async {
//     final errorHandler = ErrorHandler.of(_context);
//
//     try {
//       searchKey = null;
//       notifyListeners();
//
//       await loadProducts();
//     } catch (e) {
//       errorHandler.show(e);
//     }
//
//   }
//
// }