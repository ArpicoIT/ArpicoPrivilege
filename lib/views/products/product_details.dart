import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/models/product.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/carousel/carousel_item_builder.dart';
import '../../shared/components/tab_bar.dart';
import '../../shared/components/titled_bottom_sheet.dart';
import '../../shared/widgets/app_alert.dart';
import '../../shared/customize/custom_error.dart';
import '../../shared/components/cards/product_card.dart';
import '../../viewmodels/products/product_viewmodel.dart';
import 'ratings_and_reviews.dart';
import '../../app/app_routes.dart';
import '../../shared/components/images/network_image_carousel.dart';
import '../../shared/components/indicators/rating_indicator.dart';
import 'product_center.dart';

class ProductDetailsView extends StatefulWidget {
  final bool wrapAppBarIcons;
  const ProductDetailsView({super.key, required this.wrapAppBarIcons});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;

  late ProductCollectionViewmodel prodCollViewmodel;
  late ProductDetailViewModel prodDetViewmodel;

  int prodTabIndex = 0;

  @override
  void initState() {
    prodCollViewmodel = ProductCollectionViewmodel()
      ..setContext(context)
      ..setLoading(true);
    prodDetViewmodel = ProductDetailViewModel()
      ..setContext(context)
      ..setLoading(true);
    // prodDetViewmodel = ProductDetailViewModel()..setContext(context);

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

      prodCollViewmodel.loadInitialProducts(prodTabIndex);
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

  void onChangedTab(int i) async {
    setState(() {
      prodTabIndex = i;
    });

    if (prodCollViewmodel.getCurrentDataModel(i).data.isEmpty) {
      await prodCollViewmodel.loadInitialProducts(i);
    }
  }

  // smart refresher functions
  void onRefresh() async {
    try {
      await prodDetViewmodel.loadProduct(prodDetViewmodel.product?.itemCode);
      await prodCollViewmodel.refreshProducts(prodTabIndex);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void onLoading() async {
    try {
      await prodCollViewmodel.loadMoreProducts(prodTabIndex);
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  Widget buildTitle(String title) => Text(title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold));

  Widget buildBasicDetails(Product product) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(
                product.highlightedPriceStr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                    height: 1),
              ),
              (product.lineThroughPriceStr != null)
                  ? Text(
                product.lineThroughPriceStr!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey,
                    height: 1.2),
              )
                  : const SizedBox.shrink(),
              (product.discountPct > 0 && product.discountPct < 100)
                  ? Material(
                type: MaterialType.canvas,
                color: colorScheme.secondary.withAlpha(50),
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    "-${product.discountPct}%",
                    style: TextStyle(color: colorScheme.secondary),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.itemDesc ?? "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.star, color: Colors.orangeAccent, size: 20),
                  const SizedBox(width: 4),
                  Text(
                      "${product.averageRating.toStringAsFixed(1)} (${product.totalReviews})"),
                ],
              ),
              Row(
                children: [
                  // IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                  // IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(Icons.share)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRatingAndReviews(Product product) {
    // if not reviews "This product has no reviews" show without RatingsIndicator()
    final colorScheme = Theme.of(context).colorScheme;
    final reviewCount = product.reviews
        .sublist(0, product.reviews.length >= 3 ? 3 : null)
        .length;

    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context)
            .pushNamed(AppRoutes.ratingsAndReviews, arguments: product);

        // if (result is Product) {
        //   _refreshController.requestRefresh();
        // }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        color: colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTitle("Ratings & Reviews (${product.totalReviews})"),
                (product.averageRating > 0 &&
                        MediaQuery.of(context).size.width * 0.5 > 200)
                    ? RatingIndicator(
                        currentRating: product.averageRating,
                        showLeading: true,
                        showAction: true,
                      )
                    : Icon(Icons.navigate_next,
                        color: colorScheme.outlineVariant),
              ],
            ),

            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviewCount,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final data = product.reviews[index];

                  return Container(
                    margin: EdgeInsets.only(top: index == 0 ? 12 : 8),
                    child: RatingsAndReviewWidget.reviewCard(context,
                        rating: data.rating.toDouble(),
                        review: data.review,
                        reviewedUserName: data.userName,
                        images: data.images
                        // onTap: (){}
                        ),
                  );
                })

            // Align(
            //   alignment: Alignment.center,
            //   child: ComPrimaryButton(
            //     onPressed: ()=> Navigator.of(context).pushNamed(AppRoutes.shareYourFeedback, arguments: {}),
            //     text: 'Add Your Review',
            //     icon: Icons.rate_review_outlined,
            //     color: Theme.of(context).colorScheme.secondary,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget buildProductDetails(Product product) {
    final colorScheme = Theme.of(context).colorScheme;
    final subtitleStyle = Theme.of(context).textTheme.titleSmall;
    final desStyle = TextStyle(color: colorScheme.onSurfaceVariant);

    return Container(
      constraints: const BoxConstraints(minHeight: 240),
      color: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: buildTitle("Product Details"),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (product.proHighlights != null) ...[
                  Text("Highlights", style: subtitleStyle),
                  const SizedBox(height: 8),
                  Text(product.proHighlights!, style: desStyle),
                ],
                const SizedBox(height: 12),
                if (product.proDescription != null) ...[
                  Text("Description", style: subtitleStyle),
                  const SizedBox(height: 8),
                  Text(product.proDescription!, style: desStyle),
                ],
              ],
            ),
          ),
          Container(
            // padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(
                        color: colorScheme.outlineVariant.withAlpha(100)))),
            child: ListTile(
              onTap: () => TitledBottomSheet.show(
                context: context,
                title: 'Specifications',
                builder: (context) => buildSpecifications(product),
                // showDragHandle: true
              ),
              title: const Text('Specifications'),
              trailing: const Icon(Icons.navigate_next),
              contentPadding: const EdgeInsets.all(12),
              minTileHeight: 0,
              minVerticalPadding: 0,
              titleTextStyle: subtitleStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget buildSpecifications(Product product) {
    const titleStyle = TextStyle();
    const desStyle = TextStyle(color: Colors.grey);
    final desPadding = const EdgeInsets.all(24).copyWith(top: 12, right: 12);

    final List<Map<String, dynamic>> dataList = [
      {
        "title": "PLU Code",
        "description": (product.pluCode ?? 'None').toString()
      },
      {
        "title": "Item Code",
        "description": (product.itemCode ?? 'None').toString()
      },
      {
        "title": "Item Group",
        "description": (product.itemGroup ?? 'None').toString()
      },
      {
        "title": "On Hand Quantity",
        "description": (product.itemOnhand ?? 'None').toString()
      },
    ];

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: dataList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final Map<String, dynamic> data = dataList[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(data['title'], style: titleStyle),
                  Container(
                    padding: desPadding,
                    child: Text("\u25A0  ${data['description'].toString()}",
                        style: desStyle),
                  ),
                ],
              );
            }));
  }

  Widget buildSliverAppBar() {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider.value(
        value: prodDetViewmodel,
        child: Consumer<ProductDetailViewModel>(builder: (context, vm, child) {
          return SliverAppBar(
            pinned: true,
            expandedHeight:
                MediaQuery.of(context).size.width, // Aspect ratio 1:1
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              final isCollapsed = constraints.maxHeight <=
                  kToolbarHeight + MediaQuery.of(context).padding.top;
              late Product product;

              if (vm.isLoading) {
                product = mockProducts.first;
              } else if (vm.product == null) {
                return AppAlertView(
                    status: AppAlertType.noData, onRefresh: onRefresh);
              } else {
                product = vm.product!;
              }
              return SafeArea(
                child: Skeletonizer(
                  enabled: vm.isLoading,
                  child: Container(
                    color: isCollapsed ? colorScheme.surface : null,
                    child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: ImageCarousel(
                        images: product.imageUrl,
                        options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: false,
                            viewportFraction: 1,
                            aspectRatio: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false),
                        indicator: (product.imageUrl.length > 1)
                            ? CarouselIndicator(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                type: CslIndicatorType.counter,
                                alignment: Alignment.bottomRight)
                            : CarouselIndicator(),
                      ),
                    ),
                  ),
                ),
              );
            }),
            // backgroundColor: colorScheme.surface.withAlpha(500),
            actions: [
              ActionIconButton.of(context)
                  .search(withBackground: widget.wrapAppBarIcons),
              const SizedBox(width: 8),
              ActionIconButton.of(context).menu(
                  items: ['home', 'settings', 'notifications'],
                  withBackground: widget.wrapAppBarIcons),
            ],
          );
        }));
  }

  Widget buildSliverBasicDetails() {
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
          value: prodDetViewmodel,
          child:
              Consumer<ProductDetailViewModel>(builder: (context, vm, child) {
            late Product product;

            if (vm.isLoading) {
              product = mockProducts.first;
            } else if (vm.product == null) {
              return SizedBox.shrink();
            } else {
              product = vm.product!;
            }

            return Skeletonizer(
              enabled: vm.isLoading,
              child: Column(
                children: [
                  buildBasicDetails(product),
                  const SizedBox(height: 12),
                  buildRatingAndReviews(product),
                  const SizedBox(height: 12),
                  buildProductDetails(product),
                ],
              ),
            );
          })),
    );
  }

  Widget buildSliverTabBar() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: TabBarDelegate(
            ProductTabBar(onTap: onChangedTab, initialIndex: prodTabIndex)));
  }

  Widget buildSliverProducts() {
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
        value: prodCollViewmodel,
        child:
            Consumer<ProductCollectionViewmodel>(builder: (context, vm, child) {
          final currentProducts = vm.getCurrentDataModel(prodTabIndex).data;

          if (!vm.isLoading && currentProducts.isEmpty) {
            return AppAlertView(
                status: AppAlertType.noData, onRefresh: onRefresh);
          }

          return Container(
            padding: const EdgeInsets.all(12),
            child: ProductMasonryGridViewBuilder(
              items: vm.isLoading ? mockProducts : currentProducts,
              onTapItem: (i, data) => vm.onTapProduct(data),
              enableSkeletonizer: vm.isLoading,
            ),
          );
        }),
      ),
    );
  }

  /*List<Widget> buildSliverProductDetails() {
    final colorScheme = Theme.of(context).colorScheme;

    return [ChangeNotifierProvider.value(
      value:  prodDetViewmodel,
      child: Consumer<ProductDetailViewModel>(builder: (context, vm, child) {
        late Product product;

        if(vm.isLoading){
          product = mockProducts.first;
        } else if(vm.product == null){
          return SliverToBoxAdapter(
            child: CustomError(
              message: 'No more data',
              onRefresh: onRefresh,
              aspectRatio: 1,
            ),
          );
        } else {
          product = vm.product!;
        }

        return SliverList(delegate: SliverChildListDelegate(
            [
              SliverAppBar(
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.width, // Aspect ratio 1:1
                flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCollapsed = constraints.maxHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;

                      return Skeletonizer(
                        enabled: vm.isLoading,
                        child: Container(
                          color: isCollapsed ? colorScheme.surface : null,
                          child: FlexibleSpaceBar(
                            background: ImageCarousel(
                              images: product.imageUrl,
                              options: CarouselOptions(
                                  autoPlay: false,
                                  enlargeCenterPage: false,
                                  viewportFraction: 1,
                                  aspectRatio: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: false
                              ),
                              indicator: (product.imageUrl.length > 1) ? CarouselIndicator(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  type: CslIndicatorType.counter,
                                  alignment: Alignment.bottomRight) : CarouselIndicator(),
                            ),
                          ),
                        ),
                      );
                    }
                ),
                // backgroundColor: colorScheme.surface.withAlpha(500),
                actions: [
                  ActionIconButton.of(context).search(withBackground: widget.wrapAppBarIcons),
                  const SizedBox(width: 8),
                  ActionIconButton.of(context).menu(withBackground: widget.wrapAppBarIcons),
                ],
              ),
              const SizedBox(height: 12),
              buildBasicDetails(product),
              const SizedBox(height: 12),
              buildRatingAndReviews(product),
              const SizedBox(height: 12),
              buildProductDetails(product),
            ]
        ));
      }),
    )];
  }*/

  /*Container(
    color: colorScheme.surface,
    child: Column(
      children: [
        // 1. TopImage
        ImageCarousel(
          images: product.imageUrl,
          options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: false,
              viewportFraction: 1,
              aspectRatio: 1,
              initialPage: 0,
              enableInfiniteScroll: false
          ),
          indicator: (product.imageUrl.length > 1) ? CarouselIndicator(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20)),
              type: CslIndicatorType.counter,
              alignment: Alignment.bottomRight) : CarouselIndicator(),
        ),
        const SizedBox(height: 12),
        // 2. scroll after pinned
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    product.highlightedPriceStr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                        height: 1),
                  ),
                  (product.lineThroughPriceStr != null)
                      ? Text(
                    product.lineThroughPriceStr!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                        color: Colors.grey,
                        decoration: TextDecoration
                            .lineThrough,
                        decorationColor:
                        Colors.grey,
                        height: 1.2),
                  )
                      : const SizedBox.shrink(),
                  (product.discountPct > 0 &&
                      product.discountPct < 100)
                      ? Material(
                    type: MaterialType.canvas,
                    color:  vm.isLoading ? Colors.transparent : colorScheme.secondary.withAlpha(50),
                    clipBehavior: Clip.hardEdge,
                    borderRadius:
                    BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        "-${product.discountPct}%",
                        style: TextStyle(
                            color:
                            colorScheme.secondary),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                product.itemDesc ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.star,
                          color: Colors.orangeAccent, size: 20),
                      const SizedBox(width: 4),
                      Text(
                          "${product.averageRating.toStringAsFixed(1)} (${product.totalReviews})"),
                    ],
                  ),
                  Row(
                    children: [
                      // IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: const Icon(Icons.share)),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),*/

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
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: colorScheme.surface.withAlpha(0),
        //   actions: [
        //     ActionIconButton.of(context).search(withBackground: widget.wrapAppBarIcons),
        //     const SizedBox(width: 8),
        //     ActionIconButton.of(context).menu(withBackground: widget.wrapAppBarIcons),
        //   ],
        // ),
        body: SmartRefresher(
          scrollController: _scrollController,
          enablePullDown: true,
          enablePullUp: true,
          enableTwoLevel: false,
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
          onLoading: onLoading,
          child: CustomScrollView(
            slivers: [
              // SliverAppBar(
              //   pinned: true,
              //   expandedHeight: MediaQuery.of(context).size.width, // Aspect ratio 1:1
              //   flexibleSpace: LayoutBuilder(
              //       builder: (context, constraints) {
              //         final isCollapsed = constraints.maxHeight <= kToolbarHeight + MediaQuery.of(context).padding.top;
              //
              //         return Skeletonizer(
              //           enabled: vm.isLoading,
              //           child: Container(
              //             color: isCollapsed ? colorScheme.surface : null,
              //             child: FlexibleSpaceBar(
              //               background: ImageCarousel(
              //                 images: product.imageUrl,
              //                 options: CarouselOptions(
              //                     autoPlay: false,
              //                     enlargeCenterPage: false,
              //                     viewportFraction: 1,
              //                     aspectRatio: 1,
              //                     initialPage: 0,
              //                     enableInfiniteScroll: false
              //                 ),
              //                 indicator: (product.imageUrl.length > 1) ? CarouselIndicator(
              //                     shape: RoundedRectangleBorder(
              //                         borderRadius:
              //                         BorderRadius.circular(20)),
              //                     type: CslIndicatorType.counter,
              //                     alignment: Alignment.bottomRight) : CarouselIndicator(),
              //               ),
              //             ),
              //           ),
              //         );
              //       }
              //   ),
              //   // backgroundColor: colorScheme.surface.withAlpha(500),
              //   actions: [
              //     ActionIconButton.of(context).search(withBackground: widget.wrapAppBarIcons),
              //     const SizedBox(width: 8),
              //     ActionIconButton.of(context).menu(withBackground: widget.wrapAppBarIcons),
              //   ],
              // ),
              // ...buildSliverProductDetails(),
              buildSliverAppBar(),
              buildSliverBasicDetails(),
              buildSliverTabBar(),
              buildSliverProducts(),
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
      ),
    );
  }
}
