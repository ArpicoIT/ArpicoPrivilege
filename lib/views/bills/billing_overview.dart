import 'dart:async';
import 'package:arpicoprivilege/core/pageState/page_state_notifier.dart';
import 'package:arpicoprivilege/handler.dart';
import 'package:arpicoprivilege/shared/pages/page_alert.dart';
import 'package:arpicoprivilege/shared/pages/page_loader.dart';
import 'package:arpicoprivilege/views/authentication/ebill_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_routes.dart';
import '../../core/constants/app_consts.dart';
import '../../core/pageState/page_state_container.dart';
import '../../core/utils/list_group_helper.dart';
import '../../data/models/eBill.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/cards/bill_card.dart';
import '../../shared/components/tab_bar.dart';
import '../../shared/widgets/app_alert.dart';
import '../../shared/customize/custom_loader.dart';
import '../../shared/widgets/grouped_listview.dart';
import '../../shared/filters/ebill_filter.dart';
import '../../viewmodels/ebill/eBill_viewmodel.dart';

/// new
class BillingOverview extends StatefulWidget {
  const BillingOverview({super.key});

  @override
  State<BillingOverview> createState() => BillingOverviewState();
}

class BillingOverviewState extends State<BillingOverview>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;
  late TabController _tabController;
  late EBillViewmodel eBillViewmodel;

  bool _isTabClick = false;
  final Map<String, GlobalKey> groupKeys = {};

  List<MapEntry<String, List<EBill>>> mockGroupedBills = ListGroupHelper<EBill>(
    items: mockEBills,
    dateExtractor: (EBill bill) => bill.datetime,
  ).groupByDate();

  @override
  bool get wantKeepAlive => keepAppHomeState; // Ensures state is kept alive

  @override
  void initState() {
    // initialize view models
    eBillViewmodel = EBillViewmodel()
      ..setContext(context)
      ..setLoading(true);

    // initialize controllers
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    _tabController =
        TabController(length: ListGroupHelper.groupTitles.length, vsync: this);

    // initialize notifiers
    _showScrollUpBtn = ValueNotifier<bool>(false);

    // initialize listeners
    _scrollController.addListener(() {
      _updateScrollUpButtonVisibility();
      _jumpToTabItem();
    });

    eBillViewmodel.addListener(_refreshTabController);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      eBillViewmodel.loadEBills(hasLoading: true);
    });
    super.initState();
  }

  void _updateScrollUpButtonVisibility() {
    bool value = _showScrollUpBtn.value;
    final double minScrollChanging = MediaQuery.of(context).size.width * 0.5;

    if (_scrollController.offset > minScrollChanging && !value) {
      _showScrollUpBtn.value = !value;
    } else if (_scrollController.offset <= minScrollChanging && value) {
      _showScrollUpBtn.value = !value;
    }
  }

  void _refreshTabController() {
    int newLength = eBillViewmodel.groupedBills.isNotEmpty
        ? eBillViewmodel.groupedBills.length
        : ListGroupHelper.groupTitles.length;

    if (_tabController.length == newLength) {
      return; // Avoid unnecessary updates
    }

    int oldIndex = (_tabController.length > 0) ? _tabController.index : 0;

    _tabController.dispose();
    _tabController = TabController(length: newLength, vsync: this);

    if (oldIndex < _tabController.length) {
      _tabController.animateTo(oldIndex);
    } else {
      _tabController.animateTo(0);
    }
  }

  void _jumpToTabItem() {
    if (_isTabClick) return;

    // Auto-Update Tab Selection on Scroll
    for (int i = 0; i < eBillViewmodel.groupedBills.length; i++) {
      String groupName = eBillViewmodel.groupedBills[i].key;
      final keyContext = groupKeys[groupName]?.currentContext;
      if (keyContext != null) {
        final RenderBox box = keyContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        if (position >= 0 && position <= 100) {
          _tabController.animateTo(i);
          break;
        }
      }
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

  void onScrollToGroup(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (eBillViewmodel.groupedBills.isEmpty) {
          return;
        }

        _isTabClick = true; // Set flag to true

        final key = groupKeys[eBillViewmodel.groupedBills[index].key];
        // _tabController.animateTo(index);
        if (key != null) {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }

        Future.delayed(Duration(milliseconds: 800), () {
          _isTabClick = false; // Reset flag after short delay
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  void onTapBill(EBill item) async {
    if (item.eBillUrl != null || item.eBillUrl!.isNotEmpty) {
      final url = Uri.parse(item.eBillUrl!);
      await launchUrl(url);
    }
  }

  void onTapFilterBtn() async {
    Map<String, dynamic>? result = await EBillFilter.show(
      context,
      initialValue: eBillViewmodel.filters,
    );

    if (mounted && result != null) {
      final loader = CustomLoader.of(context);
      await loader.show();
      await eBillViewmodel.filterEBills(result);
      await loader.close();
    }
  }

  void onTapRefresh() async {
    eBillViewmodel.setLoading(true);
    await eBillViewmodel.refreshEBills();
    eBillViewmodel.setLoading(false);
  }

  // smart refresher functions
  void onRefresh() async {
    try {
      await eBillViewmodel.refreshEBills();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void onLoading() async {
    try {
      await eBillViewmodel.loadEBills();
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  Widget buildSliverTabBar() {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider.value(
      value: eBillViewmodel,
      child: Consumer<EBillViewmodel>(builder: (context, vm, child) {
        final isLoading = vm.isLoading;

        if (!isLoading && vm.groupedBills.isEmpty) {
          return SliverToBoxAdapter(child: const SizedBox.shrink());
        }

        final tabItems = vm.groupedBills.isNotEmpty
            ? vm.groupedBills.map((e) => e.key).toList()
            : ListGroupHelper.groupTitles;

        return SliverPersistentHeader(
            pinned: true,
            delegate: TabBarDelegate(PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
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
                  controller: _tabController,
                  tabs: tabItems.map((e) => Tab(text: e)).toList(),
                  onTap: onScrollToGroup,
                ))));
      }),
    );
  }

  Widget buildSliverBills() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider.value(
        value: eBillViewmodel,
        child: Consumer<EBillViewmodel>(builder: (context, vm, child) {
          if (!vm.isLoading && vm.groupedBills.isEmpty) {
            return AppAlertView(
                aspectRatio: 1,
                status: AppAlertType.noData,
                onRefresh: onTapRefresh);
          }

          final currentBills =
              vm.isLoading ? mockGroupedBills : vm.groupedBills;

          return Container(
            padding: const EdgeInsets.all(12),
            child: GroupedListView<EBill>(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              groupedItems: currentBills,
              titleBuilder: (index, text) {
                final key = groupKeys.putIfAbsent(text, () => GlobalKey());

                if (index == 0) {
                  return SizedBox.shrink(key: key);
                }

                return Padding(
                  key: key,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    text,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              },
              itemBuilder: (index, data) => BillCard(data,
                  onTap: onTapBill,
                  currency: 'Rs. ',
                  margin: const EdgeInsets.only(bottom: 12),
                  enableSkeletonizer: vm.isLoading),
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
        title: Text(
            "Billing Overview"), // Transaction History, Billing Overview, E-Bill Statements, Recent Payments
        actions: [
          IconButton(onPressed: onTapFilterBtn, icon: Icon(Icons.filter_alt)),
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
            buildSliverTabBar(),
            buildSliverBills(),
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

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    _showScrollUpBtn.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

/*Widget _buildPeriodSelectionButton() {
  return DropdownButtonHideUnderline(
    child: DropdownButton2<DateFilterRange>(
      isExpanded: true,
      isDense: true,
      items: selections
          .map((item) => DropdownMenuItem<DateFilterRange>(
        value: item,
        child: Text(item.label),
      ))
          .toList(),
      value: selectedPeriod,
      onChanged: (value) {
        setState(() {
          selectedPeriod = value!;
        });
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        width: 132.0,
      ),
      menuItemStyleData: const MenuItemStyleData(height: 42.0),
    ),
  );
}*/

/*class EarnedPointsChart extends StatefulWidget {
  final DateFilterRange? filterRange;
  final double aspectRatio;
  final List<PointsChartData> chartData;
  const EarnedPointsChart(
      {super.key,
      this.filterRange,
      this.aspectRatio = 1.5,
      required this.chartData});

  @override
  State<StatefulWidget> createState() => EarnedPointsChartState();
}

class EarnedPointsChartState extends State<EarnedPointsChart> {
  DateFilterRange? _filterRange;
  List<PointsChartData> mappedData = [];

  @override
  void initState() {
    super.initState();
    _filterRange = widget.filterRange;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        setState(() {
          mappedData = getPointsChartData(_filterRange, widget.chartData);
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant EarnedPointsChart oldWidget) {
    if (widget.filterRange != oldWidget.filterRange ||
        widget.chartData != oldWidget.chartData) {
      _filterRange = widget.filterRange;
      mappedData = getPointsChartData(_filterRange, widget.chartData);
    }
    super.didUpdateWidget(oldWidget);
  }

  List<PointsChartData> getPointsChartData(
      DateFilterRange? range, List<PointsChartData> data) {
    try {
      Map<String, int> groupedData = {};
      for (var entry in data) {
        String? date = entry.date;
        int points = entry.points;
        if (date == null) {
          continue;
        }
        groupedData[date] =
            (groupedData[date] ?? 0) + points; // summarise date points
      }

      // Step 2: Map to PointsChartData
      List<PointsChartData> chartItems = groupedData.entries.map((entry) {
        String date = entry.key;
        int totalPoints = entry.value;

        // Extract day name and day using Intl
        DateTime parsedDate = DateTime.parse(date);
        String dayName =
            DateFormat('E').format(parsedDate); // Example: Mon, Tue
        String day = DateFormat('d').format(parsedDate); // Example: 1, 2, 3

        return PointsChartData(
            date: date,
            dayName: dayName,
            day: int.parse(day),
            points: totalPoints);
      }).toList();

      return Filters.byDate<PointsChartData>(
          items: chartItems,
          filterFn: (entry) => DateTime.parse(entry.date!),
          range: range);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: LayoutBuilder(builder: (context, constraints) {
        return BarChart(BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (data) => colorScheme.surfaceContainerLow,
              tooltipPadding: const EdgeInsets.all(6.0), // Padding for tooltip
              tooltipMargin: 24.0, // Margin between bar and tooltip
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  "Points: ${rod.toY.toInt()}",
                  const TextStyle(),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (event.isInterestedForInteractions &&
                  barTouchResponse != null &&
                  barTouchResponse.spot != null) {
                // Optional: Handle bar touch events here
                // final touchedSpot = barTouchResponse.spot!;
                // print("Touched bar index: ${touchedSpot.touchedBarGroupIndex}");
                // print("Touched Y value: ${touchedSpot.touchedRodData.toY}");
              }
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  Widget text = const SizedBox.shrink();

                  if (_filterRange == DateFilterRange.thisWeek) {
                    text = Text(mappedData
                            .firstWhere((e) => e.day == value.toInt())
                            .dayName ??
                        '');
                  } else if (_filterRange == DateFilterRange.thisMonth) {
                    // text = (value.toInt() % 7 == 0) ? Text(value.toInt().toString(),
                    //     style: const TextStyle(fontSize: 8.0)) : const SizedBox.shrink();
                    text = Text(value.toInt().toString(),
                        style: const TextStyle(fontSize: 8.0));
                  }

                  return SideTitleWidget(
                    // axisSide: meta.axisSide,
                    meta: meta,
                    child: text,
                  );
                },
                reservedSize: 36.0,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
                reservedSize: 36.0,
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
              show: true,
              border: const Border(bottom: BorderSide(color: Colors.grey))),
          barGroups: mappedData.asMap().entries.map((entry) {
            // final key = entry.key; // Index
            final value = entry.value; // Value from xValues

            final weekday = DateTime.now().day;

            return BarChartGroupData(
              x: value.day,
              barsSpace: 0.0,
              barRods: [
                BarChartRodData(
                  toY: value.points.toDouble(),
                  color: (value.day == weekday)
                      ? colorScheme.secondary
                      : colorScheme.secondary.withOpacity(0.1),
                  // color: barColor,
                  borderRadius: BorderRadius.zero,
                  width: ((constraints.maxWidth - 36.0) / mappedData.length),
                  borderSide: BorderSide(
                      color: (value.day == weekday)
                          ? Colors.transparent
                          : Colors.grey,
                      width: 0.1),
                ),
              ],
            );
          }).toList(),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: false,
          ),
        ));
      }),
    );
  }
}

class PointsChartData {
  final String? date; // 2024-11-20
  final String? dayName; // Wed
  final int day; // 20
  final int points; // 150

  PointsChartData({
    this.date,
    this.dayName,
    this.day = 0,
    this.points = 0,
  });
}*/
