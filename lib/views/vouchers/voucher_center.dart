import 'dart:async';
import 'package:arpicoprivilege/shared/components/empty_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/components/cards/voucher_card.dart';

class VoucherCenter extends StatefulWidget {
  const VoucherCenter({super.key});

  @override
  State<VoucherCenter> createState() => _VoucherCenterState();
}

class _VoucherCenterState extends State<VoucherCenter>
    with TickerProviderStateMixin {
  int currentTab = 0;
  late TabController _tabController;
  List<String> _tabTitles = [];

  List<VoucherData> _allVouchers = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: currentTab, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final args =
            ModalRoute.of(context)?.settings.arguments as List<VoucherData>?;

        _timer = Timer(const Duration(seconds: 3), () {
          if (context.mounted && args != null) {
            setState(() {
              _allVouchers = args;
              _tabTitles = getTitles(_allVouchers);

              // Dispose of the old TabController and create a new one with the correct length
              _tabController.dispose();
              _tabController =
                  TabController(length: _tabTitles.length, vsync: this);
            });
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // builders
  PreferredSizeWidget? get appBar =>
      AppBar(title: const Text("Voucher Center"));

  Widget buildTabBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: colorScheme.primary,
      indicatorColor: colorScheme.primary,
      overlayColor: WidgetStatePropertyAll(colorScheme.primaryContainer),
      tabs: _tabTitles
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(e),
              ))
          .toList(),
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.start,
      onTap: (i) {
        setState(() {
          currentTab = i;
        });
      },
    );
  }

  Widget buildLoading(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerLow,
        highlightColor: colorScheme.surface,
        child: Column(
          children: [
            Container(
              height: 36.0,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        EmptyPlaceholder(width: 96.0, height: 36.0),
                        SizedBox(width: index != 11 ? 12.0 : 0.0)
                      ],
                    );
                  }
              ),
            ),
            const SizedBox(height: 12.0),
            Flexible(child: VouchersBuilder.empty(maxVisibleItems: 6))
          ],
        )
    );
  }

  Widget buildVouchers(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return VouchersBuilder(
      items: (currentTab == 0)
          ? _allVouchers
          : _allVouchers
              .where((e) => e.type == _tabTitles[currentTab])
              .toList(),
      onTapItem: (i, data) {},
      onTnC: (i, data) {},
      crossAxisCount: 1,
      groupBuilder: (context, index, str){
        return (currentTab == 0) ? Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(str??"", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
        ) : const SizedBox.shrink();
      },
      groupPadding: const EdgeInsets.all(12.0),
    );
  }

  // methods
  List<String> getTitles(List<VoucherData> data) {
    var titles = data
        .map((e) => e.type ?? '')
        .toSet()
        .where((type) => type.isNotEmpty)
        .toList();
    titles.insert(0, 'All');
    return titles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: _allVouchers.isNotEmpty ? Column(
        children: [
          buildTabBar(context),
          Flexible(child: buildVouchers(context)),
        ],
      ) : buildLoading(context),
    );
  }

}
