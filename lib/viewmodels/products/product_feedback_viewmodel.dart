// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../handler.dart';
//
// import '../../../core/handlers/callback_handler.dart';
// import '../../../data/mixin/product_mixin.dart';
// import '../../../data/models/product.dart';
// import '../../../data/repositories/ratings_and_review_repository.dart';
// import '../../shared/customize/custom_loader.dart';
// import '../../shared/customize/custom_toast.dart';
// import '../../shared/pages/page_alert.dart';
//
// class ProductFeedbackViewmodel extends ChangeNotifier with ProductMixin {
//   final TextEditingController feedbackCtrl = TextEditingController();
//   final FocusNode feedbackFocus = FocusNode();
//   List<XFile> feedbackImages = [];
//   int rating = 0;
//
//   bool _enableConfirmButton = false;
//   bool get enableConfirmButton => _enableConfirmButton;
//
//   late BuildContext _context;
//   void setContext(BuildContext context) {
//     _context = context;
//   }
//
//   ProductFeedbackViewmodel() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       product = ModalRoute.of(_context)?.settings.arguments as Product;
//     });
//   }
//
//   void onChangedRating(int value) {
//     rating = value;
//     _enableConfirmButton = value > 0;
//     notifyListeners();
//   }
//
//   void onChangedFeedbackImages(List<XFile> images) {
//     feedbackImages = images;
//     notifyListeners();
//   }
//
//   void confirmProductFeedback(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//     final navigator = Navigator.of(context);
//
//     try {
//       unFocusBackground(context);
//
//       await loader.show();
//
//       final accessToken = await getValidAccessToken();
//       final loginUser = await decodeValidLoginUser();
//
//       final Map<String, dynamic> data = {
//         "pluCode": product.pluCode,
//         "itemCode": product.itemCode
//       };
//
//       final review = Review(
//         userId: loginUser.loginCustId,
//         userName: loginUser.loginCustFullName,
//         profilePic: "",
//         review: feedbackCtrl.text,
//         comment: "",
//         reply: "",
//         reportAbuse: "",
//         rating: rating,
//         like: 0,
//         datetime: DateTime.now().millisecondsSinceEpoch,
//       );
//
//       data.addAll(review.toJson());
//
//       final resultReview = await RatingsAndReviewsRepository()
//           .saveProductReview(
//               images: feedbackImages, data: data, token: accessToken);
//
//       toast.showPrimary(resultReview.message);
//       await loader.close();
//
//       if (resultReview is CallbackSuccess && context.mounted) {
//         await PageAlert.replace(Key("feedbackSubmitted"), context,
//             onConfirm: () => navigator.pop(review), result: review);
//       }
//     } catch (e) {
//       await loader.close();
//       toast.showPrimary(e.toString());
//     }
//   }
//
//   void unFocusBackground(BuildContext context) {
//     feedbackFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }
// }
