import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/handlers/callback_handler.dart';
import '../../core/handlers/error_handler.dart';
import '../../core/utils/list_helper.dart';
import '../../data/models/paginated_data.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../../handler.dart';
import '../../shared/enum.dart';
import '../../shared/customize/custom_loader.dart';
import '../../shared/customize/custom_toast.dart';
import '../base_viewmodel.dart';

typedef ProductData = PaginatedData<Product>;

class ProductCollectionViewmodel extends BaseViewModel {
  ProductCollectionViewmodel() {
    _dataModelList = List.generate(ProductTypes.values.length,
        (i) => ProductData(sortType: ProductTypes.values[i].key, data: []));
  }

  setSearchKey(String value) {
    _dataModelList =
        _dataModelList.map((e) => e.copyWith(searchKey: value)).toList();
  }

  late List<ProductData> _dataModelList;

  ProductData getCurrentDataModel(int index) => _dataModelList[index];

  Future<ProductData> getProducts(ProductData model) async {
    final toast = CustomToast.of(context);
    final errorHandler = ErrorHandler.of(context);

    try {
      final accessToken = await getValidAccessToken();

      final result = await ProductRepository().getProducts(
          token: accessToken,
          limit: model.limit,
          offset: model.offset,
          sortType: model.sortType,
          sortOrder: model.sortOrder,
          search: model.searchKey);

      if (result is CallbackSuccess) {
        if (result.data?.isNotEmpty == true) {
          model.data += result.data!;

          final mappedList = ListHelper.paginationList<Product>(
              data: model.data,
              whereFn: (i, e) => i.id == e.id,
              limit: model.limit);

          model.data = mappedList['data'];
          model.offset = mappedList['offset'];

          return model;
        } else {
          throw CallbackError("No more products available", 404);
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
      return model;
    }
  }

  Future<void> loadInitialProducts(int index) async {
    // final currentModel = _dataModelList[index];
    setLoading(true);
    final currentModel = _dataModelList[index].copyWith(offset: 0, data: []);
    _dataModelList[index] = await getProducts(currentModel);
    setLoading(false);
  }

  Future<void> loadMoreProducts(int index) async {
    final currentModel = _dataModelList[index];
    _dataModelList[index] = await getProducts(currentModel);
    notifyListeners();
  }

  Future<void> refreshProducts(int index) async {
    final currentModel = _dataModelList[index].copyWith(offset: 0, data: []);

    _dataModelList[index] = await getProducts(currentModel);
    notifyListeners();
  }

  void onTapProduct(Product item) async => await Navigator.of(context)
      .pushNamed(AppRoutes.productDetails, arguments: item);
}

class ProductDetailViewModel extends BaseViewModel {

  Product? _product;
  Product? get product => _product;
  set product(Product? value) {
    _product = value;
    notifyListeners();
  }

  List<Review> filterProductReviewsByTab(String value) {
    final item = _product;
    if (item == null) return [];

    if (value == 'All') return item.reviews;

    final rating = int.tryParse(value);
    if (rating == null) return [];

    return item.reviews.where((e) => e.rating == rating).toList();
  }

  Future<Product?> getProduct(String? itemCode) async {
    final toast = CustomToast.of(context);
    final errorHandler = ErrorHandler.of(context);

    if (itemCode == null) {
      toast.showPrimary("Item not found");
      return null;
    }

    try {
      final accessToken = await getValidAccessToken();

      final result = await ProductRepository()
          .getProduct(token: accessToken, itemCode: itemCode);

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

  Future<void> loadProduct(String? itemCode) async {
    _product = await getProduct(itemCode) ?? _product;
    setLoading(false);
  }

  /*void confirmProductFeedback(BuildContext context) async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);
    final navigator = Navigator.of(context);

    try {
      unFocusBackground(context);

      await loader.show();

      final accessToken = await getValidAccessToken();
      final loginUser = await getValidLoginUser();

      final Map<String, dynamic> data = {
        "pluCode": product.pluCode,
        "itemCode": product.itemCode
      };

      final review = Review(
        userId: loginUser.loginCustId,
        userName: loginUser.loginCustFullName,
        profilePic: "",
        review: feedbackCtrl.text,
        comment: "",
        reply: "",
        reportAbuse: "",
        rating: rating,
        like: 0,
        datetime: DateTime.now().millisecondsSinceEpoch,
      );

      data.addAll(review.toJson());

      final resultReview = await RatingsAndReviewsRepository()
          .saveProductReview(
          images: feedbackImages, data: data, token: accessToken);

      toast.showPrimary(resultReview.message);
      await loader.close();

      if (resultReview is CallbackSuccess && context.mounted) {
        await PageAlert.replace(Key("feedbackSubmitted"), context,
            onConfirm: () => navigator.pop(review), result: review);
      }
    } catch (e) {
      await loader.close();
      toast.showPrimary(e.toString());
    }
  }*/
}
