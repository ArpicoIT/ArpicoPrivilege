import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../core/constants/app_consts.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../data/models/promotion.dart';
import '../../shared/components/tab_bar.dart';
import '../../shared/enum.dart';
import '../../shared/widgets/app_alert.dart';
import '../../shared/customize/custom_error.dart';
import '../../shared/components/cards/promotion_card.dart';
import '../../viewmodels/promotions/promotion_viewmodel.dart';
import 'promotion_details.dart';

/// v1.1
class PromotionTabBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int index) onTap;
  final int initialIndex;

  const PromotionTabBar(
      {super.key, required this.onTap, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: PromotionTypes.values.length,
      initialIndex: initialIndex,
      child: PrimaryTabBar(
          onTap: onTap,
          items: PromotionTypes.values
              .map((e) => TabItem(e.label, e.iconData))
              .toList()),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}

class PromotionCenter extends StatefulWidget {
  const PromotionCenter({super.key});

  @override
  State<PromotionCenter> createState() => PromotionCenterState();
}

class PromotionCenterState extends State<PromotionCenter>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;

  late PromotionCollectionViewmodel promotionViewmodel;

  int promTabIndex = 0;

  @override
  bool get wantKeepAlive => keepAppHomeState;

  @override
  void initState() {
    // initialize view models
    promotionViewmodel = PromotionCollectionViewmodel()
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
      promotionViewmodel.loadInitialPromotions(promTabIndex);
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
      promTabIndex = i;
    });

    if (promotionViewmodel.getCurrentDataModel(i).data.isEmpty) {
      await promotionViewmodel.loadInitialPromotions(i);
    }
  }

  // smart refresher functions
  void onRefresh() async {
    try {
      await promotionViewmodel.refreshPromotions(promTabIndex);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void onLoading() async {
    try {
      await promotionViewmodel.loadMorePromotions(promTabIndex);
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  // builders

  // builders
  Widget buildSliverTabBar() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: TabBarDelegate(
            PromotionTabBar(onTap: onChangedTab, initialIndex: promTabIndex)));
  }

  Widget buildSliverPromotions() {
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider(
        create: (context) => promotionViewmodel,
        child: Consumer<PromotionCollectionViewmodel>(
            builder: (context, vm, child) {
          final currentPromotions = vm.getCurrentDataModel(promTabIndex).data;

          if (!vm.isLoading && currentPromotions.isEmpty) {
            return AppAlertView(
              aspectRatio: 1,
                status: AppAlertType.noData,
                onRefresh: onRefresh
            );
          }

          return Container(
            padding: const EdgeInsets.all(12),
            child: PromotionMasonryGridViewBuilder(
              items: vm.isLoading ? mockPromotions : currentPromotions,
              onTapItem: (i, data) => vm.onTapPromotion(data),
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
        title: Text("Arpico Promotions"), // Exclusive Promotions
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
            buildSliverPromotions(),
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
/*class PromotionCenter extends StatefulWidget {
  const PromotionCenter({super.key});

  @override
  State<PromotionCenter> createState() => PromotionCenterState();
}

class PromotionCenterState extends State<PromotionCenter>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _scrollUpVisibleNotifier;
  late ValueNotifier<InitializationState> _initializationNotifier;

  late PromotionCenterViewmodel viewmodel;

  @override
  bool get wantKeepAlive => keepAppHomeState;

  @override
  void initState() {
    // initialize view models
    viewmodel = PromotionCenterViewmodel()..setContext(context);

    // initialize controllers
    _refreshController = RefreshController();
    _scrollController = ScrollController();

    // initialize notifiers
    _scrollUpVisibleNotifier = ValueNotifier<bool>(false);
    _initializationNotifier = ValueNotifier<InitializationState>(InitializationState.waiting);

    // initialize listeners
    _scrollController.addListener(_scrollUpButtonVisible);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializing();
    });
    super.initState();
  }
  
  void _initializing() async {
    // final toast = CustomToast.of(context);
    final loader = CustomLoader.of(context);

    try {
      if (mounted) {
        await loader.show();
      }
      _setInitialization(InitializationState.waiting);
      if (mounted) {
        await viewmodel.loadPromotions();
      }
      _setInitialization(viewmodel.promotions.isNotEmpty ? InitializationState.success : InitializationState.noContent);
      if (mounted) {
        await loader.close();
      }
    } catch (e) {
      if (mounted) {
        await loader.close();
      }
      _setInitialization(InitializationState.notFound);
      // toast.showPrimary(e.toString());
    }
  }

  // helper functions
  void _setInitialization(InitializationState value) =>
      _initializationNotifier.value = value;

  void _scrollUpButtonVisible() {
    bool value = _scrollUpVisibleNotifier.value;
    final double minScrollChanging = MediaQuery.of(context).size.width * 0.5;

    if (_scrollController.offset > minScrollChanging && !value) {
      _scrollUpVisibleNotifier.value = !value;
    } else if (_scrollController.offset <= minScrollChanging && value) {
      _scrollUpVisibleNotifier.value = !value;
    }
  }

  // button functions
  void _onScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onRefresh() async {
    /// refresh promotions
    await viewmodel.refreshPromotions();

    /// if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    /// load promotions
    await viewmodel.loadPromotions();

    /// if failed,use refreshFailed()
    _refreshController.loadComplete();
  }

  // functions
  void _onTapPromotion(Promotion item) async {
    item = await Navigator.of(context)
        .pushNamed(AppRoutes.promotionDetails, arguments: item) as Promotion? ?? item;
  }

  // builders
  Widget buildLabeledChip(
    BuildContext context, {
    Function()? onTap,
    required IconData labelIcon,
    required String labelText,
    String? value,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStateColor.transparent,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(labelIcon, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(labelText, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPromotionCard(BuildContext context,
      {required Promotion promotion,
      Function(Promotion promotion)? onPressed,
      EdgeInsetsGeometry? padding}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color chipBackground;
    Color chipForeground;
    String chipText;
    bool enable;

    switch (promotion.proStatus) {
      case "ACT":
        chipBackground = Colors.orange;
        chipForeground = Colors.white;
        chipText = "More Details";
        enable = true;
        break;
      case "UPC":
        chipBackground = Colors.blue;
        chipForeground = Colors.white;
        chipText = "Upcoming";
        enable = true;
        break;
      case "EXP":
        chipBackground = Colors.grey;
        chipForeground = Colors.white;
        chipText = "Expired";
        enable = false;
        break;
      default:
        chipBackground = Colors.grey;
        chipForeground = Colors.white;
        chipText = "More Details";
        enable = false;
        break;
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: CustomBorderContainer(
        borderColor: colorScheme.outlineVariant.withAlpha(100),
        borderRadius: 12,
        strokeWidth: 4,
        isDotted: !enable,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.zero,
          elevation: 0,
          color: colorScheme.surface,
          child: InkWell(
            onTap: enable ? () => onPressed?.call(promotion) : null,
            child: Column(
              children: [
                AspectRatio(
                    aspectRatio: 2,
                    child: Builder(builder: (context) {
                      final Widget image = ImageWithPlaceholder(
                          promotion.imageUrl.isNotEmpty
                              ? promotion.imageUrl.first
                              : '');

                      if (enable) {
                        return image;
                      }

                      return ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation),
                        child: image,
                      );
                    })),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(promotion.proDescri ?? "",
                          style: textTheme.bodyLarge
                              ?.copyWith(color: enable ? null : Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 24,
                        runSpacing: 16,
                        children: [
                          (promotion.proStartDate != null)
                              ? buildLabeledChip(context,
                                  labelIcon: Icons.access_time,
                                  labelText: DateFormat('MMMM dd, yyyy').format(
                                      DateTime.parse(promotion.proStartDate!
                                          .toIso8601String())))
                              : const SizedBox.shrink(),
                          (promotion.proEndDate != null)
                              ? buildLabeledChip(context,
                                  labelIcon: Icons.access_time_filled,
                                  labelText: DateFormat('MMMM dd, yyyy').format(
                                      DateTime.parse(promotion.proEndDate!
                                          .toIso8601String())))
                              : const SizedBox.shrink(),
                        ],
                      ),
                      Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: AppText.promotionExpiryText(
                                  context, promotion.proEndDate!)),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () => onPressed?.call(promotion),
                              style: TextButton.styleFrom(
                                  backgroundColor: chipBackground,
                                  foregroundColor: chipForeground,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                              child: Text(chipText,
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // builders
  Widget buildTabBar(BuildContext context,
      {required Function(int index) onTap, int initialIndex = 0}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: DefaultTabController(
        length: 4,
        initialIndex: 1,
        child: TabBar(
          labelStyle: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerHeight: 0,
          tabs: [
            buildTabItem("All", null),
            // buildTabItem("Available", Icons.check_circle), //✅
            buildTabItem("Ongoing", Icons.play_circle ), //✅
            buildTabItem("Upcoming", Icons.schedule), //📅
            buildTabItem("Expired", Icons.history), //⏳
          ],
          onTap: onTap,
        ),
      ),
    );
  }

  Widget buildTabItem(String text, IconData? iconData) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) ...[
            Icon(iconData),
            const SizedBox(width: 8),
          ],
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: Call super.build to apply mixin

    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => viewmodel,
      builder: (context, child) {
        viewmodel = Provider.of<PromotionCenterViewmodel>(context);
        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest,
          appBar: AppBar(
            title: Text("Arpico Promotions"), // Exclusive Promotions
            actions: [
              ActionIconButton.menu(context),
            ],
          ),
          body: Builder(builder: (context) {
            return ValueListenableBuilder(
                valueListenable: _initializationNotifier,
                builder: (context, value, child) {
                  switch (value) {
                    case InitializationState.waiting:
                      return SizedBox.shrink();
                      return PageLoader();
                    case InitializationState.failed:
                      return PageAlert.body(
                          key: Key("notFound"), onConfirm: _initializing);
                    case InitializationState.notFound:
                      return PageAlert.body(
                          key: Key("notFound"), onConfirm: _initializing);
                    case InitializationState.noContent:
                      return PageAlert.body(
                          key: Key("emptyPromotions"),
                          onConfirm: _initializing);
                    case InitializationState.timeout:
                      return PageAlert.body(
                          key: Key("notFound"), onConfirm: _initializing);
                    case InitializationState.connectionError:
                      return PageAlert.body(
                          key: Key("connectionError"),
                          onConfirm: _initializing);
                    case InitializationState.success:
                      return Column(
                        children: [
                          buildTabBar(context, onTap: viewmodel.setTabIndex),
                          Expanded(
                            child: SmartRefresher(
                                scrollController: _scrollController,
                                enablePullDown: true,
                                enablePullUp: true,
                                header: const MaterialClassicHeader(),
                                footer: CustomFooter(
                                  builder:
                                      (BuildContext context, LoadStatus? mode) {
                                    if (mode == LoadStatus.loading) {
                                      return const CupertinoActivityIndicator();
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                child: ListView.builder(
                                    primary: false,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: viewmodel.promosByStatus.length,
                                    itemBuilder: (context, index) {
                                      final promotion =
                                          viewmodel.promosByStatus[index];

                                      return buildPromotionCard(context,
                                          promotion: promotion,
                                          onPressed: _onTapPromotion,
                                          padding: EdgeInsets.only(
                                              left: 16,
                                              top: (index == 0) ? 16 : 0,
                                              right: 16,
                                              bottom: 16));
                                    })),
                          ),
                        ],
                      );
                    case InitializationState.internalServerError:
                      // TODO: Handle this case.
                      throw UnimplementedError();
                  }
                });
          }),
          floatingActionButton: ValueListenableBuilder<bool>(
              valueListenable: _scrollUpVisibleNotifier,
              builder: (context, value, child) {
                if (!value) {
                  return const SizedBox.shrink();
                }
                return FloatingActionButton.small(
                  onPressed: _onScrollToTop,
                  tooltip: "Scroll Up",
                  child: Icon(Icons.keyboard_arrow_up_sharp),
                );
              }),
        );
      },
    );
  }
}*/

// class PromotionCenterState extends State<PromotionCenter>
//     with AutomaticKeepAliveClientMixin {
//   final RefreshController _refreshController = RefreshController();
//   final ScrollController _scrollController = ScrollController();
//   late PromotionViewmodel promoVm;
//
//   // final ValueNotifier<AppInitializing> initializing =
//   // ValueNotifier<AppInitializing>(AppInitializing.waiting);
//   final ValueNotifier<bool> _showScrollUpButton = ValueNotifier<bool>(false);
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     promoVm = PromotionViewmodel();
//     _scrollListener();
//     _initializing(context);
//     super.initState();
//   }
//
//   /// scroll functions
//   void _scrollListener() {
//     _scrollController.addListener(() {
//       bool value = _showScrollUpButton.value;
//       if (_scrollController.offset > 300 && !value) {
//         _showScrollUpButton.value = !value;
//       }
//       if (_scrollController.offset <= 300 && value) {
//         _showScrollUpButton.value = !value;
//       }
//     });
//   }
//
//   void _scrollToTop() {
//     _scrollController.animateTo(
//       0,
//       duration: Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _initializing(BuildContext context) async {
//     final loader = CustomLoader.of(context);
//     await loader.show();
//
//     if (context.mounted) {
//       await promoVm.onLoadPromotionCategories(context);
//     }
//     if (context.mounted) {
//       setState(() {});
//       await loader.close();
//     }
//   }
//
//   void _onRefresh(BuildContext context) async {
//     /// refresh promotions
//     await promoVm.onRefreshPromotionCategories(context);
//     /// if failed,use refreshFailed()
//     _refreshController.refreshCompleted();
//   }
//
//   void _onLoading(BuildContext context) async {
//     /// load promotions
//     await promoVm.onLoadPromotionCategories(context);
//     /// if failed,use refreshFailed()
//     _refreshController.loadComplete();
//   }
//
//   Widget buildLabeledChip(
//     BuildContext context, {
//     Function()? onTap,
//     required IconData labelIcon,
//     required String labelText,
//     String? value,
//   }) {
//     return Material(
//       type: MaterialType.transparency,
//       child: InkWell(
//         onTap: onTap,
//         overlayColor: WidgetStateColor.transparent,
//         child: Padding(
//           padding: EdgeInsets.zero,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(labelIcon, size: 18, color: Colors.grey),
//               const SizedBox(width: 8),
//               Text(labelText, style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget promotionCard(BuildContext context,
//       {required Promotion promotion,
//       Function(Promotion promotion)? onPressed,
//       EdgeInsetsGeometry? margin}) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Card(
//       margin: margin,
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       color: colorScheme.surface,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: BorderSide(color: colorScheme.outlineVariant.withAlpha(100))),
//       child: InkWell(
//         onTap: () => onPressed?.call(promotion),
//         child: Column(
//           children: [
//             AspectRatio(
//                 aspectRatio: 2,
//                 child: ImageWithPlaceholder(promotion.imageUrl.isNotEmpty ? promotion.imageUrl.first : '')),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(promotion.proDescri ?? "",
//                       style: textTheme.bodyLarge,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis),
//                   const SizedBox(height: 16),
//                   Wrap(
//                     spacing: 24,
//                     runSpacing: 16,
//                     children: [
//                       (promotion.proStartDate != null)
//                           ? buildLabeledChip(context,
//                               labelIcon: Icons.access_time,
//                               labelText: DateFormat('MMMM dd, yyyy').format(
//                                   DateTime.parse(promotion.proStartDate!
//                                       .toIso8601String())))
//                           : const SizedBox.shrink(),
//                       (promotion.proEndDate != null)
//                           ? buildLabeledChip(context,
//                               labelIcon: Icons.access_time_filled,
//                               labelText: DateFormat('MMMM dd, yyyy').format(
//                                   DateTime.parse(
//                                       promotion.proEndDate!.toIso8601String())))
//                           : const SizedBox.shrink(),
//                     ],
//                   ),
//                   Divider(height: 32),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(child: AppText.promotionExpiryText(context, promotion.proEndDate!)),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: TextButton(
//                           onPressed: () => onPressed?.call(promotion),
//                           style: TextButton.styleFrom(
//                               backgroundColor: colorScheme.secondary,
//                               foregroundColor: colorScheme.onSecondary,
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 4, horizontal: 8),
//                               minimumSize: Size.zero,
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap),
//                           child: Text("More Details",
//                               style: TextStyle(fontSize: 12)),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // Important: Call super.build to apply mixin
//
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return ChangeNotifierProvider(
//         create: (context) => PromotionViewmodel(),
//         builder: (context, child) {
//           promoVm = Provider.of<PromotionViewmodel>(context);
//
//           return Scaffold(
//             backgroundColor: colorScheme.surfaceContainerLowest,
//             body: SmartRefresher(
//                 scrollController: _scrollController,
//                 enablePullDown: true,
//                 enablePullUp: true,
//                 header: const WaterDropHeader(),
//                 footer: CustomFooter(
//                   builder: (BuildContext context, LoadStatus? mode) {
//                     if (mode == LoadStatus.loading) {
//                       return const CupertinoActivityIndicator();
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//                 controller: _refreshController,
//                 onRefresh: () => _onRefresh(context),
//                 onLoading: () => _onLoading(context),
//                 child: CustomScrollView(
//                   slivers: [
//                     SliverAppBar(
//                       automaticallyImplyLeading: false,
//                       expandedHeight: MediaQuery.of(context).size.width * 0.4,
//                       floating: false,
//                       pinned: true,
//                       flexibleSpace:
//                           LayoutBuilder(builder: (context, constraints) {
//                         return FlexibleSpaceBar(
//                           title: (constraints.maxHeight <=
//                                   kToolbarHeight +
//                                       MediaQuery.of(context).viewPadding.top)
//                               ? Padding(
//                                   padding: const EdgeInsets.only(left: 16),
//                                   child: Text("Exclusive Promotions"),
//                                 )
//                               : const SizedBox.shrink(),
//                           background: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Flexible(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text("Grab These Deals",
//                                           style: TextStyle(
//                                               fontSize: 24,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.start),
//                                       Text("Before They're Gone!",
//                                           style: TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.w400),
//                                           textAlign: TextAlign.start),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                           "Explore our latest offers and save big on your favorite products.",
//                                           style: TextStyle(
//                                               color: colorScheme.secondary),
//                                           textAlign: TextAlign.start),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox.square(
//                                   dimension: constraints.maxWidth * 0.3,
//                                   child: Image.asset(
//                                       'assets/icons/discount-shopping-cart.jpg'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate((context, index) {
//                         final Promotion promotion = promoVm.promotion[index];
//
//                         return promotionCard(context, promotion: promotion,
//                             onPressed: (value) async {
//                           await PromotionDetails.show(context, value);
//                         },
//                             margin: EdgeInsets.only(
//                                 left: 16,
//                                 top: (index == 0) ? 16 : 0,
//                                 right: 16,
//                                 bottom: 16));
//                       }, childCount: promoVm.promotions.length),
//                     )
//                   ],
//                 )),
//             floatingActionButton: ValueListenableBuilder<bool>(
//                 valueListenable: _showScrollUpButton,
//                 builder: (context, value, child) {
//                   if (!value) {
//                     return const SizedBox.shrink();
//                   }
//                   return FloatingActionButton.small(
//                     onPressed: () => _scrollToTop(),
//                     tooltip: "Scroll Up",
//                     child: Icon(Icons.keyboard_arrow_up_sharp),
//                   );
//                 }),
//           );
//
//         });
//   }
// }
