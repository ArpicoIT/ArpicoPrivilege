import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../app/app.dart';
import '../../app/app_routes.dart';
import '../../data/models/product.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/tab_bar.dart';
import '../../shared/enum.dart';
import '../../shared/widgets/app_alert.dart';
import '../../shared/customize/custom_error.dart';
import '../../shared/components/cards/product_card.dart';
import '../../viewmodels/products/product_viewmodel.dart';
import '../search.dart';

class ProductTabBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int index) onTap;
  final int initialIndex;

  const ProductTabBar({super.key, required this.onTap, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ProductTypes.values.length,
      initialIndex: initialIndex,
      child: PrimaryTabBar(
          onTap: onTap,
          items: ProductTypes.values
              .map((e) => TabItem(e.label, e.iconData))
              .toList()),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}

class ProductCenterView extends StatefulWidget {
  const ProductCenterView({super.key});

  @override
  State<ProductCenterView> createState() => _ProductCenterViewState();
}

class _ProductCenterViewState extends State<ProductCenterView> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;

  late ProductCollectionViewmodel productViewmodel;

  int prodTabIndex = 0;
  String searchKey = '';

  @override
  void initState() {
    // initialize view models
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // // load again products if searchKey not empty
      // if(_context.mounted && (searchKey??"").isNotEmpty && products.isEmpty){
      //   searchKey = "";
      //   await loadProducts();
      //   showInitialSearchAlert = true;
      // }

      setState(() {
        searchKey =
            (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
      });

      productViewmodel.setSearchKey(searchKey);
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

  void onClearSearchField() async {
    setState(() {
      searchKey = '';
    });
    productViewmodel.setSearchKey('');
    productViewmodel.loadInitialProducts(prodTabIndex);
  }

  void onTapSearchField() {
    String? previousRoute = RouteObserverService.previousRoute;
    if (previousRoute == AppRoutes.search) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.search);
    }
  }

  Widget buildSearchField() {
    return SearchField(
      onSearch: (String value) {},
      readOnly: true,
      hasSearchButton: false,
      hintText: "Looking for something?",
      initialValue: searchKey,
      onTap: onTapSearchField,
      onClear: (value) => onClearSearchField(),
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
        value: productViewmodel,
        child: Consumer<ProductCollectionViewmodel>(builder: (context, vm, child) {
          final currentProducts = vm.getCurrentDataModel(prodTabIndex).data;

          if (!vm.isLoading && currentProducts.isEmpty) {
            return AppAlertView(
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: buildSearchField(),
        titleSpacing: 0,
        actions: [
          ActionIconButton.of(context).menu(
              items: ['home', 'settings', 'notifications']),
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

// class ProductCenter extends StatefulWidget {
//   const ProductCenter({super.key});
//
//   /*static Widget buildTabBar(BuildContext context, {
//     required Function(int index) onTap,
//     int initialIndex = 0
//   }) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Container(
//       color: colorScheme.surface,
//       child: DefaultTabController(
//         length: 4,
//         initialIndex: initialIndex,
//         child: TabBar(
//           labelStyle: TextStyle(
//               color: colorScheme.onSurface,
//               fontSize: 16,
//               fontWeight: FontWeight.bold),
//           unselectedLabelStyle: TextStyle(
//               color: colorScheme.onSurfaceVariant,
//               fontSize: 16,
//               fontWeight: FontWeight.w500),
//           isScrollable: true,
//           tabAlignment: TabAlignment.start,
//           dividerHeight: 0,
//           tabs: [
//             _tabItem("All", null),
//             _tabItem("Deals", Icons.flash_on),
//             _tabItem("Top Rated", Icons.star),
//             _tabItem("New Arrivals", Icons.new_label_rounded),
//           ],
//           // onTap: (i) => viewmodel.tabIndex = i,
//           onTap: onTap,
//         ),
//       ),
//     );
//   }*/
//
//   /*@protected
//   static Widget _tabItem(String text, IconData? iconData){
//     return Tab(
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if(iconData != null) ...[
//             Icon(iconData),
//             const SizedBox(width: 8),
//           ],
//           Text(text),
//         ],
//       ),
//     );
//   }*/
//
//   @override
//   State<ProductCenter> createState() => _ProductCenterState();
// }
//
// class _ProductCenterState extends State<ProductCenter> {
//   // functions
//   void _onTapProduct(BuildContext context, Product item) async {
//     item = await Navigator.of(context).pushNamed(AppRoutes.productDetails, arguments: item) as Product? ?? item;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return ChangeNotifierProvider(
//       create: (context) => ProductCenterViewmodel()..setContext(context),
//       child: Consumer<ProductCenterViewmodel>(
//         builder: (context, viewmodel, child) {
//           return Scaffold(
//             backgroundColor: colorScheme.surfaceContainerLow,
//             appBar: AppBar(
//               title: SearchField(
//                 onSearch: (String value) {},
//                 readOnly: true,
//                 hasSearchButton: false,
//                 hintText: "Looking for something?",
//                 initialValue: viewmodel.searchKey,
//                 onTap: ()=> viewmodel.onTapSearchField(context),
//                 onClear: (value)=> viewmodel.onClearSearchField(),
//               ),
//               titleSpacing: 0,
//               actions: [
//                 ActionIconButton.menu(context),
//               ],
//               // bottom: PreferredSize(
//               //     preferredSize: Size(double.infinity, 48),
//               //     child: buildTabBar(context, onTap: viewmodel.setTabIndex)),
//             ),
//             body: Column(
//               children: [
//                 ProductCenter.buildTabBar(context, onTap: viewmodel.setTabIndex),
//                 Expanded(
//                   child: SmartRefresher(
//                     scrollController: viewmodel.scrollController,
//                     enablePullDown: true,
//                     enablePullUp: true,
//                     enableTwoLevel: false,
//                     header: const MaterialClassicHeader(),
//                     footer: CustomFooter(
//                       builder: (BuildContext context, LoadStatus? mode) {
//                         if (mode == LoadStatus.loading) {
//                           return const CupertinoActivityIndicator();
//                         }
//                         return const SizedBox.shrink();
//                       },
//                     ),
//                     controller: viewmodel.refreshController,
//                     onRefresh: viewmodel.onRefresh,
//                     onLoading: viewmodel.onLoading,
//                     child: SingleChildScrollView(
//                       controller: viewmodel.scrollController,
//                       child: Padding(
//                         padding: const EdgeInsets.all(12).copyWith(bottom: 0),
//                         child: Column(
//                           children: [
//                             if(viewmodel.showInitialSearchAlert)
//                               ...[
//                                 NotificationAlert(
//                                   type: NotificationType.info,
//                                   message: "Oops! No products match your search, but here are some similar options.",
//                                   onCancel: viewmodel.onCancelSearchAlert,
//                                 ),
//                                 const SizedBox(height: 16)
//                               ],
//
//                             ProductMasonryGridViewBuilder(
//                               items: viewmodel.tabProducts,
//                               onTapItem: (i, data) => _onTapProduct(context, data),
//                             ),
//
//                             // if(!viewmodel.hasMoreData)
//                             //   ...[
//                             //     const SizedBox(height: 16),
//                             //     PrimaryButton(text: "Refresh", icon: Icons.refresh, onPressed: (){}),
//                             //   ],
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       ),
//     );
//   }
// }
