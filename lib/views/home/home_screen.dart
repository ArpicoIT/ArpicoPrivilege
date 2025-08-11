import 'package:arpicoprivilege/shared/customize/custom_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_consts.dart';
import '../../data/models/product.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/tab_bar.dart';
import '../../shared/widgets/app_alert.dart';
import '../../viewmodels/products/product_viewmodel.dart';
import '../../viewmodels/promotions/promotion_viewmodel.dart';
import '../products/product_center.dart';
import '../../app/app_routes.dart';
import '../../shared/components/app_name.dart';
import '../../shared/components/carousel/carousel_item_builder.dart';
import '../../data/models/promotion.dart';
import '../../shared/components/image_with_placeholder.dart';
import '../../shared/components/cards/product_card.dart';
import 'face_capture.dart';

/// v 1.1
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;

  // late HomeViewmodel viewmodel;
  late PromotionCollectionViewmodel promotionViewmodel;
  late ProductCollectionViewmodel productViewmodel;

  @override
  bool get wantKeepAlive => keepAppHomeState; // Ensures state is kept alive

  int prodTabIndex = 0;
  final int promTabIndex = 1;

  @override
  void initState() {
    // initialize view models
    promotionViewmodel = PromotionCollectionViewmodel()
      ..setContext(context)
      ..setLoading(true);

    productViewmodel = ProductCollectionViewmodel()
      ..setContext(context)
      ..setLoading(true);

    // initialize controllers
    _refreshController = RefreshController();
    _scrollController = ScrollController();

    // initialize notifiers
    _showScrollUpBtn = ValueNotifier<bool>(false);

    // initialize listeners
    _scrollController.addListener(_updateScrollUpButtonVisibility);

    // initialize cached data
    // viewmodel.initializeCachedPromotions();
    // viewmodel.initializeCachedProducts();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      promotionViewmodel.loadInitialPromotions(promTabIndex);
      productViewmodel.loadInitialProducts(prodTabIndex);
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

    if (productViewmodel.getCurrentDataModel(i).data.isEmpty) {
      await productViewmodel.loadInitialProducts(i);
    }
  }

  // smart refresher functions
  void onRefresh() async {
    try {
      await promotionViewmodel.refreshPromotions(promTabIndex);
      await productViewmodel.refreshProducts(prodTabIndex);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void onLoading() async {
    try {
      await productViewmodel.loadMoreProducts(prodTabIndex);
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  // builders
  Widget buildSliverTabBar() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: TabBarDelegate(
            ProductTabBar(onTap: onChangedTab, initialIndex: prodTabIndex)));
  }

  Widget buildSliverPromotions() {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Container(
        color: colorScheme.surface,
        child: ChangeNotifierProvider.value(
          value: promotionViewmodel,
          child: Consumer<PromotionCollectionViewmodel>(builder: (context, vm, child) {
            final isLoading = vm.isLoading;

            if (isLoading) {
              return Skeletonizer(
                enabled: isLoading,
                child: Skeleton.leaf(
                    enabled: isLoading,
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: AspectRatio(aspectRatio: 2),
                    )),
              );
            }

            if (vm.getCurrentDataModel(promTabIndex).data.isEmpty) {
              return SizedBox.shrink();
              // return AppAlertView(
              //     status: AppAlertType.empty,
              //     onRetry: onRefresh
              // );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CarouselItemBuilder<Promotion>(
                items: vm.getCurrentDataModel(promTabIndex).data,
                onTap: vm.onTapPromotion,
                builder: (context, item, child) {
                  return Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.zero,
                    child: ImageWithPlaceholder(
                      item.imageUrl.isNotEmpty ? item.imageUrl.first : "",
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.95,
                  aspectRatio: 2,
                  initialPage: 0,
                ),
                indicator: const CarouselIndicator(
                  type: CslIndicatorType.dots,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildSliverProducts() {
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
        value: productViewmodel,
        child: Consumer<ProductCollectionViewmodel>(builder: (context, vm, child) {
          final currentProducts = vm.getCurrentDataModel(prodTabIndex).data;

          if (!vm.isLoading && currentProducts.isEmpty) {
            return AppAlertView(
              aspectRatio: 1,
              // key: ValueKey('value'),
              status: AppAlertType.noData,
              onRefresh: onRefresh
            );
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: Call super.build to apply mixin
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: AppName(appNameSize: 24),
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: Icon(Icons.menu)), // grid_view_outlined
        actions: [
          ActionIconButton.of(context).search(),
          ActionIconButton.of(context).notification(),
          // IconButton(onPressed: ()=> Navigator.of(context).pushNamed(AppRoutes.testRoute), icon: Icon(Icons.navigate_next)),

          // IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => FaceCaptureScreen()));}, icon: Icon(Icons.qr_code_scanner))
        ],
      ),
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
            buildSliverPromotions(),
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
    );
  }
}

/// v1.0
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => HomeScreenState();
// }
//
// class HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   late RefreshController _refreshController;
//   late ScrollController _scrollController;
//   late ValueNotifier<bool> _showScrollUpBtn;
//   late ValueNotifier<bool> _tabBarVisibleNotifier;
//   late ValueNotifier<int> _selectedProductGroupIndex;
//
//   late HomeViewmodel viewmodel;
//
//   final GlobalKey _productGroupTabBarKey = GlobalKey();
//
//   @override
//   bool get wantKeepAlive => keepAppHomeState; // Ensures state is kept alive
//
//   @override
//   void initState() {
//     // initialize view models
//     viewmodel = HomeViewmodel()..setContext(context);
//
//     // initialize controllers
//     _refreshController = RefreshController();
//     _scrollController = ScrollController();
//
//     // initialize notifiers
//     _showScrollUpBtn = ValueNotifier<bool>(false);
//     _tabBarVisibleNotifier = ValueNotifier<bool>(false);
//     _selectedProductGroupIndex = ValueNotifier<int>(0);
//
//     // initialize listeners
//     _scrollController.addListener(_updateScrollUpButtonVisibility);
//     _scrollController.addListener(_updateTabBarVisibility);
//
//     // initialize cached data
//     viewmodel.initializeCachedPromotions();
//     viewmodel.initializeCachedProducts();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializing();
//     });
//
//     super.initState();
//   }
//
//   // initializing function
//   void _initializing() async {
//     /// start page loading
//     await viewmodel.loadAndCachePromotions();
//     await viewmodel.loadAndCacheProducts();
//     /// end page loader
//   }
//
//   // helper functions
//   void _updateScrollUpButtonVisibility() {
//     bool value = _showScrollUpBtn.value;
//     final double minScrollChanging = MediaQuery.of(context).size.width * 0.5;
//
//     if (_scrollController.offset > minScrollChanging && !value) {
//       _showScrollUpBtn.value = !value;
//     } else if (_scrollController.offset <= minScrollChanging && value) {
//       _showScrollUpBtn.value = !value;
//     }
//   }
//
//   void _updateTabBarVisibility() {
//     final box = _productGroupTabBarKey.currentContext?.findRenderObject() as RenderBox;
//     final position = box.localToGlobal(Offset.zero).dy;
//     _tabBarVisibleNotifier.value =
//         position <= kToolbarHeight + MediaQuery.of(context).viewPadding.top;
//   }
//
//   // button functions
//   void _onScrollToTop() {
//     _scrollController.animateTo(
//       0,
//       duration: Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   // smart refresher functions
//   void _onRefresh() async {
//     await viewmodel.refreshAndCachePromotions();
//     await viewmodel.refreshAndCacheProducts();
//     _refreshController.refreshCompleted();
//   }
//
//   void _onLoading() async {
//     await viewmodel.loadAndCacheProducts();
//     _refreshController.loadComplete();
//   }
//
//   // builders
//   /*Widget buildPromotionsOld() {
//     final activePromos = viewmodel.promotions.where((e) => e.proStatus == "ACT").toList();
//
//     if (activePromos.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       color: Theme.of(context).colorScheme.surface,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           // Positioned.fill(
//           //     child: ValueListenableBuilder(
//           //         valueListenable: viewmodel.promoColorNotifier,
//           //         builder: (context, color, child) {
//           //           return AnimatedContainer(
//           //             duration: Duration(
//           //                 milliseconds: 500), // Adjust duration for smoothness
//           //             curve: Curves.easeInOut, // Smooth easing animation
//           //             color: color,
//           //           );
//           //         })),
//           CarouselItemBuilder<Promotion>(
//             items: activePromos,
//             onTap: viewmodel.onTapPromotion,
//             // onChangedItem: (item) {
//             // final color =  _getPromoColor(context, item.imageUrl.first);
//             // _promoColorNotifier.value = color;
//             // },
//             builder: (context, item, child) {
//               return Card(
//                 elevation: 0,
//                 // margin: EdgeInsets.only(bottom: 30),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 child: ImageWithPlaceholder(
//                   item.imageUrl.isNotEmpty ? item.imageUrl.first : "",
//                   // placeAssetPath: "assets/images/super-centre-placeholder.jpg"
//                 ),
//               );
//             },
//             options: CarouselOptions(
//               autoPlay: true,
//               enlargeCenterPage: true,
//               viewportFraction: 0.95,
//               aspectRatio: 2,
//               initialPage: 0,
//             ),
//             indicator: const CarouselIndicator(
//               type: CslIndicatorType.dots,
//             ),
//           ),
//         ],
//       ),
//     );
//   }*/
//
//   Widget buildPromotions() {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Shimmer.fromColors(
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 12),
//         child: AspectRatio(aspectRatio: 2),
//       ),
//       baseColor: colorScheme.surfaceContainerLow,
//       highlightColor: colorScheme.surface,
//     );
//
//     if (viewmodel.activePromos.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       color: Theme.of(context).colorScheme.surface,
//       child: CarouselItemBuilder<Promotion>(
//         items: viewmodel.activePromos,
//         onTap: viewmodel.onTapPromotion,
//         builder: (context, item, child) {
//           return Card(
//             elevation: 0,
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             margin: EdgeInsets.zero,
//             child: ImageWithPlaceholder(
//               item.imageUrl.isNotEmpty ? item.imageUrl.first : "",
//             ),
//           );
//         },
//         options: CarouselOptions(
//           autoPlay: true,
//           enlargeCenterPage: true,
//           viewportFraction: 0.95,
//           aspectRatio: 2,
//           initialPage: 0,
//         ),
//         indicator: const CarouselIndicator(
//           type: CslIndicatorType.dots,
//         ),
//       ),
//     );
//   }
//
//   Widget buildProducts() {
//     // if (viewmodel.products.isEmpty) {
//     //   return const SizedBox.shrink();
//     // }
//
//     return Container(
//       constraints: BoxConstraints(
//           minHeight: MediaQuery.of(context).size.height
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           ValueListenableBuilder(
//             key: _productGroupTabBarKey,
//             valueListenable: _tabBarVisibleNotifier,
//             builder: (context, value, child) {
//               if (!value) {
//                 return child!;
//               }
//               return const SizedBox(height: 48);
//             },
//             child: buildProductGroupsTabBar(),
//           ),
//           if (viewmodel.products.isNotEmpty)
//             ...[
//               const SizedBox(height: 16),
//               ValueListenableBuilder(
//                   valueListenable: _selectedProductGroupIndex,
//                   builder: (context, value, child) => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: ProductItemsBuilder(
//                       items: viewmodel.productsByTab(value),
//                       onTapItem: (i, data) => viewmodel.onTapProduct(data),
//                     ),
//                   )
//               ),
//             ]
//
//         ],
//       ),
//     );
//   }
//
//   Widget buildProductGroupsTabBar() {
//     return ValueListenableBuilder(
//         valueListenable: _selectedProductGroupIndex,
//         builder: (context, value, child) => ProductCenter.buildTabBar(
//             context,
//             onTap: (i) => _selectedProductGroupIndex.value = i,
//             initialIndex: value
//         )
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // Important: Call super.build to apply mixin
//     final colorScheme = Theme.of(context).colorScheme;
//
//     // return MultiProvider(
//     //   providers: [
//     //     ChangeNotifierProvider(create: (context) => viewmodel),
//     //     ChangeNotifierProvider(create: (context) => viewmodel),
//     //   ],
//     //   builder: (context, child){
//     //     viewmodel = Provider.of<HomeViewmodel>(context);
//     //
//     //     return Scaffold(
//     //       backgroundColor: colorScheme.surfaceContainerLowest,
//     //       appBar: AppBar(
//     //         title: AppName(appNameSize: 24),
//     //         automaticallyImplyLeading: false,
//     //         elevation: 0,
//     //         leading: IconButton(
//     //             onPressed: () =>
//     //                 Navigator.of(context).pushNamed(AppRoutes.accountSettings),
//     //             icon: Icon(Icons.grid_view_outlined)),
//     //         actions: [
//     //           ActionIconButton.search(context),
//     //           ActionIconButton.notification(context),
//     //           // ActionIconButton.menu(context),
//     //           // IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => FaceCaptureScreen()));}, icon: Icon(Icons.qr_code_scanner))
//     //         ],
//     //       ),
//     //       body: Stack(
//     //         children: [
//     //           SmartRefresher(
//     //             scrollController: _scrollController,
//     //             enablePullDown: true,
//     //             enablePullUp: true,
//     //             enableTwoLevel: false,
//     //             header: const MaterialClassicHeader(),
//     //             footer: CustomFooter(
//     //               builder: (BuildContext context, LoadStatus? mode) {
//     //                 if (mode == LoadStatus.loading) {
//     //                   return const CupertinoActivityIndicator();
//     //                 }
//     //                 return const SizedBox.shrink();
//     //               },
//     //             ),
//     //             controller: _refreshController,
//     //             onRefresh: _onRefresh,
//     //             onLoading: _onLoading,
//     //             child: SingleChildScrollView(
//     //               // controller: viewmodel.scrollController,
//     //               child: Column(
//     //                 children: [
//     //                   buildPromotions(),
//     //                   buildProducts(),
//     //                 ],
//     //               ),
//     //             ),
//     //           ),
//     //           ValueListenableBuilder(
//     //             valueListenable: _tabBarVisibleNotifier,
//     //             builder: (context, value, child) {
//     //               if (value) {
//     //                 return child!;
//     //               }
//     //               return const SizedBox();
//     //             },
//     //             child: buildProductGroupsTabBar(),
//     //           ),
//     //         ],
//     //       ),
//     //       floatingActionButton: ValueListenableBuilder<bool>(
//     //           valueListenable: _scrollUpVisibleNotifier,
//     //           builder: (context, value, child) {
//     //             if (!value) {
//     //               return const SizedBox.shrink();
//     //             }
//     //             return FloatingActionButton.small(
//     //               onPressed: _onScrollToTop,
//     //               tooltip: "Scroll Up",
//     //               child: Icon(Icons.keyboard_arrow_up_sharp),
//     //             );
//     //           }),
//     //     );
//     //
//     //     return Container();
//     //   },
//     // );
//
//     // return PageAlert(key: ValueKey("internalServerError"), onConfirm: (){
//     //   super.reassemble();
//     // },);
//
//     return ChangeNotifierProvider(
//       create: (context) => viewmodel,
//       builder: (context, child) {
//         viewmodel = Provider.of<HomeViewmodel>(context);
//
//         return Scaffold(
//           backgroundColor: colorScheme.surfaceContainerLowest,
//           appBar: AppBar(
//             title: AppName(appNameSize: 24),
//             automaticallyImplyLeading: false,
//             elevation: 0,
//             leading: IconButton(
//                 onPressed: () =>
//                     Navigator.of(context).pushNamed(AppRoutes.settings),
//                 icon: Icon(Icons.menu)), // grid_view_outlined
//             actions: [
//               ActionIconButton.search(context),
//               ActionIconButton.notification(context),
//               // IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => FaceCaptureScreen()));}, icon: Icon(Icons.qr_code_scanner))
//             ],
//           ),
//           body: Stack(
//             children: [
//               SmartRefresher(
//                 scrollController: _scrollController,
//                 enablePullDown: true,
//                 enablePullUp: true,
//                 enableTwoLevel: false,
//                 header: const MaterialClassicHeader(),
//                 footer: CustomFooter(
//                   builder: (BuildContext context, LoadStatus? mode) {
//                     if (mode == LoadStatus.loading) {
//                       return const CupertinoActivityIndicator();
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//                 controller: _refreshController,
//                 onRefresh: _onRefresh,
//                 onLoading: _onLoading,
//                 child: SingleChildScrollView(
//                   // controller: viewmodel.scrollController,
//                   child: Column(
//                     children: [
//                       buildPromotions(),
//                       buildProducts(),
//                     ],
//                   ),
//                 ),
//               ),
//               ValueListenableBuilder(
//                 valueListenable: _tabBarVisibleNotifier,
//                 builder: (context, value, child) {
//                   if (value) {
//                     return child!;
//                   }
//                   return const SizedBox();
//                 },
//                 child: buildProductGroupsTabBar(),
//               ),
//             ],
//           ),
//           floatingActionButton: ValueListenableBuilder<bool>(
//               valueListenable: _showScrollUpBtn,
//               builder: (context, value, child) {
//                 if (!value) {
//                   return const SizedBox.shrink();
//                 }
//                 return FloatingActionButton.small(
//                   onPressed: _onScrollToTop,
//                   tooltip: "Scroll Up",
//                   child: Icon(Icons.keyboard_arrow_up_sharp),
//                 );
//               }),
//         );
//       },
//     );
//   }
// }

/*class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  late PromotionCenterViewmodel promoVm;
  late ProductViewmodel prodVm;

  final ValueNotifier<String> curPromoImageNotifier = ValueNotifier<String>('');
  final ValueNotifier<Color?> _promoColorNotifier = ValueNotifier<Color?>(null);
  final ValueNotifier<bool> _scrollNotifier = ValueNotifier<bool>(false);

  List<Map<String, dynamic>> promoColors = [];

  @override
  bool get wantKeepAlive => false; // Ensures state is kept alive

  @override
  void initState() {
    /// initialize viewmodels
    promoVm = PromotionFactory();
    prodVm = ProductViewmodel();

    super.initState();

    _scrollController.addListener(() {
      final bool value = _scrollNotifier.value;
      final double minScrollChanging = MediaQuery.of(context).size.width * 0.5;

      if (_scrollController.offset > minScrollChanging && !value) {
        _scrollNotifier.value = !value;
      }
      if (_scrollController.offset <= minScrollChanging && value) {
        _scrollNotifier.value = !value;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _initialize(context);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  Future<void> _initialize(BuildContext context) async {
    final loader = CustomLoader.of(context);

    if (context.mounted) {
      await loader.show();
    }
    if (context.mounted) {
      await promoVm.loadPromotions(context);
    }
    if (context.mounted) {
      await prodVm.loadProducts(context);
    }
    if (context.mounted) {
      await _setPromoColors();
    }
    if (context.mounted) {
      setState(() {});
      await loader.close();
    }
  }

  void _onRefresh(BuildContext context) async {
    /// refresh promotions
    if (context.mounted) {
      await promoVm.refreshPromotions(context);
    }

    /// refresh products
    if (context.mounted) {
      await prodVm.refreshProducts(context);
    }

    if (context.mounted) {
      await _setPromoColors();
    }

    /// if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading(BuildContext context) async {
    /// load products
    if (context.mounted) {
      // await prodVm.loadProducts(context);
    }

    /// if failed,use refreshFailed()
    _refreshController.loadComplete();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _setPromoColors() async {
    try {
      final List promoImages = promoVm.promotions
          .map((e) => e.imageUrl)
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();


      // Use Future.wait to handle async operations inside map()
      promoColors = await Future.wait(promoImages.map((e) async =>
          {"image": e, "color": await ImageHandler.getBackgroundColor(e)}));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Color _getPromoColor(BuildContext context, String image) {
    Color surface = Theme.of(context).colorScheme.surface;

    try {
      if (promoColors.isEmpty) {
        return surface;
      }

      return promoColors.firstWhere(
        (element) => element["image"] == image,
        orElse: () => {"color": surface}, // If not found, return null color
      )["color"];
    } catch (e) {
      debugPrint("Error finding color: $e");
      return surface;
    }
  }

  Widget buildPromotions(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PromotionCenterViewmodel(),
      builder: (context, child) {
        promoVm = Provider.of<PromotionCenterViewmodel>(context);

        if (promoVm.promotions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
                child: ValueListenableBuilder(
                    valueListenable: _promoColorNotifier,
                    builder: (context, color, child) {
                      return AnimatedContainer(
                        duration: Duration(
                            milliseconds:
                                500), // Adjust duration for smoothness
                        curve: Curves.easeInOut, // Smooth easing animation
                        color: color,
                      );
                    })),
            CarouselItemBuilder<Promotion>(
              items: promoVm.promotions,
              onTap: (item) async {
                await PromotionDetails.show(context, item);
              },
              // onChangedItem: (item) {
              // final color =  _getPromoColor(context, item.imageUrl.first);
              // _promoColorNotifier.value = color;
              // },
              builder: (context, item, child) {
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.only(bottom: 30),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: ImageWithPlaceholder(
                      item.imageUrl.isNotEmpty
                          ? item.imageUrl.first
                          : 'assets/images/super-centre-placeholder.jpg',
                      placeAssetPath:
                          "assets/images/super-centre-placeholder.jpg"),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.95,
                aspectRatio: 2,
                initialPage: 0,
              ),
              indicator: const CarouselIndicator(
                type: CslIndicatorType.dots,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildProducts(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => ProductViewmodel(),
      builder: (context, child) {
        prodVm = Provider.of<ProductViewmodel>(context);

        if (prodVm.products.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Text("Just For You",
                    style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            Container(
              padding: const EdgeInsets.all(12).copyWith(top: 0),
              child: ProductItemsBuilder(
                items: prodVm.products,
                onTapItem: (i, data) {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.productDescription, arguments: data);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildAnimatedAppBar(
      BuildContext context, Color? beginColor, Color? endColor) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: beginColor, end: endColor), // Smooth transition
      duration: Duration(milliseconds: 500),
      builder: (context, animatedColor, child) {
        Color? foregroundColor = (animatedColor == null)
            ? null
            : (animatedColor.computeLuminance() > 0.5)
                ? Colors.black // Light background → Dark text/icons
                : Colors.white; // Dark background → Light text/icons

        return AppBar(
          title: AppName(appNameSize: 24),
          automaticallyImplyLeading: false,
          // centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.accountSettings),
              icon: Icon(Icons.grid_view_outlined)),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.notifications),
                icon: const Icon(Icons.notifications_outlined))
          ],
          backgroundColor: animatedColor, // Animated color transition
          foregroundColor: foregroundColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: Call super.build to apply mixin
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: ValueListenableBuilder(
              valueListenable: _scrollNotifier,
              builder: (context, scroll, child) {
                if (scroll) {
                  return buildAnimatedAppBar(
                      context, _promoColorNotifier.value, colorScheme.surface);
                }

                return ValueListenableBuilder<Color?>(
                    valueListenable: _promoColorNotifier,
                    builder: (context, color, child) {
                      return buildAnimatedAppBar(context, colorScheme.surface,
                          color ?? colorScheme.surface);
                    });
              })),
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
        onRefresh: () => _onRefresh(context),
        onLoading: () => _onLoading(context),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              buildPromotions(context),
              buildProducts(context),
            ],
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _scrollNotifier,
          builder: (context, value, child) {
            if (!value) {
              return const SizedBox.shrink();
            }
            return FloatingActionButton.small(
              onPressed: () => _scrollToTop(),
              tooltip: "Scroll Up",
              child: Icon(Icons.keyboard_arrow_up_sharp),
            );
          }),
    );
  }
}*/

/*class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  late PromotionViewmodel promoVm;
  late ProductViewmodel prodVm;

  final ValueNotifier<String> curPromoImageNotifier = ValueNotifier<String>('');
  final ValueNotifier<Color?> _promoColorNotifier = ValueNotifier<Color?>(null);
  final ValueNotifier<bool> _scrollNotifier = ValueNotifier<bool>(false);

  List<Map<String, dynamic>> promoColors = [];

  @override
  bool get wantKeepAlive => false; // Ensures state is kept alive

  @override
  void initState() {
    /// initialize viewmodels
    promoVm = PromotionViewmodel();
    prodVm = ProductViewmodel();

    super.initState();

    _scrollController.addListener(() {
      final bool value = _scrollNotifier.value;
      final double minScrollChanging = MediaQuery.of(context).size.width * 0.5;

      if (_scrollController.offset > minScrollChanging && !value) {
        _scrollNotifier.value = !value;
      }
      if (_scrollController.offset <= minScrollChanging && value) {
        _scrollNotifier.value = !value;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _initialize(context);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  Future<void> _initialize(BuildContext context) async {
    final loader = CustomLoader.of(context);

    if (context.mounted) {
      await loader.show();
    }
    if (context.mounted) {
      await promoVm.loadPromotions(context);
    }
    if (context.mounted) {
      await prodVm.loadProducts(context);
    }
    if (context.mounted) {
      await _setPromoColors();
    }
    if (context.mounted) {
      setState(() {});
      await loader.close();
    }
  }

  void _onRefresh(BuildContext context) async {
    /// refresh promotions
    if (context.mounted) {
      await promoVm.refreshPromotions(context);
    }

    /// refresh products
    if (context.mounted) {
      await prodVm.refreshProducts(context);
    }

    if (context.mounted) {
      await _setPromoColors();
    }

    /// if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading(BuildContext context) async {
    /// load products
    if (context.mounted) {
      await prodVm.loadProducts(context);
    }

    /// if failed,use refreshFailed()
    _refreshController.loadComplete();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _setPromoColors() async {
    try {
      final List promoImages = promoVm.promotions
          .map((e) => e.imageUrl)
          .expand((e) => e)
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      // Use Future.wait to handle async operations inside map()
      promoColors = await Future.wait(
          promoImages.map((e) async => {
            "image": e,
            "color": await ImageHandler.getBackgroundColor(e)
          })
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Color _getPromoColor(BuildContext context, String image){
    Color surface = Theme.of(context).colorScheme.surface;

    try {
      if(promoColors.isEmpty){
        return surface;
      }

      return  promoColors.firstWhere((element) => element["image"] == image,
        orElse: () => {"color": surface}, // If not found, return null color
      )["color"];

    } catch (e) {
      debugPrint("Error finding color: $e");
      return surface;
    }

  }

  Widget buildPromotions(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PromotionViewmodel(),
      builder: (context, child) {
        promoVm = Provider.of<PromotionViewmodel>(context);

        if (promoVm.promotions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
                child: ValueListenableBuilder(
                    valueListenable: _promoColorNotifier,
                    builder: (context, color, child) {
                      return AnimatedContainer(
                        duration: Duration(
                            milliseconds:
                                500), // Adjust duration for smoothness
                        curve: Curves.easeInOut, // Smooth easing animation
                        color: color,
                      );
                    })),

            CarouselItemBuilder<Promotion>(
              items: promoVm.promotions,
              onTap: (item) async {
                await PromotionDetails.show(context, item);
              },
              // onChangedItem: (item) {
                // final color =  _getPromoColor(context, item.imageUrl.first);
                // _promoColorNotifier.value = color;
              // },
              builder: (context, item, child) {
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.only(bottom: 30),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: ImageWithPlaceholder(item.imageUrl.isNotEmpty ? item.imageUrl.first : 'assets/images/super-centre-placeholder.jpg', placeAssetPath: "assets/images/super-centre-placeholder.jpg"),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.95,
                aspectRatio: 2,
                initialPage: 0,
              ),
              indicator: const CarouselIndicator(
                type: CslIndicatorType.dots,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildProducts(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => ProductViewmodel(),
      builder: (context, child) {
        prodVm = Provider.of<ProductViewmodel>(context);

        if (prodVm.products.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Text("Just For You",
                    style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            Container(
              padding: const EdgeInsets.all(12).copyWith(top: 0),
              child: ProductItemsBuilder(
                items: prodVm.products,
                onTapItem: (i, data) {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.productDescription, arguments: data);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildAnimatedAppBar(BuildContext context, Color? beginColor, Color? endColor) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
          begin: beginColor, end: endColor), // Smooth transition
      duration: Duration(milliseconds: 500),
      builder: (context, animatedColor, child) {
        Color? foregroundColor = (animatedColor == null) ? null : (animatedColor.computeLuminance() > 0.5)
            ? Colors.black // Light background → Dark text/icons
            : Colors.white; // Dark background → Light text/icons

        return AppBar(
          title: AppName(appNameSize: 24),
          automaticallyImplyLeading: false,
          // centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.accountSettings),
              icon: Icon(Icons.grid_view_outlined)
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
                icon: const Icon(Icons.notifications_outlined))
          ],
          backgroundColor: animatedColor, // Animated color transition
          foregroundColor: foregroundColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: Call super.build to apply mixin
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: ValueListenableBuilder(
              valueListenable: _scrollNotifier,
              builder: (context, scroll, child){
                if(scroll){
                  return buildAnimatedAppBar(context, _promoColorNotifier.value, colorScheme.surface);
                }

                return ValueListenableBuilder<Color?>(
                    valueListenable: _promoColorNotifier,
                    builder: (context, color, child) {
                      return buildAnimatedAppBar(context, colorScheme.surface, color??colorScheme.surface);
                    });
              }
          )),

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
        onRefresh: () => _onRefresh(context),
        onLoading: () => _onLoading(context),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              buildPromotions(context),
              buildProducts(context),
            ],
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _scrollNotifier,
          builder: (context, value, child) {
            if (!value) {
              return const SizedBox.shrink();
            }
            return FloatingActionButton.small(
              onPressed: () => _scrollToTop(),
              tooltip: "Scroll Up",
              child: Icon(Icons.keyboard_arrow_up_sharp),
            );
          }),
    );
  }
}*/
