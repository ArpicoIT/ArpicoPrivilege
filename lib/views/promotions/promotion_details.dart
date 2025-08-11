import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/models/promotion.dart';
import '../../shared/components/app_text.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/image_with_placeholder.dart';
import '../../shared/components/tab_bar.dart';
import '../../shared/widgets/app_alert.dart';
import '../../shared/customize/custom_error.dart';
import '../../shared/components/cards/promotion_card.dart';
import '../../viewmodels/promotions/promotion_viewmodel.dart';
import 'promotion_center.dart';

class PromotionDetails extends StatefulWidget {
  const PromotionDetails({super.key});

  @override
  State<PromotionDetails> createState() => _PromotionDetailsState();
}

class _PromotionDetailsState extends State<PromotionDetails> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;

  late PromotionCollectionViewmodel promCollViewmodel;
  late PromotionDetailViewModel promDetViewmodel;

  int promTabIndex = 0;

  @override
  void initState() {
    promCollViewmodel = PromotionCollectionViewmodel()
      ..setContext(context)
      ..setLoading(true);
    promDetViewmodel = PromotionDetailViewModel()..setContext(context);

    // initialize controllers
    _refreshController = RefreshController();
    _scrollController = ScrollController();

    // initialize notifiers
    _showScrollUpBtn = ValueNotifier<bool>(false);

    // initialize listeners
    _scrollController.addListener(_updateScrollUpButtonVisibility);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final promotion =
          ModalRoute.of(context)?.settings.arguments as Promotion?;
      promDetViewmodel.promotion = promotion;
      promDetViewmodel.loadPromotion(promotion?.proId);

      promCollViewmodel.loadInitialPromotions(promTabIndex);
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

    if (promCollViewmodel.getCurrentDataModel(i).data.isEmpty) {
      await promCollViewmodel.loadInitialPromotions(i);
    }
  }

  // smart refresher functions
  void onRefresh() async {
    try {
      await promDetViewmodel.loadPromotion(promDetViewmodel.promotion?.proId);
      await promCollViewmodel.refreshPromotions(promTabIndex);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void onLoading() async {
    try {
      await promCollViewmodel.loadMorePromotions(promTabIndex);
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  Widget buildSliverTabBar() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: TabBarDelegate(
            PromotionTabBar(onTap: onChangedTab, initialIndex: promTabIndex)));
  }

  Widget buildSliverPromotionDetails() {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
        value: promDetViewmodel,
        child:
            Consumer<PromotionDetailViewModel>(builder: (context, vm, child) {
          late Promotion promotion;

          if (vm.isLoading) {
            promotion = mockPromotions.first;
          } else if (vm.promotion == null) {
            return AppAlertView(
                status: AppAlertType.noData, onRefresh: onRefresh);
          } else {
            promotion = vm.promotion!;
          }

          return Skeletonizer(
            enabled: vm.isLoading,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  (promotion.imageUrl.isNotEmpty)
                      ? AspectRatio(
                          aspectRatio: 2,
                          child: ImageWithPlaceholder(promotion.imageUrl.first))
                      : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(promotion.proDescri ?? "",
                            style: Theme.of(context).textTheme.bodyLarge),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                                width: 120, child: const Text("📅 Start Date")),
                            Text(
                              (promotion.proStartDate == null)
                                  ? "N/A"
                                  : DateFormat('MMMM dd, yyyy')
                                      .format(promotion.proStartDate!),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            SizedBox(
                                width: 120, child: const Text("⏳ End Date")),
                            Text(
                              (promotion.proEndDate == null)
                                  ? "N/A"
                                  : DateFormat('MMMM dd, yyyy')
                                      .format(promotion.proEndDate!),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        if(promotion.proEndDate != null)
                          Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: colorScheme.outlineVariant
                                          .withAlpha(100))),
                              child: AppText.promotionExpiryText(
                                  context, promotion.proEndDate!))
                      ],
                    ),
                  ),
                  if (promotion.imageUrl.length > 1)
                    Column(
                      children: [
                        ...List.generate(promotion.imageUrl.length, (i) {
                          if (i == 0) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: AspectRatio(
                                aspectRatio: 2,
                                child: ImageWithPlaceholder(
                                    promotion.imageUrl[i])),
                          );
                        })
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildSliverPromotions() {
    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
        value: promCollViewmodel,
        child: Consumer<PromotionCollectionViewmodel>(
            builder: (context, vm, child) {
          final currentPromotions = vm.getCurrentDataModel(promTabIndex).data;

          if (!vm.isLoading && currentPromotions.isEmpty) {
            return AppAlertView(
                status: AppAlertType.noData, onRefresh: onRefresh);
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
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope<Promotion>(
      canPop: false,
      onPopInvokedWithResult: (pop, _) {
        if (!pop) {
          Navigator.pop(context, promDetViewmodel.promotion);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          actions: [
            ActionIconButton.of(context)
                .menu(items: ['home', 'settings', 'notifications']),
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
              buildSliverPromotionDetails(),
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
      ),
    );
  }
}

/// ****************************************************************************
// class PromotionDetailsOld extends StatelessWidget {
//   final Promotion promotion;
//   final ScrollController? controller;
//   const PromotionDetailsOld({super.key, required this.promotion, this.controller});
//
//   static Future<void> show(BuildContext context, Promotion promotion) async {
//     await DraggableBottomSheet.show<Promotion>(
//       context: context,
//       title: "Promotion Details",
//       builder: (ctx, scl) {
//         return PromotionDetailsOld(promotion: promotion, controller: scl);
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return SingleChildScrollView(
//       controller: controller,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           (promotion.imageUrl.isNotEmpty)
//               ? AspectRatio(
//               aspectRatio: 2,
//               child: ImageWithPlaceholder(promotion.imageUrl.first))
//               : const SizedBox.shrink(),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(promotion.proDescri ?? "", style: textTheme.bodyLarge),
//                 SizedBox(height: 16),
//                 Row(
//                   children: [
//                     SizedBox(width: 120, child: const Text("📅 Start Date")),
//                     Text(
//                       (promotion.proStartDate == null) ? "N/A": DateFormat('MMMM dd, yyyy').format(promotion.proStartDate!),
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Row(
//                   children: [
//                     SizedBox(width: 120, child: const Text("⏳ End Date")),
//                     Text(
//                       (promotion.proEndDate == null) ? "N/A": DateFormat('MMMM dd, yyyy').format(promotion.proEndDate!),
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Container(
//                     padding: const EdgeInsets.all(16),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: colorScheme.outlineVariant.withAlpha(100))
//                     ),
//                     child: AppText.promotionExpiryText(context, promotion.proEndDate!)
//                 )
//               ],
//             ),
//           ),
//           if(promotion.imageUrl.length > 1)
//             Column(
//               children: [
//                 ...List.generate(promotion.imageUrl.length, (i){
//                   if(i == 0){
//                     return const SizedBox.shrink();
//                   }
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     child: AspectRatio(
//                         aspectRatio: 2,
//                         child: ImageWithPlaceholder(promotion.imageUrl[i])),
//                   );
//                 })
//               ],
//             )
//           else const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }
