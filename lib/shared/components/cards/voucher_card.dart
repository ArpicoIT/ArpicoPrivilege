import 'package:arpicoprivilege/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class VoucherCard extends StatelessWidget {
  final String? type;
  final String? title;
  final String? subTitle;
  final double? minSpend;
  final String? currency;
  final String? startDate;
  final String? expData;
  final Function()? onCollect;
  final Function()? onTnC;
  final double cardWidth;
  final EdgeInsetsGeometry cardMargin;

  VoucherCard({
    super.key,
    this.type,
    this.title,
    this.subTitle,
    this.minSpend,
    this.currency,
    this.startDate,
    this.expData,
    this.onCollect,
    this.onTnC,
    this.cardWidth = double.infinity,
    this.cardMargin = EdgeInsets.zero
  }) : viewType = 0;

  VoucherCard.empty({super.key,
    required this.cardWidth,
    required this.cardMargin
  }) : type = null,
        title = null,
        subTitle = null,
        minSpend = null,
        currency = null,
        startDate = null,
        expData = null,
        onCollect = null,
        onTnC = null,
        viewType = -1;

  static double cardHeight = 120.0;
  int? viewType;

  @override
  Widget build(BuildContext context) {
    switch(viewType){
      case -1: return empty(context);
      case 0: return card(context);
    }

    return const SizedBox.shrink();
  }

  Widget card(BuildContext context){
    final color = VoucherData(type: type).colorByType(context);

    return Container(
      height: cardHeight,
      width: cardWidth,
      padding: const EdgeInsets.all(8.0),
      margin: cardMargin,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.s.all,
        border: Border.all(color:color, width: 0.6),
      ),
      child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final baseFontSize = maxWidth >= 300 ? 16.0 : maxWidth >= 240 ? 14.0 : 12.0;

            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.red,
                      border: Border(right: BorderSide(color: color.withAlpha(100), width: 0.6))
                  ),
                  width: maxWidth * 0.35,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title!, style: TextStyle(color: color, fontSize: baseFontSize, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4.0),
                      Text("Min. spend", style: TextStyle(color: color, fontSize: baseFontSize * 0.83)),
                      Text("$currency ${NumberFormat("#,###").format(minSpend)}", style: TextStyle(color: color, fontSize: baseFontSize * 0.83)),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(type!.toUpperCase(), style: TextStyle(color: color, fontSize: baseFontSize, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4.0),
                              Text(subTitle!.toUpperCase(), style: TextStyle(color: color, fontSize: baseFontSize * 0.83)),
                              Text("${DateFormat('MMM dd, yyyy').format(DateTime.parse(startDate!))} - ${DateFormat('MMM dd, yyyy').format(DateTime.parse(expData!))}",
                                  style: TextStyle(color: color, fontSize: baseFontSize * 0.83), overflow: TextOverflow.ellipsis, maxLines: 1),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildButton(
                                  backgroundColor: color.withOpacity(0.1),
                                  foregroundColor: color,
                                  child: const Text("T&C", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                  onPressed: (){}
                              ),
                              _buildButton(
                                  backgroundColor: color,
                                  foregroundColor: Colors.white,
                                  child: const Text("Collect", style: TextStyle(fontWeight: FontWeight.bold)),
                                  onPressed: (){}
                              ),
                              // ComPrimaryButton(text: "Collrct", onPressed: null)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            );
          }
      ),
    );
  }

  Widget empty(BuildContext context){
    return Container(
      height: cardHeight,
      width: cardWidth,
      // padding: const EdgeInsets.all(8.0),
      margin: cardMargin,
      decoration: BoxDecoration(
        borderRadius: AppRadius.s.all,
        color: Colors.grey.shade200
      ),
      // child: LayoutBuilder(
      //     builder: (context, constraints) {
      //       final maxWidth = constraints.maxWidth;
      //       final baseFontSize = maxWidth >= 300 ? 16.0 : maxWidth >= 240 ? 14.0 : 12.0;
      //
      //       return Row(
      //         mainAxisSize: MainAxisSize.max,
      //         children: [
      //           Container(
      //             decoration: const BoxDecoration(
      //                 border: Border(right: BorderSide(width: 0.6))
      //             ),
      //             width: maxWidth * 0.35,
      //             padding: const EdgeInsets.symmetric(horizontal: 4.0),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Container(width: 100, height: baseFontSize, color: Colors.grey),
      //                 const SizedBox(height: 4.0),
      //                 Container(width: 100, height: baseFontSize * 0.83, color: Colors.grey),
      //                 const SizedBox(height: 2.0),
      //                 Container(width: 120, height: baseFontSize * 0.83, color: Colors.grey),
      //               ],
      //             ),
      //           ),
      //           Flexible(
      //             child: Padding(
      //               padding: const EdgeInsets.only(left: 8.0),
      //               child: Stack(
      //                 children: [
      //                   Container(
      //                     alignment: Alignment.center,
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       children: [
      //                         Container(width: 100, height: baseFontSize),
      //                         const SizedBox(height: 4.0),
      //                         Container(width: 120, height: baseFontSize * 83),
      //                         const SizedBox(height: 2.0),
      //                         Container(width: double.infinity, height: baseFontSize * 83),
      //                         const SizedBox(height: 4.0),
      //                       ],
      //                     ),
      //                   ),
      //                   const Positioned(
      //                     bottom: 0,
      //                     right: 0,
      //                     left: 0,
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       crossAxisAlignment: CrossAxisAlignment.end,
      //                       children: [
      //                         SizedBox(width: 84.0, height: 18),
      //                         SizedBox(width: 96.0, height: 22),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //
      //         ],
      //       );
      //     }
      // ),
    );
  }

  Widget _buildButton({Color? backgroundColor, Color? foregroundColor, required Widget child, required Function() onPressed}){
    return SizedBox(
      height: 24.0,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            minimumSize: const Size(0, 0),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          ),
          child: child
      ),
    );
  }
}

class VouchersBuilder extends StatelessWidget {
  final List<VoucherData> items;
  final Function(int index, VoucherData data)? onTapItem;
  final Function(int index, VoucherData data)? onTnC;
  final Widget Function(BuildContext context, int index, String? text)? groupBuilder;

  final int crossAxisCount;
  final int? maxVisibleItems;
  final double viewportFraction;
  final EdgeInsetsGeometry? groupPadding;

  VouchersBuilder({
    super.key,
    required this.items,
    required this.onTapItem,
    required this.onTnC,
    this.groupBuilder,
    int? maxVisibleItems,
    this.crossAxisCount = 1,
    this.viewportFraction = 1.0,
    this.groupPadding = const EdgeInsets.only(bottom: 12.0)
  }) : viewType = 0,
        maxVisibleItems = maxVisibleItems == null
          ? items.length
          : maxVisibleItems > items.length
          ? items.length
          : maxVisibleItems;

  VouchersBuilder.horizontal({
    super.key,
    required this.items,
    required this.onTapItem,
    required this.onTnC,
    int? maxVisibleItems,
    this.crossAxisCount = 1,
    this.viewportFraction = 1.0,
    this.groupPadding = const EdgeInsets.only(bottom: 12.0)
  }) : viewType = 1,
        groupBuilder = null,
        maxVisibleItems = maxVisibleItems == null
          ? items.length
          : maxVisibleItems > items.length
          ? items.length
          : maxVisibleItems;

  VouchersBuilder.empty({
    super.key,
    this.items = const [],
    required this.maxVisibleItems,
  }) : onTapItem = null,
        onTnC = null,
        groupBuilder = null,
        viewType = -1,
        crossAxisCount = 1,
        viewportFraction = 1.0,
        groupPadding = null;

  int? viewType;

  @override
  Widget build(BuildContext context) {
    switch(viewType){
      case -1: return empty(context);
      case 0: return masonryGridView(context);
      case 1: return horizontalListView(context);
      default: return masonryGridView(context);
    }
  }

  Widget empty(context){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: maxVisibleItems,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return VoucherCard.empty(
              cardWidth: double.infinity,
              cardMargin: const EdgeInsets.only(bottom: 12.0)
          );
        }
      ),
    );
  }

  Widget masonryGridView(BuildContext context){
    return LayoutBuilder(builder: (context, constraints) {
      final double boxWidth = (constraints.maxWidth - (12.0 * crossAxisCount)) / crossAxisCount;
      final maxVisibleList = items.sublist(0, maxVisibleItems);
      final groupedList = maxVisibleList.map((e) => e.type).toList().toSet().map((e) => maxVisibleList.where((i) => e == i.type).toList()).toList();

      return ListView.builder(
        itemCount: groupedList.length,
        itemBuilder: (context, index){
          final group = groupedList[index];
          final groupTitle = group.first.type;
          final color = group.first.colorByType(context);

          return Container(
            padding: groupPadding,
            child: Stack(
              children: [
                // Container(
                //   height: 50,
                //   width: 50,
                //   color: color,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    groupBuilder?.call(context, index, groupTitle)??const SizedBox.shrink(),
                    MasonryGridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      itemCount: group.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final groupData = group[index];
                        return VoucherCard(
                          cardWidth: boxWidth,
                          type: groupData.type,
                          title: groupData.title,
                          subTitle: groupData.subTitle,
                          minSpend: groupData.minSpend,
                          currency: groupData.currency,
                          startDate: groupData.startDate,
                          expData: groupData.expData,
                          onCollect: () => onTapItem?.call(index, groupData),
                          onTnC: () => onTnC?.call(index, groupData),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        }
      );
    });
  }

  Widget horizontalListView(BuildContext context){
    return SizedBox(
      height: VoucherCard.cardHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        final double boxWidth = ((constraints.maxWidth - (12.0 * crossAxisCount)) / crossAxisCount) * viewportFraction;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: maxVisibleItems,
          itemBuilder: (context, index){
            final data = items[index];
            final cardMargin = EdgeInsets.only(left: 12.0, right: (index == (maxVisibleItems! - 1)) ? 12.0 : 0);

            return VoucherCard(
              cardMargin: cardMargin,
              cardWidth: boxWidth,
              type: data.type,
              title: data.title,
              subTitle: data.subTitle,
              minSpend: data.minSpend,
              currency: data.currency,
              startDate: data.startDate,
              expData: data.expData,
              onCollect: () => onTapItem?.call(index, data),
              onTnC: () => onTnC?.call(index, data),
            );
          }
        );

      }),
    );
  }
}

class VoucherData {
  final String? type;
  final String? title;
  final String? subTitle;
  final double? minSpend;
  final String? currency;
  final String? startDate;
  final String? expData;
  VoucherData({
    this.type,
    this.title,
    this.subTitle,
    this.minSpend,
    this.currency,
    this.startDate,
    this.expData,
  });

  Color colorByType(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;

    switch(type?.toLowerCase()){
      case "arpico voucher": return Colors.orangeAccent;
      case "voucher max": return Colors.green;
      case "birthday offer": return Colors.purpleAccent;
      case "xmas": return Colors.pink;
      default: return Colors.redAccent;
    }
  }
}