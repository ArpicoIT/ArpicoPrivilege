import 'package:arpicoprivilege/core/handlers/error_handler.dart';
import 'package:arpicoprivilege/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expandable_page_view/expandable_page_view.dart';

import '../app/app_routes.dart';
import '../handler.dart';
import '../shared/enum.dart';
import '../shared/pages/page_alert.dart';
import '../shared/pages/page_loader.dart';
import '../shared/customize/custom_toast.dart';
import 'bills/billing_overview.dart';
import 'home/home_screen.dart';
import 'points/points_screen.dart';
import 'promotions/promotion_center.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  static const double kToolbarHeight = 120;

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> with WidgetsBindingObserver {
  late PageController _pageController;

  int kInitPage = 0;
  late int currentPage;

  bool canPop = false;
  DateTime? lastBackPressTime;

  late final List<Future<bool> Function()> _pageGuards;

  @override
  void initState() {
    _pageGuards = [
      () async => true, // Page 0: No condition
      () async => true, // Page 1: No condition
      () async => true, // Page 2: No condition
      () => _checkIsRegisteredEBill(), // Page 3: Must be registered
      // Add more conditions here
    ];

    currentPage = kInitPage;

    // initialize controllers
    _pageController = PageController(initialPage: kInitPage);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final toast = CustomToast.of(context);
      final errorHandler = ErrorHandler.of(context);

      try {
        await getValidAccessToken();
        await getAndCacheValidUser();
        await refreshAndSyncFcmToken();
      } catch (e) {
        final error = errorHandler.showToast(e);
        error != null ? toast.showPrimary(e.toString()) : null;
      }
    });
    super.initState();
  }

  // button functions
  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  void _onPopInvoked(bool pop) {
    if (currentPage != 0) {
      _pageController.jumpToPage(0);
      setState(() {
        currentPage = 0;
      });
    } else {
      DateTime now = DateTime.now();

      // Check if the time difference between back presses is less than 2 seconds
      if (lastBackPressTime == null ||
          now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
        lastBackPressTime = now;
        CustomToast.of(context).showPrimary("Click exit again");
      } else {
        SystemNavigator.pop(); // Exit the app
      }
    }
  }

  void onTapNavItem(int index) async {
    if (index < 0 || index >= _pageGuards.length) return;

    final canJump = await _pageGuards[index]();
    if (canJump) {
      _pageController.jumpToPage(index);
    }
  }

  Future<bool> _checkIsRegisteredEBill() async {
    final navigator = Navigator.of(context);
    final toast = CustomToast.of(context);
    final errorHandler = ErrorHandler.of(context);

    try {
      final loginUser = await decodeValidLoginUser();

      if (loginUser.loginCustIsEbill) {
        return true;
      } else {
        return await navigator.pushNamed(AppRoutes.eBillRegister) == true;
      }
    } catch (e) {
      final error = await errorHandler.showDialog(e);
      (error != null) ? toast.showPrimary(error.toString()) : null;
    }

    return false;
  }

  List<AppPageArgs> viewList = [
    AppPageArgs(
        page: HomeScreen(),
        barItem: AppBottomNavBar(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: "Home",
          tooltip: "Home",
        )),
    AppPageArgs(
        page: PromotionCenter(),
        barItem: AppBottomNavBar(
          icon: Icons.local_offer_outlined,
          activeIcon: Icons.local_offer,
          label: "Deals",
          tooltip: "Deals",
        )),
    AppPageArgs(
        page: PointsScreen(),
        barItem: AppBottomNavBar(
          icon: Icons.emoji_events_outlined,
          activeIcon: Icons.emoji_events,
          label: "Points",
          tooltip: "Points",
        )),
    AppPageArgs(
        page: BillingOverview(),
        barItem: AppBottomNavBar(
          icon: Icons.receipt_long_outlined,
          activeIcon: Icons.receipt_long,
          label: "eBill",
          tooltip: "eBill",
        )),

    // AppPageArgs(
    //   page: AccountSettingsView(),
    //   route: AppRoutes.accountSettings,
    //   barItem: AppBottomNavBar(
    //     icon: Icons.account_circle_outlined,
    //     activeIcon: Icons.account_circle,
    //     label: "Account",
    //     tooltip: "Account",
    //   )),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (pop, _) => _onPopInvoked(pop),
          child: LayoutBuilder(builder: (context, constraints) {
            return ExpandablePageView.builder(
              itemCount: viewList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                    height: constraints.maxHeight, child: viewList[index].page);
              },
              onPageChanged: _onPageChanged,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
            );
          }),
        ),
        bottomNavigationBar: SizedBox(
          height: AppHome.kToolbarHeight,
          child: BottomNavigationBar(
            items: viewList.map((e) => e.barItem.build(context)).toList(),
            currentIndex: currentPage,
            iconSize: 26,
            unselectedFontSize: 14,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: colorScheme.onSurface,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            showUnselectedLabels: true,
            elevation: 1,
            onTap: onTapNavItem,
            backgroundColor: colorScheme.surface,
          ),
        ),
      ),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   // Handle app pause/resume events
  //   if (state == AppLifecycleState.paused) {
  //     // Save state when the app goes to background
  //     setState(() {
  //       canPop = false; // Disable pop when app is in background
  //     });
  //   } else if (state == AppLifecycleState.resumed) {
  //     // Re-enable pop when the app comes back to foreground
  //     setState(() {
  //       canPop = true;
  //     });
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
    // WidgetsBinding.instance?.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }
}

class AppPageArgs {
  final StatefulWidget page;
  final AppBar? appBar;
  final AppBottomNavBar barItem;

  AppPageArgs({
    required this.page,
    this.appBar,
    required this.barItem,
  });
}

class AppBottomNavBar {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? tooltip;

  AppBottomNavBar(
      {required this.icon,
      required this.activeIcon,
      required this.label,
      this.tooltip});

  BottomNavigationBarItem build(BuildContext context) {
    final activeBackgroundColor =
        Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
            Theme.of(context).colorScheme.onPrimaryContainer;

    return BottomNavigationBarItem(
        icon: _customIcon(icon, Colors.transparent),
        activeIcon:
            _customIcon(activeIcon, activeBackgroundColor.withOpacity(0.1)),
        label: label,
        tooltip: tooltip,
        backgroundColor: Colors.transparent);
  }

  Widget _customIcon(IconData icon, Color backgroundColor) {
    return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(26.0), color: backgroundColor),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
      margin: const EdgeInsets.only(bottom: 4.0),
      child: Icon(icon),
    );
  }
}

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;
//
//   _SliverAppBarDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });
//
//   @override
//   double get minExtent => minHeight;
//
//   @override
//   double get maxExtent => max(maxHeight, minHeight);
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }
//
//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
