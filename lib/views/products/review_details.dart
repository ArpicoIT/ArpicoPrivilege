import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../shared/customize/custom_toast.dart';
import '../../viewmodels/products/product_viewmodel.dart';
import '../../data/models/product.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/carousel/carousel_item_builder.dart';
import '../../shared/components/images/network_image_carousel.dart';
import 'ratings_and_reviews.dart';

class ReviewDetailsView extends StatefulWidget {
  const ReviewDetailsView({super.key});

  @override
  State<ReviewDetailsView> createState() => _ReviewDetailsViewState();
}

class _ReviewDetailsViewState extends State<ReviewDetailsView> {
  late ProductDetailViewModel prodDetViewmodel;

  Review? review;

  @override
  void initState() {
    prodDetViewmodel = ProductDetailViewModel()
      ..setContext(context)
      ..setLoading(true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final toast = CustomToast.of(context);
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is Map<String, dynamic>) {
        final product = args["product"] as Product?;
        review = args["review"] as Review?;

        prodDetViewmodel.product = product;

        // if (product != null) {
        //   await prodDetViewmodel.loadProduct(product.itemCode);
        // } else {
        //   toast.showPrimary("Product not found");
        // }

        // Optionally store review if needed later:
        // if (review != null) {
        //   prodDetViewmodel.selectedReview = review;
        // }
      } else {
        toast.showPrimary("Invalid arguments passed");
      }
    });
    super.initState();
  }

  Widget buildComments() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No Comments Yet', style: textTheme.titleMedium),
          const Text('Start the conversation by adding your thoughts!',
              style: TextStyle(color: Colors.grey))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Details'),
        centerTitle: true,

        actions: [
          ActionIconButton.of(context)
              .menu(items: ['home', 'settings', 'notifications']),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => prodDetViewmodel,
        child: Consumer<ProductDetailViewModel>(builder: (context, vm, child) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RatingsAndReviewWidget.reviewUserBar(
                        context,
                        onTap: () {},
                        imageUrl: review?.profilePic,
                        userName: review?.userName,
                        createdAt: review?.datetime != null
                            ? DateTime.fromMillisecondsSinceEpoch(
                                review!.datetime!)
                            : null,
                        rating: review?.rating != null ? review!.rating.toDouble() : 0,
                      ),
                      (review != null && review!.images.isNotEmpty)
                          ? Card(
                              clipBehavior: Clip.hardEdge,
                              elevation: 0,
                              margin: const EdgeInsets.all(12),
                              child: ImageCarousel(
                                images: review!.images,
                                builder: (context, url, child) {
                                  return child;
                                },
                                options: CarouselOptions(
                                  autoPlay: false,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 0.9,
                                  aspectRatio: 1,
                                  initialPage: 0,
                                ),
                                indicator: CarouselIndicator(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    type: CslIndicatorType.counter),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(12).copyWith(top: 0),
                        child: (review?.review ?? '').isNotEmpty ? Text(review!.review!) : Text('No Content', style: TextStyle(color: Colors.grey)),
                      ),
                      const Divider(height: 12),
                      buildComments(),
                      const SizedBox(height: kToolbarHeight)
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// v1.0
/*class ReviewDetailsView extends StatefulWidget {
  const ReviewDetailsView({super.key});

  @override
  State<ReviewDetailsView> createState() => _ReviewDetailsViewState();
}

class _ReviewDetailsViewState extends State<ReviewDetailsView> {

  late ProductDetailViewModel prodDetViewmodel;

  @override
  void initState() {
    prodDetViewmodel = ProductDetailViewModel()..setContext(context)..setLoading(true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final product = ModalRoute.of(context)?.settings.arguments as Product?;
      prodDetViewmodel.product = product;
      prodDetViewmodel.loadProduct(product?.itemCode);
    });
    super.initState();
  }

  final FocusNode commentInputFocus = FocusNode();
  final TextEditingController commentInputCtrl = TextEditingController();

  Review review = Review();

  List<CommentData> comments = CommentData.data;

  int get totalCommentsCount => getCommentCount(comments);

  int getCommentCount(List<CommentData> comments) {
    int count = 0;
    for (var comment in comments) {
      count++; // Count the main comment
      if (comment.replies.isNotEmpty) {
        count += getCommentCount(comment.replies); // Recursively count replies
      }
    }
    return count;
  }

  void saveComment(String data) {
    final comment = CommentData(
        avatar: null,
        userName: 'Gayan Chanaka',
        content: data,
        createdAt: DateTime.now()
    );

    comments.add(comment);
    comments.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }

  void likeComment(CommentData value) {
    value.like = !value.like;
  }

  void startReplying(CommentData value) {
    // _commentController.text = "@${value.userName ?? ''} ";
    // _commentFieldFocus.requestFocus();
  }

  Widget buildComments() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: (totalCommentsCount == 0)
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Comments ($totalCommentsCount)',
              style: textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16.0),
          ...List.generate(comments.length, (i) {
            final root = comments[i];
            final replies = comments[i].replies;
            return CommentTree(root, replies,
                onPressedLike: likeComment,
                onPressedReply: startReplying);
          })
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No Comments Yet', style: textTheme.titleMedium),
          const Text('Start the conversation by adding your thoughts!',
              style: TextStyle(color: Colors.grey))
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold();

    */

/*return Scaffold(
      appBar: AppBar(title: const Text('Review Deteils')),
      // bottomSheet: CommentInputBottomWidget(
      //   focusNode: reviewDetailsVM.commentInputFocus,
      //   controller: reviewDetailsVM.commentInputCtrl,
      //   onSave: reviewDetailsVM.saveComment,
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RatingsAndReviewWidget.reviewUserBar(
                    context,
                    onTap: () {},
                    imageUrl: reviewDetailsVM.review.profilePic,
                    userName: reviewDetailsVM.review.userName,
                    createdAt: reviewDetailsVM.review.datetime != null
                        ? DateTime.fromMillisecondsSinceEpoch(
                        reviewDetailsVM.review.datetime!)
                        : null,
                    rating: reviewDetailsVM.review.rating.toDouble(),
                  ),
                  (reviewDetailsVM.review.images.isNotEmpty)
                      ? Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 0,
                    margin: const EdgeInsets.all(12.0),
                    child: ImageCarousel(
                      images: reviewDetailsVM.review.images,
                      builder: (context, url, child) {
                        return child;
                      },
                      options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.9,
                        aspectRatio: 1,
                        initialPage: 0,
                      ),
                      indicator: CarouselIndicator(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20.0)),
                          type: CslIndicatorType.counter),
                    ),
                  )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(12.0).copyWith(top: 0.0),
                    child: Text(reviewDetailsVM.review.review ?? ''),
                  ),
                  const Divider(height: 12.0),
                  buildComments(),
                  const SizedBox(height: kToolbarHeight)
                ],
              ),
            ),
          ),
        ),
      ),
    );*/

/*

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (context) => ProductDescriptionViewmodel()),
    //     ChangeNotifierProvider(create: (context) => ReviewDetailsViewModel())
    //   ],
    //   builder: (context, child) {
    //     productVM = Provider.of<ProductDescriptionViewmodel>(context);
    //     reviewDetailsVM = Provider.of<ReviewDetailsViewModel>(context);
    //
    //
    //   },
    // );
  }

}*/

class CommentInputBottomWidget extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String text) onSave;
  final bool autoFocus;
  final Color? backgroundColor;

  const CommentInputBottomWidget({
    super.key,
    required this.focusNode,
    required this.onSave,
    required this.controller,
    this.autoFocus = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ValueNotifier<bool> hasComment =
        ValueNotifier(controller.text.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(8.0).copyWith(right: 0),
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
              top: BorderSide(color: colorScheme.outline.withAlpha(100)))),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              textInputAction: TextInputAction.newline,
              focusNode: focusNode,
              controller: controller,
              autofocus: autoFocus,
              maxLines: 4,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
              ),
              onChanged: (value) {
                hasComment.value = value.isNotEmpty;
              },
            ),
          ),
          // const SizedBox(width: 12.0),
          ValueListenableBuilder<bool>(
              valueListenable: hasComment,
              builder: (context, value, _) {
                return IconButton(
                  onPressed: value ? () => onSave(controller.text) : null,
                  icon: const Icon(Icons.send, size: 28.0),
                  color: value ? colorScheme.primary : null,
                );
              })
        ],
      ),
    );
  }
}
