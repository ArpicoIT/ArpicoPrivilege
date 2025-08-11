import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/app_notification.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/widgets/app_alert.dart';
import '../../viewmodels/app_notification_viewmodel.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _showScrollUpBtn;

  // late HomeViewmodel viewmodel;
  late AppNotificationViewmodel notificationViewmodel;

  @override
  void initState() {
    // initialize view models
    notificationViewmodel = AppNotificationViewmodel()
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
      notificationViewmodel.loadInitialNotifications();
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

  // smart refresher functions
  void onRefresh() async {
    try {
      await notificationViewmodel.refreshNotifications();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  // void onLoading() async {
  //   try {
  //     await productViewmodel.loadMoreProducts(prodTabIndex);
  //     _refreshController.loadComplete();
  //   } catch (e) {
  //     _refreshController.loadFailed();
  //   }
  // }

  Widget buildNotificationTile(AppNotification data, {Function(AppNotification notification)? onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    String path;
    IconData iconData;

    switch (data.messageType?.toLowerCase()) {
      case "info":
        path = "assets/tags/information.png";
        iconData = Icons.notifications; // Icons.info
        break;
      case "promotion":
        path = "assets/tags/promotion.png";
        iconData = Icons.local_offer; // Icons.card_giftcard
        break;
      case "product":
        path = "assets/tags/box.png";
        iconData = Icons.inventory_2_outlined; // Icons.shopping_cart_outlined
        break;
      default:
        path = "assets/tags/bell.png";
        iconData = Icons.notifications;
        break;
    }

    Widget leadingWidget = Icon(iconData, size: 48);
    // Widget leadingWidget = Image.asset(path);

    return ListTile(
      title: Text(data.title ?? ''),
      subtitle: Text(data.message ?? ''),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(), // pushes the time to the bottom
          if (data.executedDateTime != null)
            Text(
              timeago.format(data.executedDateTime!),
            ),
        ],
      ),
      leading: CircleAvatar(
        radius: 36,
        foregroundColor: colorScheme.onSurfaceVariant,
        backgroundColor: colorScheme.surfaceContainerLowest,
        child: ClipOval(
          child: leadingWidget,
        ),
      ),
      minLeadingWidth: 4,
      horizontalTitleGap: 8,
      shape: Border(),
      contentPadding:
          EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(left: 0),
      onTap: () => onTap?.call(data),
    );
  }

  Widget buildSliverNotifications() {
    return ChangeNotifierProvider.value(
      value: notificationViewmodel,
      child: Consumer<AppNotificationViewmodel>(builder: (context, vm, child) {
        if (!vm.isLoading && vm.notifications.isEmpty) {
          return SliverToBoxAdapter(
            child: AppAlertView(aspectRatio: 1,
                status: AppAlertType.noNotifications, onRefresh: onRefresh),
          );
        }

        final currentNotifications =
            vm.isLoading ? mockNotifications : vm.notifications;

        return SliverList.builder(
            itemCount: currentNotifications.length,
            itemBuilder: (context, index) {
              final notification = currentNotifications[index];
              return Skeletonizer(
                enabled: vm.isLoading,
                child: buildNotificationTile(notification, onTap: (notification) {}),
              );
            });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          ActionIconButton.of(context).menu(
              items: ['home', 'settings']),
        ],
      ),
      body: SmartRefresher(
        scrollController: _scrollController,
        enablePullDown: true,
        enablePullUp: false,
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
        // onLoading: onLoading,
        child: CustomScrollView(
          slivers: [
            buildSliverNotifications(),
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
