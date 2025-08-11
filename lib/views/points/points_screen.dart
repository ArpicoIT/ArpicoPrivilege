import 'dart:async';
import 'package:arpicoprivilege/data/repositories/app_cache_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_consts.dart';
import '../../core/constants/loyalty_tier.dart';
import '../../handler.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/image_with_placeholder.dart';
import '../../shared/pages/page_alert.dart';
import '../../shared/customize/custom_toast.dart';
import '../../viewmodels/ebill/eBill_viewmodel.dart';
import '../../viewmodels/points/points_viewmodel.dart';
import '../app_home.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => PointsScreenState();
}

class PointsScreenState extends State<PointsScreen>
    with AutomaticKeepAliveClientMixin {
  final _refreshController = RefreshController();

  late PointsViewmodel pointsViewmodel;
  late EBillViewmodel eBillViewmodel;

  LoyaltyTier userTier = LoyaltyTier.unknown;

  @override
  bool get wantKeepAlive => keepAppHomeState; // Ensures state is kept alive

  @override
  void initState() {
    pointsViewmodel = PointsViewmodel()
      ..setContext(context)
      ..setLoading(true);
    eBillViewmodel = EBillViewmodel()
      ..setContext(context)
      ..setLoading(true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadUserTier();
      pointsViewmodel.getPointsBalance();
      eBillViewmodel.loadLastEBill(hasLoading: true);
    });

    super.initState();
  }

  void onRefresh() async {
    try {
      await loadUserTier();
      await pointsViewmodel.getPointsBalance();
      await eBillViewmodel.loadLastEBill();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> loadUserTier() async {
    final toast = CustomToast.of(context);
    try {
      final user = AppCacheRepository.loadUserCache();

      if (user == null) {
        throw 'User Not Found';
      }

      setState(() {
        userTier = LoyaltyTier.getTier(user.cardTypeId);
      });
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

  Widget buildHeaderCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => pointsViewmodel,
      child: Consumer<PointsViewmodel>(builder: (context, vm, child) {
        final points = vm.loyaltyPoints;

        return Skeletonizer(
            enabled: vm.isLoading,
            child: Card(
              margin: EdgeInsets.zero,
              color: colorScheme.surface,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: AspectRatio(
                aspectRatio: 2,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(userTier.backgroundAsset), fit: BoxFit.cover)
                      ),

                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Skeleton.keep(
                                      child: Text(
                                        "Point Balance",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Text(
                                    NumberFormat("#,###", "fr_FR")
                                        .format(points?.loyalPoints ?? 0),
                                    style: TextStyle(
                                      fontSize: 48,
                                      color: userTier.tertiaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Skeleton.keep(
                                      child: Text("Available Balance (LKR)",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))),
                                  Text(
                                      "Rs ${NumberFormat("#,##0.00").format(points?.loyalPoints ?? 0)}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: userTier.tertiaryColor,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox.square(
                              dimension: 72,
                              child: ImageWithPlaceholder(userTier.iconAsset,
                                  fit: BoxFit.contain,
                                  placeholder: CupertinoActivityIndicator())),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ));

        // return Skeletonizer(
        //     enabled: vm.isLoading,
        //     child: Card(
        //       margin: EdgeInsets.zero,
        //       color: vm.isLoading ? colorScheme.surface : Colors.transparent,
        //       clipBehavior: Clip.antiAliasWithSaveLayer,
        //       child: AspectRatio(
        //         aspectRatio: 2,
        //         child: Container(
        //           // decoration: vm.isLoading
        //           //     ? null
        //           //     : BoxDecoration(
        //           //         gradient: LinearGradient(colors: [
        //           //         membership.primaryColor,
        //           //         membership.secondaryColor
        //           //       ])),
        //           decoration: BoxDecoration(
        //               gradient: LinearGradient(colors: [
        //                 userTier.primaryColor,
        //                 userTier.secondaryColor
        //               ])),
        //           padding: const EdgeInsets.all(16),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 mainAxisSize: MainAxisSize.max,
        //                 children: [
        //                   Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Skeleton.keep(
        //                           child: Text(
        //                         "Point Balance",
        //                         style: TextStyle(
        //                             color: colorScheme.onPrimaryFixedVariant,
        //                             fontWeight: FontWeight.bold),
        //                       )),
        //                       Text(
        //                         NumberFormat("#,###", "fr_FR")
        //                             .format(points?.loyalPoints ?? 0),
        //                         style: TextStyle(
        //                           fontSize: 48,
        //                           color: userTier.tertiaryColor,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                   Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Skeleton.keep(
        //                           child: Text("Available Balance (LKR)",
        //                               style: TextStyle(
        //                                   color:
        //                                       colorScheme.onPrimaryFixedVariant,
        //                                   fontWeight: FontWeight.bold))),
        //                       Text(
        //                           "Rs ${NumberFormat("#,##0.00").format(points?.loyalPoints ?? 0)}",
        //                           style: TextStyle(
        //                               fontSize: 16,
        //                               color: userTier.tertiaryColor,
        //                               fontWeight: FontWeight.bold)),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //               SizedBox.square(
        //                   dimension: 72,
        //                   child: ImageWithPlaceholder(userTier.iconAsset,
        //                       fit: BoxFit.contain,
        //                       placeholder: CupertinoActivityIndicator())),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ));

      }),
    );
  }

  Widget buildPointsDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Earn Points with Every Purchase!",
            style: TextStyle(fontSize: 20)),
        // Text("How to Earn Arpico Points?", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("LKR 200.00 = ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.star_rounded,
                            color: Colors.orangeAccent, size: 66),
                        Text("1",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                    "For every Rs.200 you spend, you will receive a point. Accumulate points and unlock exciting rewards, discounts, and exclusive offers. Start earning today and make the most of your purchases!"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLastBillPointsTile() {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => eBillViewmodel,
      child: Consumer<EBillViewmodel>(builder: (context, vm, child) {
        if (!vm.isLoading && vm.lastEBill == null) {
          return const SizedBox.shrink();
        }

        final billUrl = vm.lastEBill?.eBillUrl;
        final billDate = vm.lastEBill?.datetime;
        final billPoints = vm.lastEBill?.loyalty?.billEarnPoints;

        return Skeletonizer(
            enabled: vm.isLoading,
            child: ListTile(
              onTap: ((billUrl ?? "").trim().isNotEmpty)
                  ? () => launchUrl(Uri.parse(billUrl!), mode: LaunchMode.externalApplication)
                  : null,
              tileColor: colorScheme.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              minVerticalPadding: 12.0,
              title: Text("Last E-Bill Points"),
              subtitle: Text(billDate != null
                  ? DateFormat('MMMM dd, yyyy').format(billDate)
                  : BoneMock.date),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                          billPoints != null
                              ? NumberFormat("#,###")
                                  .format(billPoints)
                                  .toString()
                              : '0000',
                          style: TextStyle(
                              fontSize: 18,
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Skeleton.keep(
                      child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.navigate_next),
                  ))
                ],
              ),
            ));
      }),
    );
  }

  Widget buildRecentTransactions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(minHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Recent Transactions", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          PageAlert.widget(
              key: ValueKey("emptyTransactions"), padding: EdgeInsets.zero),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: Call super.build to apply mixin

    return Scaffold(
      appBar: AppBar(
        title: Text("Arpico Points"),
        actions: [
          ActionIconButton.of(context).menu(
              items: ['home', 'settings', 'notifications']),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: const MaterialClassicHeader(),
        footer: const SizedBox.shrink(),
        controller: _refreshController,
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: buildHeaderCard(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    buildPointsDescription(),
                    buildLastBillPointsTile(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildRecentTransactions(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

class AbstractTierPainter extends CustomPainter {
  final Color baseColor;

  AbstractTierPainter(this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Background (optional subtle gradient)
    final background = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, baseColor.withOpacity(0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height));
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), background);

    // Draw individually positioned diagonals
    _drawDiagonal(canvas, size, baseColor.withOpacity(0.15), -0.4, 0.25, 1.5, 0.20);
    _drawDiagonal(canvas, size, baseColor.withOpacity(0.35), -0.35, 0.45, 1.2, 0.18);
    _drawDiagonal(canvas, size, baseColor.withOpacity(0.25), -0.3, 0.65, 1.0, 0.16);
    _drawDiagonal(canvas, size, baseColor.withOpacity(0.45), -0.25, 0.85, 0.8, 0.14);
  }

  void _drawDiagonal(Canvas canvas, Size size, Color color, double rotationRad,
      double heightRatio, double widthFactor, double heightFactor) {
    final Paint paint = Paint()..color = color;

    final double rectWidth = size.width * widthFactor;
    final double rectHeight = size.height * heightFactor;

    final double centerX = size.width / 2;
    final double centerY = size.height * heightRatio;

    canvas.save();

    canvas.translate(centerX, centerY);
    canvas.rotate(rotationRad);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: rectWidth, height: rectHeight),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}




/*class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => PointsScreenState();
}

class PointsScreenState extends State<PointsScreen> with AutomaticKeepAliveClientMixin {
  final _refreshController = RefreshController();
  late PointsViewmodel pointsVM;
  late EBillHistoryViewmodel eBillVM;

  final ValueNotifier<InitializationState> _initializationNotifier =
  ValueNotifier<InitializationState>(InitializationState.waiting);

  LoyaltyMembership membership = LoyaltyMembership.def;
  EBill? eBill;


  @override
  bool get wantKeepAlive => true; // Ensures state is kept alive

  @override
  void initState() {
    super.initState();

    pointsVM = PointsViewmodel();
    eBillVM = EBillHistoryViewmodel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _initialize(context);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  void _initialize(BuildContext context) async {
    final loader = CustomLoader.of(context);

    if(context.mounted) {
      await loader.show();
    }
    if(context.mounted) {
      await _loadMembership(context);
    }
    if(context.mounted) {
      await _loadPointsBalance(context);
    }
    if(context.mounted) {
      await _loadLastEBill(context);
    }
    if (context.mounted) {
      setState(() {});
      await loader.close();
    }
  }

  void _onRefresh(BuildContext context) async {
    if(context.mounted) {
      await _loadMembership(context);
    }
    if(context.mounted) {
      await _loadPointsBalance(context);
    }
    if(context.mounted) {
      await _loadLastEBill(context);
    }
    if (context.mounted) {
      setState(() {});
    }

    /// if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> _loadMembership(BuildContext context) async {
    final toast = CustomToast.of(context);
    try {
      final user = await getUserFromStorage();
      membership = LoyaltyMembership.getMembership(user.cardTypeId);
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

  Future<void> _loadPointsBalance(BuildContext context) async {
    final toast = CustomToast.of(context);
    try {
      if (context.mounted) {
        await pointsVM.getPointsBalance(context);
      }
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

  Future<void> _loadLastEBill(BuildContext context) async {
    final toast = CustomToast.of(context);
    try {
      if (context.mounted) {
        eBill = await eBillVM.getLastEBill(context);
      }
    } catch (e) {
      toast.showPrimary(e.toString());
    }
  }

  Widget buildDivider(BuildContext context) => Divider(
        thickness: 12,
        height: 12,
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      );

  Widget buildExpandedChip(
    BuildContext context, {
    required Function() onTap,
    required String title,
    String? value,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStateColor.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: Colors.white)),
              Text(value ?? "0",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPointsDescription(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Earn Points with Every Purchase!", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            const SizedBox(height: 16),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                    children: [
                      TextSpan(text: "For every "),
                      TextSpan(text: "LKR 200 ", style: TextStyle(color: membership.secondaryColor, fontWeight: FontWeight.bold)),
                      TextSpan(text: "you spend, \nyou will receive "),
                      TextSpan(text: "1 point. ", style: TextStyle(color: membership.secondaryColor, fontWeight: FontWeight.bold)),
                      TextSpan(text: "Accumulate points and unlock exciting rewards, discounts, and exclusive offers. Start earning today and make the most of your purchases!"),
                    ])),
          ],
        ),
      ),
    );
  }

  Widget buildLastBillPointsTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if(eBill == null){
      return const SizedBox.shrink();
    }

    final billUrl = eBill?.eBillUrl;
    final billDate = eBill?.datetime;
    final billPoints = eBill?.loyalty?.billEarnPoints;

    return ListTile(
      onTap: (billUrl != null) ? () => launchUrl(Uri.parse(billUrl)) : null,
      tileColor: colorScheme.surfaceContainerLow,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 12.0,
      title: Text("Last E-Bill Points"),
      subtitle: (billDate != null) ? Text(DateFormat('MMMM dd, yyyy').format(billDate)) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          (billPoints != null) ? Text(
              "+${NumberFormat("#,###").format(billPoints).toString()}",
              style: TextStyle(
                  fontSize: 24.0,
                  color: membership.secondaryColor,
                  fontWeight: FontWeight.bold)) : const SizedBox.shrink(),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );


  }

  Widget buildRecentTransactions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(minHeight: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.boldTitle("Recent Transactions"),
          const SizedBox(height: 12),
          PageAlert.widget(key: Key("emptyTransactions"), padding: EdgeInsets.zero),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: Call super.build to apply mixin

    return ChangeNotifierProvider(
        create: (context) => PointsViewmodel(),
        builder: (context, child) {
          pointsVM = Provider.of<PointsViewmodel>(context);
          final points = pointsVM.points;


          return Scaffold(
            // appBar: AppBar(
            //   title: Text("Arpico Points"),
            // ),
            extendBodyBehindAppBar: true,
            body: SmartRefresher(
              enablePullDown: true,
              header: const WaterDropHeader(),
              footer: const SizedBox.shrink(),
              controller: _refreshController,
              onRefresh: () => _onRefresh(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.orangeAccent,
                            gradient: RadialGradient(
                              colors: [
                                membership.color.withAlpha(50),
                                membership.color
                              ],
                              center: Alignment.topCenter,
                            )),
                        padding: EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 16,
                            top: kToolbarHeight +
                                MediaQuery.of(context)
                                    .viewPadding
                                    .top), // MediaQuery.of(context).viewPadding.top
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LayoutBuilder(builder: (context, constraints) {
                              return Stack(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                alignment: Alignment.centerLeft,
                                children: [
                                  // Icon(Icons.star),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Current Balance",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          NumberFormat("#,###", "fr_FR")
                                              .format(points.loyalPoints ?? 0),
                                          style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: SizedBox.square(
                                        dimension: constraints.maxWidth * 0.3,
                                        child: ImageWithPlaceholder(
                                            membership.icon,
                                            fit: BoxFit.contain,
                                            placeholder:
                                            CupertinoActivityIndicator())),
                                  ),
                                ],
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildExpandedChip(context,
                                    onTap: () {},
                                    title: "Today",
                                    value: "0"
                                ),
                                buildExpandedChip(context,
                                    onTap: () {},
                                    title: "Redeems",
                                    value: (points.cummRedem != null) ? points.cummRedem.toString() : "0"
                                ),
                                buildExpandedChip(context,
                                    onTap: () {},
                                    title: "Promotions",
                                    value: (points.promoPoints != null) ? points.promoPoints.toString() : "0"
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            runSpacing: 16,
                            children: [
                              buildPointsDescription(context),
                              buildLastBillPointsTile(context),
                            ],
                          ),
                        ),
                        buildDivider(context),
                        buildRecentTransactions(context),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            extendBodyBehindAppBar: false,
            body: SmartRefresher(
              enablePullDown: true,
              header: const WaterDropHeader(),
              footer: const SizedBox.shrink(),
              controller: _refreshController,
              onRefresh: () => _onRefresh(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.orangeAccent,
                            gradient: RadialGradient(
                          colors: [
                            membership.color.withAlpha(50),
                            membership.color
                          ],
                          center: Alignment.topCenter,
                        )),
                        padding: EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 16,
                            top: kToolbarHeight +
                                MediaQuery.of(context)
                                    .viewPadding
                                    .top), // MediaQuery.of(context).viewPadding.top
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LayoutBuilder(builder: (context, constraints) {
                              return Stack(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                alignment: Alignment.centerLeft,
                                children: [
                                  // Icon(Icons.star),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Current Balance",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          NumberFormat("#,###", "fr_FR")
                                              .format(points.loyalPoints ?? 0),
                                          style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: SizedBox.square(
                                        dimension: constraints.maxWidth * 0.3,
                                        child: ImageWithPlaceholder(
                                            membership.icon,
                                            fit: BoxFit.contain,
                                            placeholder:
                                                CupertinoActivityIndicator())),
                                  ),
                                ],
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildExpandedChip(context,
                                    onTap: () {},
                                    title: "Today",
                                    value: "0"
                                ),
                                buildExpandedChip(context,
                                    onTap: () {},
                                    title: "Redeems",
                                    value: (points.cummRedem != null) ? points.cummRedem.toString() : "0"
                                ),
                                buildExpandedChip(context,
                                    onTap: () {},
                                    title: "Promotions",
                                    value: (points.promoPoints != null) ? points.promoPoints.toString() : "0"
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            runSpacing: 16,
                            children: [
                              buildPointsDescription(context),
                              buildLastBillPointsTile(context),
                            ],
                          ),
                        ),
                        buildDivider(context),
                        buildRecentTransactions(context),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

}*/

// class PointWidgets {
//   static Widget walletCard(
//       BuildContext context, {
//         required Color primaryColor,
//         required double points,
//         required String expDate,
//         required String id,
//         String? image,
//       }) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: AppRadius.s.all,
//           border: Border.all(color: primaryColor)),
//       padding: const EdgeInsets.all(18.0),
//       child: Stack(
//         alignment: Alignment.topLeft,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Total Balance",
//                   style:
//                   TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
//               Text(NumberFormat("#,###").format(points),
//                   style: TextStyle(
//                       fontSize: 36.0,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor)),
//               const SizedBox(height: 24.0),
//               Text(
//                   id
//                       .replaceAllMapped(
//                       RegExp(r'.{1,4}'), (match) => '${match.group(0)} ')
//                       .trim(),
//                   style: const TextStyle(fontSize: 16.0)),
//               Text("VALID TILL ${Formatter.date(expDate)}",
//                   style: TextStyle(color: colorScheme.secondary)),
//             ],
//           ),
//           if (image != null)
//             Align(
//               alignment: Alignment.topRight,
//               child: SizedBox.square(
//                 dimension: 84.0,
//                 child: Image.asset(image),
//               ),
//             )
//         ],
//       ),
//     );
//   }
//
//   static Widget iconTile(
//       BuildContext context, {
//         required String title,
//         required IconData iconData,
//         required Function() onTap,
//         Color? iconColor,
//         Size? size,
//       }) {
//     return SizedBox(
//       width: size?.width,
//       child: ListTile(
//         onTap: onTap,
//         tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
//         minVerticalPadding: 0.0,
//         title: Container(
//           height: size?.height,
//           padding: const EdgeInsets.symmetric(vertical: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(iconData, size: 36.0, color: iconColor),
//               Text(title,
//                   style: const TextStyle(
//                       fontSize: 16.0, fontWeight: FontWeight.bold))
//             ],
//           ),
//         ),
//         trailing: const Icon(Icons.navigate_next),
//       ),
//     );
//   }
//
//   static Widget textTile(
//       BuildContext context, {
//         required String title,
//         required String subTitle,
//         required IconData iconData,
//         required Function() onTap,
//         Widget? trailing,
//         Widget? tertiary,
//         Color? iconColor,
//         Size? size,
//       }) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return SizedBox(
//       width: size?.width,
//       child: ListTile(
//         onTap: onTap,
//         tileColor: colorScheme.surfaceContainerLow,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
//         minVerticalPadding: 12.0,
//         title: Text(title),
//         subtitle:
//         Text(subTitle, style: TextStyle(color: colorScheme.secondary)),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             trailing ?? const SizedBox.shrink(),
//             const Padding(
//               padding: EdgeInsets.only(left: 16.0),
//               child: Icon(Icons.navigate_next),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   static void showQrDialog(BuildContext context, String data) async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AspectRatio(
//           aspectRatio: 1.0,
//           child: Dialog(
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             child: Container(
//               padding: const EdgeInsets.all(12.0),
//               child: QrImageView(
//                 data: data,
//                 version: QrVersions.auto,
//                 // size: 200.0,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
// /*static Widget iconCard2(BuildContext context, {
//     required String title,
//     required Icon icon,
//     required Function() onPressed,
//     Color? backgroundColor,
//     Color? foregroundColor,
//     Size? size,
//   }){
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ButtonStyle(
//         shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: AppStyles.radiusAll)),
//         fixedSize: WidgetStateProperty.all(size),
//         elevation: WidgetStateProperty.all(0),
//         padding: WidgetStateProperty.all(const EdgeInsets.all(18.0)),
//         iconSize: WidgetStateProperty.all(36.0),
//         backgroundColor: WidgetStateProperty.all(backgroundColor),
//         foregroundColor: WidgetStateProperty.all(foregroundColor),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               icon,
//               Text(title, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
//             ],
//           ),
//           const Icon(Icons.navigate_next, size: 24.0, color: Colors.grey),
//         ],
//       ),
//     );
//   }*/
// }
