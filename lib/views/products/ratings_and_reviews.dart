import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/product.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/buttons/primary_button.dart';
import '../../shared/components/indicators/rating_indicator.dart';
import '../../shared/components/images/user_avatar.dart';
import '../../shared/components/tab_bar.dart';
import '../../viewmodels/products/product_viewmodel.dart';
import '../../app/app_routes.dart';
import '../../shared/components/empty_placeholder.dart';
import '../../shared/components/image_with_placeholder.dart';
import '../../shared/widgets/app_alert.dart';
import '../../shared/components/carousel/fullscreen_image_carousel.dart';

class RatingsAndReviewsView extends StatefulWidget {
  const RatingsAndReviewsView({super.key});

  @override
  State<RatingsAndReviewsView> createState() => _RatingsAndReviewsViewState();
}

class _RatingsAndReviewsViewState extends State<RatingsAndReviewsView> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;

  late ProductDetailViewModel prodDetViewmodel;

  String reviewTabValue = 'All';

  @override
  void initState() {
    prodDetViewmodel = ProductDetailViewModel()..setContext(context);

    // initialize controllers
    _refreshController = RefreshController();
    _scrollController = ScrollController();

    // initialize notifiers
    _showScrollUpBtn = ValueNotifier<bool>(false);

    // initialize listeners
    _scrollController.addListener(_updateScrollUpButtonVisibility);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final product = ModalRoute.of(context)?.settings.arguments as Product?;
      prodDetViewmodel.product = product;
      prodDetViewmodel.loadProduct(product?.itemCode);
    });
    super.initState();
  }

  // helper functions
  void _updateScrollUpButtonVisibility() {
    bool value = _showScrollUpBtn.value;
    final double minScrollChanging = MediaQuery.of(context).size.width * 0.5;

    if (_scrollController.offset > minScrollChanging && !value) {
      _showScrollUpBtn.value = !value;
    } else if (_scrollController.offset <= minScrollChanging && value) {
      _showScrollUpBtn.value = !value;
    }
  }

  // button functions
  void onScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onChangedTab(String value) async {
    setState(() {
      reviewTabValue = value;
    });
  }

  void onAddReview() async {
    final result = await Navigator.of(context).pushNamed(
        AppRoutes.createProductReview,
        arguments: prodDetViewmodel.product);

    if (result is Review) {
      _refreshController.requestRefresh();
    }
  }

  void onTapReview(Review review) async {
    final product = prodDetViewmodel.product;
    if (product == null) return;

    final result = await Navigator.of(context).pushNamed(
      AppRoutes.reviewDetails,
      arguments: {
        "product": product,
        "review": review,
      },
    );

    if (result is Review) {
      _refreshController.requestRefresh();
    }
  }

  void onTapImage(Review review, String image) =>
      FullscreenImageCarousel.show(context,
          current: image, list: review.images);

  // smart refresher functions
  void onRefresh() async {
    try {
      await prodDetViewmodel.loadProduct(prodDetViewmodel.product?.itemCode);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  Widget buildSliverTabBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final List<String> tabItems = ['All', '5', '4', '3', '2', '1'];

    return SliverPersistentHeader(
        pinned: true,
        delegate: TabBarDelegate(
          PreferredSize(
            preferredSize: Size.fromHeight(54),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: DefaultTabController(
                  length: tabItems.length,
                  initialIndex: 0,
                  child: ButtonsTabBar(
                    // height: 30.0,
                    labelSpacing: 8.0,
                    backgroundColor: colorScheme.primary,
                    unselectedBackgroundColor: colorScheme.surfaceContainer,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    buttonMargin: const EdgeInsets.symmetric(horizontal: 16.0),
                    labelStyle: const TextStyle(color: Colors.white),
                    unselectedLabelStyle:
                        TextStyle(color: colorScheme.onSurfaceVariant),
                    tabs: tabItems
                        .map((e) => Tab(
                              icon: const Icon(Icons.star, size: 16.0),
                              text: e,
                            ))
                        .toList(),
                    onTap: (i) => onChangedTab(tabItems[i]),
                  )),
            ),
          ),
        ));
  }

  Widget buildSliverBasicDetails() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
        value: prodDetViewmodel,
        child: Consumer<ProductDetailViewModel>(builder: (context, vm, child) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        (vm.product?.averageRating ?? 0).toStringAsFixed(1),
                        style: textTheme.displayMedium,
                      ),
                      const SizedBox(height: 4.0),
                      RatingIndicator(
                        currentRating: vm.product?.averageRating,
                        iconSize: 18.0,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        '${NumberFormat("#,###").format(vm.product?.totalReviews ?? 0)} reviews',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0), // Add spacing between columns
                Expanded(
                  flex: 6,
                  child: RatingsAndReviewWidget.ratingBarsBuilder(
                    context,
                    {
                      5: vm.product?.countByRating['5'] ?? 0,
                      4: vm.product?.countByRating['4'] ?? 0,
                      3: vm.product?.countByRating['3'] ?? 0,
                      2: vm.product?.countByRating['2'] ?? 0,
                      1: vm.product?.countByRating['1'] ?? 0,
                    },
                    vm.product?.countByRating['all'] ?? 0,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildSliverReviews() {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider.value(
        value: prodDetViewmodel,
        child: Consumer<ProductDetailViewModel>(builder: (context, vm, child) {
          final List<Review> reviews =
              vm.filterProductReviewsByTab(reviewTabValue);

          if (reviews.isEmpty) {
            return SliverToBoxAdapter(
                child: AppAlertView(
                    aspectRatio: 1,
                    status: AppAlertType.noData,
                    onRefresh: onRefresh));
          }

          return SliverList.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];

                return Container(
                  color: colorScheme.surface,
                  child: RatingsAndReviewWidget.reviewCardWithActions(context,
                      review: review,
                      // onTapUser: () {},
                      onPressedLike: () {},
                      onPressedComment: () => onTapReview(review),
                      onPressedMore: () =>
                          RatingsAndReviewWidget.reportFeedback(context, () {}),
                      onTap: () => onTapReview(review),
                      onTapImage: (image) => onTapImage(review, image)),
                );
              });
        }));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope<Product>(
      canPop: false,
      onPopInvokedWithResult: (pop, _) {
        if (!pop) {
          Navigator.pop(context, prodDetViewmodel.product);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Text("Ratings & Reviews"),
          centerTitle: true,
          actions: [
            ActionIconButton.of(context)
                .menu(items: ['home', 'settings', 'notifications']),
          ],
        ),
        body: SmartRefresher(
          scrollController: _scrollController,
          enablePullDown: true,
          enablePullUp: false,
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              if (mode == LoadStatus.loading) {
                return const CupertinoActivityIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
          controller: _refreshController,
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: [
              buildSliverBasicDetails(),
              buildSliverTabBar(),
              buildSliverReviews(),
            ],
          ),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: _showScrollUpBtn,
            builder: (context, value, child) {
              if (!value) {
                return const SizedBox.shrink();
              }
              return FloatingActionButton.small(
                onPressed: onScrollToTop,
                tooltip: "Scroll Up",
                child: Icon(Icons.keyboard_arrow_up_sharp),
              );
            }),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          width: double.infinity,
          color: colorScheme.surface,
          padding: const EdgeInsets.all(16).copyWith(top: 12),
          child: PrimaryButton.filled(
            text: 'Add Review',
            onPressed: onAddReview,
            // color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class SliverAnimatedListBuilder<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) builder;
  final Duration delay;

  const SliverAnimatedListBuilder({
    super.key,
    required this.items,
    required this.builder,
    this.delay = const Duration(milliseconds: 50),
  });

  @override
  State<SliverAnimatedListBuilder<T>> createState() =>
      _SliverAnimatedListBuilderState<T>();
}

class _SliverAnimatedListBuilderState<T>
    extends State<SliverAnimatedListBuilder<T>> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  final List<T> _currentItems = [];

  @override
  void initState() {
    super.initState();
    _insertAllItems();
  }

  @override
  void didUpdateWidget(covariant SliverAnimatedListBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _updateList(oldWidget.items, widget.items);
    }
  }

  Future<void> _insertAllItems() async {
    for (int i = 0; i < widget.items.length; i++) {
      await Future.delayed(widget.delay);
      _currentItems.insert(i, widget.items[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  Future<void> _updateList(List<T> oldItems, List<T> newItems) async {
    for (int i = _currentItems.length - 1; i >= 0; i--) {
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => _buildAnimatedItem(_currentItems[i], animation),
        duration: const Duration(milliseconds: 200),
      );
    }
    _currentItems.clear();
    await Future.delayed(const Duration(milliseconds: 300));
    _insertAllItems();
  }

  Widget _buildAnimatedItem(T item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: widget.builder(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _currentItems.length,
      itemBuilder: (context, index, animation) {
        return _buildAnimatedItem(_currentItems[index], animation);
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;

  const ActionButton({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(selected ? selectedIcon ?? icon : icon, size: 20),
      label: Text(label),
      style: TextButton.styleFrom(
        elevation: 0.0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        shape: const RoundedRectangleBorder(),
      ),
    );
  }
}

class RatingsAndReviewWidget {
  static Widget reviewCard(
    BuildContext context, {
    String? review,
    double? rating,
    String? reviewedUserName,
    List<String> images = const [],
    Function()? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: colorScheme.surfaceContainerLowest,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ((review ?? "").isNotEmpty)
                        ? Text(review!,
                            maxLines: 2, overflow: TextOverflow.ellipsis)
                        : Text("No Content",
                            style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        if (rating != null)
                          RatingIndicator(
                            currentRating: rating,
                            iconSize: 18.0,
                          ),
                        const SizedBox(width: 4.0),
                        if (reviewedUserName != null)
                          Flexible(
                              child: Text(reviewedUserName,
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1))
                      ],
                    )
                  ],
                ),
              ),
              if (images.isNotEmpty) ...[
                const SizedBox(width: 8.0),
                SizedBox.square(
                  dimension: 84.0,
                  child: feedbackImagesBuilder(context,
                      images: images,
                      imageSize: 84.0,
                      physics: const NeverScrollableScrollPhysics()),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  static Widget reviewCardWithActions(
    BuildContext context, {
    required Review review,
    VoidCallback? onTap,
    VoidCallback? onTapUser,
    VoidCallback? onPressedLike,
    VoidCallback? onPressedComment,
    VoidCallback? onPressedMore,
    Function(String image)? onTapImage,
    bool isLiked = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // decoration: BoxDecoration(
        //     // color: colorScheme.surface,
        //     border: Border(
        //   bottom: BorderSide(color: colorScheme.surfaceContainerLow, width: 4),
        // )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            reviewUserBar(
              context,
              onTap: onTapUser,
              imageUrl: review.profilePic,
              userName: review.userName,
              createdAt: review.datetime != null
                  ? DateTime.fromMillisecondsSinceEpoch(review.datetime!)
                  : null,
              rating: review.rating.toDouble(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Wrap(
                runSpacing: 12.0,
                children: [
                  Builder(builder: (context) {
                    final reviewText = review
                        .review; // ! + review.review! + review.review! + review.review! + review.review! + review.review!;

                    if (reviewText == null) {
                      return const SizedBox.shrink();
                    } else if (reviewText.isEmpty) {
                      return const Text('No Content',
                          style: TextStyle(color: Colors.grey));
                    } else {
                      String subText;
                      bool more;

                      if (reviewText.length > 120) {
                        subText = reviewText.substring(0, 120);
                        more = true;
                      } else {
                        subText = reviewText;
                        more = false;
                      }

                      return Text.rich(TextSpan(text: subText, children: [
                        if (more)
                          const TextSpan(
                              text: ' ...Show more',
                              style: TextStyle(fontWeight: FontWeight.bold))
                      ]));
                    }
                  }),
                  if (review.images.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: feedbackImagesBuilder(context,
                          images: review.images,
                          imageSize: 96.0,
                          onTap: onTapImage),
                      // onTap: (image) => onTapImage(review.images.indexOf(image), review.images)),
                    )
                ],
              ),
            ),

            /// for future developments
            const SizedBox(height: 12.0)
            // Container(
            //   margin: const EdgeInsets.only(top: 12.0),
            //   // decoration: BoxDecoration(
            //   //   border: Border(top: BorderSide(color: colorScheme.outlineVariant.withAlpha(100)))
            //   // ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         mainAxisSize: MainAxisSize.min,
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           ActionButton(
            //             icon: Icons.thumb_up_alt_outlined,
            //             selectedIcon: Icons.thumb_up_alt,
            //             label: 'Like',
            //             onPressed: onPressedLike,
            //             selected: isLiked,
            //           ),
            //           ActionButton(
            //               icon: Icons.mode_comment_outlined,
            //               label: 'Comment',
            //               onPressed: onPressedComment)
            //         ],
            //       ),
            //       const SizedBox.shrink(),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 4.0),
            //         child: IconButton(
            //           onPressed: onPressedMore,
            //           icon: const Icon(Icons.more_vert),
            //           style: IconButton.styleFrom(
            //               tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  static Widget reviewUserBar(BuildContext context,
      {VoidCallback? onTap,
      String? imageUrl,
      String? userName,
      DateTime? createdAt,
      double rating = 0.0,
      double ratingIconSize = 18.0}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserAvatar(
                    avatar: imageUrl,
                    userName: userName,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (userName != null && userName.isNotEmpty)
                            ? Text(userName,
                                maxLines: 1, overflow: TextOverflow.ellipsis)
                            : EmptyPlaceholder(height: 16.0, width: 180.0),
                        const SizedBox(height: 4.0),
                        (createdAt != null)
                            ? Text(timeago.format(createdAt),
                                style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant))
                            : EmptyPlaceholder(height: 12.0, width: 96.0)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (rating > 0)
                ? RatingIndicator(
                    currentRating: rating, iconSize: ratingIconSize)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  static Widget feedbackImagesBuilder(BuildContext context,
      {required List<String> images,
      double imageSize = 84.0,
      Function(String url)? onTap,
      ScrollPhysics? physics}) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: physics,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(images.length, (i) {
          final String url = images[i];

          return Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
            child: SizedBox.square(
              dimension: imageSize,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: colorScheme.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Stack(children: [
                    Positioned.fill(child: ImageWithPlaceholder(url)),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: (onTap != null) ? () => onTap(url) : null),
                    ),
                  ]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  static Widget ratingBarsBuilder(
      BuildContext context, Map<int, int> countByRating, int all) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final entries = countByRating.entries.map((entry) => entry).toList();
    entries.sort((a, b) => b.key.compareTo(a.key));
    // final int all =
    //     entries.map((e) => e.value).toList().reduce((a, b) => a + b);

    return Column(
      children: List.generate(entries.length, (i) {
        final key = entries[i].key;
        final value = entries[i].value;
        final percentage = (value > 0 && all > 0) ? value * 100 / all : 0;

        return Padding(
          padding: const EdgeInsets.only(top: 8, right: 12)
              .copyWith(top: i == 0 ? 0 : null),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.orangeAccent, size: 18.0),
              SizedBox(
                  width: 24.0,
                  child: Text(key.toString(), textAlign: TextAlign.center)),
              Flexible(
                child: LinearPercentIndicator(
                  lineHeight: 12.0,
                  percent: percentage * 0.01,
                  barRadius: const Radius.circular(6.0),
                  backgroundColor: colorScheme.surfaceContainerLow,
                  progressColor: colorScheme.primary,
                  animation: true,
                  padding: const EdgeInsets.only(right: 6.0),
                ),
              ),
              SizedBox(
                width: 48.0,
                child: Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  static void reportFeedback(BuildContext context, Function() onReport) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            title: const Text('Report Feedback'),
            leading: const Icon(Icons.report_outlined),
            tileColor: colorScheme.surface,
            iconColor: colorScheme.onSurface,
            onTap: () {
              onReport.call();
              Navigator.of(context).maybePop();
            },
          ),
        );
      },
      shape: const OutlineInputBorder(
          borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
      backgroundColor: WidgetStateColor.transparent,
    );
  }
}

/// v1.0
/*class RatingsAndReviewsView extends StatefulWidget {
  const RatingsAndReviewsView({super.key});

  @override
  State<RatingsAndReviewsView> createState() => _RatingsAndReviewsViewState();
}

class _RatingsAndReviewsViewState extends State<RatingsAndReviewsView> {
  late ProductCollectionViewmodel productViewmodel;

  Widget buildLoader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerLow, // surface
        highlightColor: colorScheme.surfaceContainerLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmptyPlaceholder(height: 48.0, width: 96.0),
                          const SizedBox(height: 8.0),
                          EmptyPlaceholder(height: 24.0, width: 120.0),
                          const SizedBox(height: 8.0),
                          EmptyPlaceholder(height: 14.0, width: 84.0),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.6,
                      child: Column(
                        children: List.generate(
                            5,
                            (i) => Padding(
                                  padding:
                                      EdgeInsets.only(top: i == 0 ? 0 : 12),
                                  child: EmptyPlaceholder(
                                      height: 14.0,
                                      width: constraints.maxWidth * 0.5),
                                )),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    6, (i) => EmptyPlaceholder(height: 30.0, width: 48.0)),
              ),
            ),
            ...List.generate(
                10,
                (i) => Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(12.0), //.copyWith(bottom: 0.0),
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(
                                  color: colorScheme.surfaceContainerLowest,
                                  width: 4.0))),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  EmptyPlaceholder.round(radius: 48.0),
                                  const SizedBox(width: 12.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      EmptyPlaceholder(
                                          height: 16.0, width: 120.0),
                                      const SizedBox(height: 12.0),
                                      EmptyPlaceholder(
                                          height: 12.0, width: 84.0),
                                    ],
                                  ),
                                ],
                              ),
                              EmptyPlaceholder(height: 18.0, width: 120.0),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          EmptyPlaceholder.paragraph(
                            width: double.infinity,
                            height: 12,
                          ),
                          const SizedBox(height: 12.0),
                          SizedBox(
                            width: double.infinity,
                            height: 72.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) => Padding(
                                padding: EdgeInsets.only(left: i == 0 ? 0 : 12),
                                child: EmptyPlaceholder.box(dimension: 72.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              EmptyPlaceholder(height: 24.0, width: 96.0),
                              const SizedBox(width: 8.0),
                              EmptyPlaceholder(height: 24.0, width: 96.0),
                            ],
                          )
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emptyReviewsWidget = PageAlert.widget(key: Key("emptyReviews"));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => RatingsAndReviewsViewmodel()..setContext(context),
      child: Consumer<RatingsAndReviewsViewmodel>(
          builder: (context, viewmodel, child) {
        return PopScope<Product>(
          canPop: false,
          onPopInvokedWithResult: (pop, product){
            if(!pop){
              Navigator.pop(context, viewmodel.product);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Ratings & Reviews"),
            ),
            body: SmartRefresher(
              enablePullDown: true,
              header: const WaterDropHeader(),
              // header: BezierHeader(),
              footer: const SizedBox.shrink(),
              controller: viewmodel.refreshController,
              onRefresh: () => viewmodel.onRefresh(context),
              child: (viewmodel.product.id == null)
                  ? buildLoader(context)
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LayoutBuilder(builder: (context, constraints) {
                            return SizedBox(
                              width: constraints.maxWidth,
                              child: Flex(
                                direction: Axis.horizontal,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            viewmodel.product.averageRating
                                                .toStringAsFixed(1),
                                            style: textTheme.displayMedium),
                                        const SizedBox(height: 4.0),
                                        RatingIndicator(
                                          currentRating:
                                              viewmodel.product.averageRating,
                                          iconSize: 18.0,
                                        ),
                                        const SizedBox(height: 12.0),
                                        Text(
                                            '${NumberFormat("#,###").format(viewmodel.product.totalReviews)} reviews',
                                            style: textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.6,
                                    child:
                                        RatingsAndReviewWidget.ratingBarsBuilder(
                                            context,
                                            {
                                              5: viewmodel
                                                  .product.countByRating['5'],
                                              4: viewmodel
                                                  .product.countByRating['4'],
                                              3: viewmodel
                                                  .product.countByRating['3'],
                                              2: viewmodel
                                                  .product.countByRating['2'],
                                              1: viewmodel
                                                  .product.countByRating['1']
                                            },
                                            viewmodel
                                                .product.countByRating['all']),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 24.0),
                            alignment: Alignment.center,
                            child: DefaultTabController(
                              length: viewmodel.tabItems.length,
                              child: ButtonsTabBar(
                                height: 30.0,
                                labelSpacing: 8.0,
                                backgroundColor: colorScheme.primary,
                                unselectedBackgroundColor:
                                    colorScheme.surfaceContainer,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                buttonMargin:
                                    const EdgeInsets.symmetric(horizontal: 16.0),
                                labelStyle: const TextStyle(color: Colors.white),
                                unselectedLabelStyle:
                                    TextStyle(color: colorScheme.primary),
                                tabs: viewmodel.tabItems
                                    .map((e) => Tab(
                                          icon:
                                              const Icon(Icons.star, size: 16.0),
                                          text: e,
                                        ))
                                    .toList(),
                                onTap: (i) {
                                  viewmodel.tabIndex = i;
                                },
                              ),
                            ),
                          ),
                          Divider(color: colorScheme.surfaceContainerLow),
                          Container(
                            // color: Colors.red,
                            constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.5),
                            child: (viewmodel.filterByTabs.isEmpty)
                                ? emptyReviewsWidget
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: viewmodel.filterByTabs.length,
                                    itemBuilder: (context, i) {
                                      final review = viewmodel.filterByTabs[i];

                                      return RatingsAndReviewWidget.reviewCardWithActions(
                                          context,
                                          review: review,
                                          // onTapUser: () {},
                                          onPressedLike: () {},
                                          onPressedComment: () => Navigator.of(context)
                                              .pushNamed(AppRoutes.reviewDetails,
                                                  arguments: review),
                                          onPressedMore: () =>
                                              RatingsAndReviewWidget.reportFeedback(
                                                  context, () {}),
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(AppRoutes.reviewDetails,
                                                  arguments: review),
                                          onTapImage: (image) =>
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => FeedbackImagesView(current: image, images: review.images))));
                                    }),

                            // child: ValueListenableBuilder(
                            //     valueListenable: ratNRevVM.filteredReviewsNotifier,
                            //     builder: (context, value, child) {
                            //
                            //       if(value.isEmpty){
                            //         return emptyReviewsWidget;
                            //       }
                            //
                            //       return ListView.builder(
                            //           shrinkWrap: true,
                            //           physics: const NeverScrollableScrollPhysics(),
                            //           padding: EdgeInsets.zero,
                            //           itemCount: value.length,
                            //           itemBuilder: (context, i) {
                            //             final review = value[i];
                            //
                            //             return RatingsAndReviewWidget.reviewCardWithActions(
                            //                 context,
                            //                 review: review,
                            //                 // onTapUser: () {},
                            //                 onPressedLike: () {},
                            //                 onPressedComment: () => Navigator.of(context)
                            //                     .pushNamed(AppRoutes.reviewDetails,
                            //                     arguments: review),
                            //                 onPressedMore: () =>
                            //                     RatingsAndReviewWidget.reportFeedback(
                            //                         context, () {}),
                            //                 onTap: () => Navigator.of(context).pushNamed(
                            //                     AppRoutes.reviewDetails,
                            //                     arguments: review),
                            //                 onTapImage: (image) => Navigator.of(context).push(
                            //                     MaterialPageRoute(builder: (context) => FeedbackImagesView(current: image, images: review.images))));
                            //           });
                            //     }),
                          ),
                          const SizedBox(height: 120.0)
                        ],
                      ),
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add your review',
              onPressed: () async {
                final result = await Navigator.of(context).pushNamed(
                    AppRoutes.shareYourFeedback,
                    arguments: viewmodel.product);

                if (result is Review && context.mounted) {
                  await viewmodel.loadProduct(viewmodel.product.itemCode);
                }
              },
              child: const Icon(Icons.rate_review_outlined),
            ),
          ),
        );
      }),
    );
  }
}*/
