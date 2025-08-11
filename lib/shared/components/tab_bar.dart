import 'package:flutter/material.dart';

class TabItem {
  String text;
  IconData? iconData;
  TabItem(this.text, this.iconData);
}

class PrimaryTabBar extends StatelessWidget {
  final Function(int index) onTap;
  final List<TabItem> items;
  const PrimaryTabBar({super.key, required this.onTap, required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TabBar(
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
      tabs: items.map((e) => Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (e.iconData != null) ...[
              Icon(e.iconData),
              const SizedBox(width: 8),
            ],
            Text(e.text),
          ],
        ),
      )).toList(),
      onTap: onTap,
    );
  }
}

/// A delegate to pin the TabBar
class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget _tabBar;

  TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(TabBarDelegate oldDelegate) => true;
}

// class CustomTabBars {
//   TabBar _primary(BuildContext context,
//       {required Function(int index) onTap, required List<TabItem> items}) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return TabBar(
//       labelStyle: TextStyle(
//           color: colorScheme.onSurface,
//           fontSize: 16,
//           fontWeight: FontWeight.bold),
//       unselectedLabelStyle: TextStyle(
//           color: colorScheme.onSurfaceVariant,
//           fontSize: 16,
//           fontWeight: FontWeight.w500),
//       isScrollable: true,
//       tabAlignment: TabAlignment.start,
//       dividerHeight: 0,
//       tabs: items.map((e) => Tab(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (e.iconData != null) ...[
//               Icon(e.iconData),
//               const SizedBox(width: 8),
//             ],
//             Text(e.text),
//           ],
//         ),
//       )).toList(),
//       onTap: onTap,
//     );
//   }
//
//   static int get tabLength => ProductTypes.values.length;
//
//   static TabBar tabBar(BuildContext context, Function(int index) onTap) {
//     return _primary(context,
//         onTap: onTap,
//         items: ProductTypes.values
//             .map((e) => TabItem(e.label, e.iconData))
//             .toList());
//   }
// }