import 'dart:io';
import 'package:arpicoprivilege/core/handlers/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:localized_alerts/localized_alerts.dart' as appAlerts;

import '../../core/handlers/callback_handler.dart';
import '../../data/models/product.dart';
import '../../data/repositories/ratings_and_review_repository.dart';
import '../../handler.dart';
import '../../l10n/app_translator.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/indicators/rating_collector.dart';
import '../../shared/components/buttons/primary_button.dart';
import '../../shared/components/image_source_selector.dart';
import '../../shared/components/image_with_placeholder.dart';
import '../../shared/customize/custom_loader.dart';
import '../../shared/customize/custom_toast.dart';
import '../../viewmodels/products/product_feedback_viewmodel.dart';
import '../../viewmodels/products/product_viewmodel.dart';

/// current
class CreateProductReview extends StatefulWidget {
  final bool wrapAppBarIcons;
  const CreateProductReview({super.key, required this.wrapAppBarIcons});

  @override
  State<CreateProductReview> createState() => _CreateProductReviewState();
}

class _CreateProductReviewState extends State<CreateProductReview> {
  late ProductDetailViewModel prodDetViewmodel;

  final int kImagePickerLimit = 5;

  // final TextEditingController feedbackCtrl = TextEditingController();
  // final FocusNode feedbackFocus = FocusNode();

  final Map<String, dynamic> feedbackFieldData = {
    "controller": TextEditingController(),
    "focusNode": FocusNode()
  };

  List<XFile> feedbackImages = [];
  int rating = 0;
  bool _enableConfirmButton = false;
  bool get enableConfirmButton => _enableConfirmButton;

  @override
  void initState() {
    prodDetViewmodel = ProductDetailViewModel()..setContext(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final product = ModalRoute.of(context)?.settings.arguments as Product?;
      prodDetViewmodel.product = product;
      // prodDetViewmodel.loadProduct(product?.itemCode);
    });
    super.initState();
  }

  void onChangedRating(int value) {
    setState(() {
      rating = value;
      _enableConfirmButton = value > 0;
    });
  }

  void onChangedFeedbackImages(List<XFile> images) {
    setState(() {
      feedbackImages = images;
    });
  }

  void unFocusBackground(BuildContext context) {
    (feedbackFieldData['focusNode'] as FocusNode).unfocus();
    FocusScope.of(context).unfocus();
  }

  void onSubmit() async {
    final loader = CustomLoader.of(context);
    final toast = CustomToast.of(context);
    final errorHandler = ErrorHandler.of(context);

    unFocusBackground(context);

    try {
      await loader.show();

      final accessToken = await getValidAccessToken();
      final loginUser = await decodeValidLoginUser();

      final product = prodDetViewmodel.product;

      if (product == null) {
        toast.showPrimary("Product not found");
      }

      final Map<String, dynamic> data = {
        "pluCode": product?.pluCode,
        "itemCode": product?.itemCode
      };

      final review = Review(
        userId: loginUser.loginCustId,
        userName: loginUser.loginCustFullName,
        profilePic: "",
        review: (feedbackFieldData['controller'] as TextEditingController).text,
        comment: "",
        reply: "",
        reportAbuse: "",
        rating: rating,
        like: 0,
        datetime: DateTime.now().millisecondsSinceEpoch,
      );

      data.addAll(review.toJson());

      final result = await RatingsAndReviewsRepository().saveProductReview(
          images: feedbackImages, data: data, token: accessToken);

      await loader.close();

      if (result is CallbackSuccess && mounted) {
        if (mounted) {
          await appAlerts.showAlertById(context, 'feedbackSubmitted',
              (key) => AppTranslator.of(context).call(key));
          if (mounted) {
            Navigator.of(context).pop(review);
          }
        }
      } else {
        toast.showPrimary(result.message);
      }
    } catch (e) {
      await loader.close();
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }
  }

  Widget buildTitle(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => prodDetViewmodel,
      child: Consumer<ProductDetailViewModel>(
          builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: colorScheme.surface.withAlpha(0),
            title: Text("Add Review"),
            centerTitle: true,
            actions: [
              ActionIconButton.of(context).menu(
                  items: ['home', 'settings', 'notifications'],
                  withBackground: widget.wrapAppBarIcons),
            ],
          ),
          body: GestureDetector(
            onTap: () => unFocusBackground(context),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox.square(
                                  dimension: constraints.maxHeight,
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                            color: Colors.grey[200]!)),
                                    child: ImageWithPlaceholder(
                                      viewmodel.product != null &&
                                              viewmodel
                                                  .product!.imageUrl.isNotEmpty
                                          ? viewmodel.product!.imageUrl.first
                                          : null,
                                    ),
                                  )),
                              const SizedBox(width: 12.0),
                              Flexible(
                                child: SizedBox(
                                  height: constraints.maxHeight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(viewmodel.product?.itemDesc ?? '',
                                          style: textTheme.bodyLarge,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      Text(
                                        viewmodel
                                                .product?.highlightedPriceStr ??
                                            '',
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildTitle(
                              context, 'Tap to rate'), // Give Us Your Rating
                          RatingCollector(
                            onChange: (value, name) => onChangedRating(value),
                            iconSize: 36,
                          ),
                          const SizedBox(height: 16),
                          buildTitle(context,
                              'Tell us more'), // Please enter at least 30 characters
                          TextFormField(
                            focusNode:
                                feedbackFieldData['focusNode'] as FocusNode,
                            controller: feedbackFieldData['controller']
                                as TextEditingController,
                            minLines: 5,
                            maxLines: 5,
                            decoration: const InputDecoration(
                                hintText:
                                    'How satisfied are you with this product? Let us know!'),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTitle(context, 'Attach photos / images'),
                              Text(
                                  '${feedbackImages.length}/$kImagePickerLimit',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          FeedbackImagePicker(
                              limit: kImagePickerLimit,
                              onValueChanged: onChangedFeedbackImages)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(bottom: 10.0),
            width: double.infinity,
            color: colorScheme.surface,
            padding: const EdgeInsets.all(16).copyWith(top: 12),
            child: PrimaryButton.filled(
              text: 'Submit',
              onPressed: onSubmit,
              enable: enableConfirmButton,
              // color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      }),
    );
  }
}

/// v1.1
// class CreateProductReview extends StatefulWidget {
//   final bool wrapAppBarIcons;
//   const CreateProductReview({super.key, required this.wrapAppBarIcons});
//
//   @override
//   State<CreateProductReview> createState() =>
//       _CreateProductReviewState();
// }
//
// class _CreateProductReviewState extends State<CreateProductReview> {
//   late ProductDetailViewModel prodDetViewmodel;
//
//   final int kImagePickerLimit = 5;
//
//   final TextEditingController feedbackCtrl = TextEditingController();
//   final FocusNode feedbackFocus = FocusNode();
//
//   List<XFile> feedbackImages = [];
//   int rating = 0;
//   bool _enableConfirmButton = false;
//   bool get enableConfirmButton => _enableConfirmButton;
//
//   @override
//   void initState() {
//     prodDetViewmodel = ProductDetailViewModel()..setContext(context);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final product = ModalRoute.of(context)?.settings.arguments as Product?;
//       prodDetViewmodel.product = product;
//       prodDetViewmodel.loadProduct(product?.itemCode);
//     });
//     super.initState();
//   }
//
//   void onChangedRating(int value) {
//     rating = value;
//     _enableConfirmButton = value > 0;
//     setState(() {});
//   }
//
//   void onChangedFeedbackImages(List<XFile> images) {
//     feedbackImages = images;
//   }
//
//   void unFocusBackground(BuildContext context) {
//     feedbackFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }
//
//   Widget buildTitle(BuildContext context, String title) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Text(title,
//             style: Theme.of(context)
//                 .textTheme
//                 .titleMedium
//                 ?.copyWith(fontWeight: FontWeight.bold)),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return ChangeNotifierProvider(
//       create: (context) => prodDetViewmodel,
//       child: Consumer<ProductDetailViewModel>(
//           builder: (context, viewmodel, child) {
//         // return BackButton()
//         return Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: AppBar(
//             backgroundColor: colorScheme.surface.withAlpha(0),
//             actions: [
//               ActionIconButton.of(context).menu(
//                   items: ['home', 'settings', 'notifications'],
//                   withBackground: widget.wrapAppBarIcons),
//             ],
//           ),
//           body: Stack(
//             children: [
//               AspectRatio(
//                   aspectRatio: 1,
//                   child: ImageWithPlaceholder(
//                     (viewmodel.product?.imageUrl ?? []).isNotEmpty
//                         ? viewmodel.product!.imageUrl.first
//                         : null,
//                   )),
//               SafeArea(
//                 child: DraggableScrollableSheet(
//                   initialChildSize: 0.75, // Opens at half the screen height
//                   minChildSize: 0.6, // Cannot shrink below half
//                   maxChildSize: 1.0, // Can be dragged up to full screen
//                   expand: true,
//                   builder: (context, scrollController) {
//                     final colorScheme = Theme.of(context).colorScheme;
//
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: colorScheme.surface,
//                         borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(24)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 8,
//                             offset: Offset(0, -4),
//                           ),
//                         ],
//                       ),
//                       child: GestureDetector(
//                         onTap: () => unFocusBackground(context),
//                         child: SingleChildScrollView(
//                           controller: scrollController,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               // Padding(
//                               //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                               //   child: Column(
//                               //     crossAxisAlignment: CrossAxisAlignment.center,
//                               //     children: [
//                               //       buildTitle(context, 'Give Us Your Rating'),
//                               //       RatingCollector(
//                               //         onChange: (value, name) => onChangedRating(value),
//                               //         // iconSize: constraints.maxWidth / 5 * 0.5,
//                               //         iconSize: 36,
//                               //         // showDescription: true
//                               //       ),
//                               //     ],
//                               //   ),
//                               // ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 12),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     buildTitle(context,
//                                         'Tap to rate'), // Give Us Your Rating
//                                     RatingCollector(
//                                       onChange: (value, name) =>
//                                           onChangedRating(value),
//                                       // iconSize: constraints.maxWidth / 5 * 0.5,
//                                       iconSize: 36,
//                                       // showDescription: true
//                                     ),
//                                     const SizedBox(height: 16),
//                                     buildTitle(context,
//                                         'Tell us more'), // Please enter at least 30 characters
//                                     TextFormField(
//                                       focusNode: feedbackFocus,
//                                       controller: feedbackCtrl,
//                                       minLines: 5,
//                                       maxLines: 5,
//                                       decoration: const InputDecoration(
//                                           hintText:
//                                               'How satisfied are you with this product? Let us know!'),
//                                     ),
//                                     const SizedBox(height: 16),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         buildTitle(
//                                             context, 'Attach photos / images'),
//                                         Text(
//                                             '${feedbackImages.length}/$kImagePickerLimit',
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold))
//                                       ],
//                                     ),
//                                     FeedbackImagePicker(
//                                         limit: kImagePickerLimit,
//                                         onValueChanged: onChangedFeedbackImages)
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//           bottomNavigationBar: Container(
//             width: double.infinity,
//             color: colorScheme.surface,
//             padding: const EdgeInsets.all(16).copyWith(top: 12),
//             child: PrimaryButton.filled(
//               text: 'Submit',
//               onPressed: () => onSubmitFeedback(context),
//               enable: enableConfirmButton,
//               // color: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   // Padding(
//   //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//   //   child: SizedBox(
//   //     height: 100,
//   //     width: double.infinity,
//   //     child: Card(
//   //       elevation: 1,
//   //       margin: EdgeInsets.zero,
//   //       clipBehavior: Clip.antiAliasWithSaveLayer,
//   //       color: colorScheme.surface,
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(8),
//   //         child: LayoutBuilder(builder: (context, constraints) {
//   //           return Row(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               SizedBox.square(
//   //                   dimension: constraints.maxHeight,
//   //                   child: Card(
//   //                     elevation: 0,
//   //                     margin: EdgeInsets.zero,
//   //                     clipBehavior: Clip.antiAliasWithSaveLayer,
//   //                     shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(12),
//   //                         side: BorderSide(color: Colors.grey[200]!)
//   //                     ),
//   //                     child: ImageWithPlaceholder(
//   //                       viewmodel.product!.imageUrl.isNotEmpty ? viewmodel.product!.imageUrl.first : null,
//   //                     ),
//   //                   )),
//   //               const SizedBox(width: 12.0),
//   //               Flexible(
//   //                 child: SizedBox(
//   //                   height: constraints.maxHeight,
//   //                   child: Column(
//   //                     crossAxisAlignment:
//   //                     CrossAxisAlignment.start,
//   //                     mainAxisAlignment:
//   //                     MainAxisAlignment.spaceEvenly,
//   //                     children: [
//   //                       Text(viewmodel.product?.itemDesc??'',
//   //                           style: textTheme.bodyLarge,
//   //                           maxLines: 2,
//   //                           overflow: TextOverflow.ellipsis),
//   //                       Text(
//   //                         viewmodel.product?.highlightedPriceStr??'',
//   //                         style: textTheme.bodyLarge?.copyWith(
//   //                           fontWeight: FontWeight.bold,
//   //                           color: colorScheme.secondary,
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ),
//   //               )
//   //             ],
//   //           );
//   //         }),
//   //       ),
//   //     ),
//   //   ),
//   // ),
//
//   void onSubmitFeedback(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     final toast = CustomToast.of(context);
//     final navigator = Navigator.of(context);
//   }
// }

/// v1.0
// class CreateProductFeedbackView extends StatefulWidget {
//   const CreateProductFeedbackView({super.key});
//
//   @override
//   State<CreateProductFeedbackView> createState() => _CreateProductFeedbackViewState();
// }
//
// class _CreateProductFeedbackViewState extends State<CreateProductFeedbackView> {
//   final int kImagePickerLimit = 3;
//
//   Widget buildTitle(BuildContext context, String title) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 12),
//     child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
//   );
//
//
//   Widget buildDivider(BuildContext context) => Divider(
//         thickness: 12,
//         height: 12,
//         color: Theme.of(context).colorScheme.surfaceContainerLowest,
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return ChangeNotifierProvider(
//       create: (context) => ProductFeedbackViewmodel()..setContext(context),
//       child: Consumer<ProductFeedbackViewmodel>(builder: (context, viewmodel, child){
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Share Your Feedback'),
//           ),
//           body: Container(
//             color: WidgetStateColor.transparent,
//             constraints: BoxConstraints(
//               minHeight: mediaQuery.size.height -
//                   mediaQuery.viewPadding.top -
//                   kToolbarHeight,
//             ),
//             child: LayoutBuilder(builder: (context, constraints) {
//               return GestureDetector(
//                 onTap: () => viewmodel.unFocusBackground(context),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         child: SizedBox(
//                           height: 100,
//                           width: double.infinity,
//                           child: Card(
//                             elevation: 1,
//                             margin: EdgeInsets.zero,
//                             clipBehavior: Clip.antiAliasWithSaveLayer,
//                             color: colorScheme.surface,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8),
//                               child: LayoutBuilder(builder: (context, constraints) {
//                                 return Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox.square(
//                                         dimension: constraints.maxHeight,
//                                         child: Card(
//                                           elevation: 0,
//                                           margin: EdgeInsets.zero,
//                                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(12),
//                                             side: BorderSide(color: Colors.grey[200]!)
//                                           ),
//                                           child: ImageWithPlaceholder(
//                                             viewmodel.product.imageUrl.isNotEmpty ? viewmodel.product.imageUrl.first : null,
//                                           ),
//                                         )),
//                                     const SizedBox(width: 12.0),
//                                     Flexible(
//                                       child: SizedBox(
//                                         height: constraints.maxHeight,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Text(viewmodel.product.itemDesc??'',
//                                                 style: textTheme.bodyLarge,
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis),
//                                             Text(
//                                               viewmodel.product.highlightedPriceStr,
//                                               style: textTheme.bodyLarge?.copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: colorScheme.secondary,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               }),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             buildTitle(context, 'Give Us Your Rating'),
//                             RatingCollector(
//                               onChange: (value, name) => viewmodel.onChangedRating(value),
//                               iconSize: constraints.maxWidth / 5 * 0.5,
//                               // showDescription: true
//                             ),
//                           ],
//                         ),
//                       ),
//                       buildDivider(context),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             buildTitle(
//                                 context, 'Please enter at least 30 characters'),
//                             TextFormField(
//                               focusNode: viewmodel.feedbackFocus,
//                               controller: viewmodel.feedbackCtrl,
//                               minLines: 5,
//                               maxLines: 5,
//                               decoration: const InputDecoration(
//                                   hintText:
//                                   'How satisfied are you with this product? Let us know!'),
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 buildTitle(context, 'Attach photos / images'),
//                                 Text(
//                                     '${viewmodel.feedbackImages.length}/$kImagePickerLimit',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold))
//                               ],
//                             ),
//                             FeedbackImagePicker(
//                                 limit: kImagePickerLimit,
//                                 onValueChanged:
//                                 viewmodel.onChangedFeedbackImages)
//                           ],
//                         ),
//                       ),
//                       // Padding(
//                       //   padding: const EdgeInsets.all(12.0).copyWith(top: 0),
//                       //   child: Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.center,
//                       //     children: [
//                       //       SizedBox.square(
//                       //           dimension: constraints.maxWidth * 0.4,
//                       //           child: Card(
//                       //               elevation: 0,
//                       //               margin: EdgeInsets.zero,
//                       //               clipBehavior: Clip.antiAliasWithSaveLayer,
//                       //               child: ImageWithPlaceholder(
//                       //                 url,
//                       //                 placeholder: const SizedBox.shrink(),
//                       //               ))),
//                       //       const SizedBox(height: 12.0),
//                       //       Text(title,
//                       //           style: textTheme.bodyLarge?.copyWith(
//                       //               fontWeight: FontWeight.bold),
//                       //           maxLines: 2,
//                       //           overflow: TextOverflow.ellipsis),
//                       //     ],
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//           bottomNavigationBar: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//             child: PrimaryButton.filled(
//               text: 'Confirm Your Feedback',
//               onPressed: ()=> viewmodel.confirmProductFeedback(context),
//               enable: viewmodel.enableConfirmButton,
//               // color: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         );
//       }),
//       // builder: (context, child) {
//       //   feedbackVM = Provider.of<ProductFeedbackViewmodel>(context);
//       //
//       //   final String imageUrl = (_product.imageUrl.isNotEmpty) ? _product.imageUrl.first : '';
//       //
//       //
//       // },
//     );
//   }
// }

class FeedbackImagePicker extends StatefulWidget {
  final Function(List<XFile> images) onValueChanged;
  final int limit;
  const FeedbackImagePicker(
      {super.key, required this.onValueChanged, this.limit = 3});

  @override
  State<FeedbackImagePicker> createState() => _FeedbackImagePickerState();
}

class _FeedbackImagePickerState extends State<FeedbackImagePicker> {
  final List<XFile> _images = [];

  void _setImages(List<XFile> files) {
    if (_images.length > widget.limit) {
      _images.removeRange(widget.limit, _images.length);
    }
    widget.onValueChanged.call(_images);
    setState(() {});
  }

  bool get _allowPicker => _images.length < widget.limit;

  Widget _buildPickerCard(BuildContext context) => Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: _allowPicker
              ? () async {
                  final pickedImages = await showImageSourceSelector(
                      context: context, limit: widget.limit);

                  if (pickedImages.isNotEmpty) {
                    final Set<String> existingPaths =
                        _images.map((e) => e.name).toSet();

                    for (var image in pickedImages) {
                      if (!existingPaths.contains(image.name)) {
                        _images.add(image);
                      }
                    }
                  }
                  _setImages(_images);
                }
              : null,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera_outlined, size: 36.0, color: Colors.grey),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _images.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Display 3 images per row
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index == _images.length) {
          return _allowPicker
              ? _buildPickerCard(context)
              : const SizedBox.shrink();
        }

        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            // alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Image.file(
                File(_images[index].path), // Display each image
                fit: BoxFit.cover,
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      tooltip: 'Remove',
                      onPressed: () {
                        _images.removeAt(index);
                        _setImages(_images);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                          ),
                        ],
                      )))
            ],
          ),
        );
      },
    );
  }
}
