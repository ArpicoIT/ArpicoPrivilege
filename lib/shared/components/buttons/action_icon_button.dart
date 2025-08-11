import 'package:flutter/material.dart';

import '../../../app/app.dart';
import '../../../app/app_routes.dart';

class ActionIconButton {

  final BuildContext context;

  ActionIconButton._(this.context);

  static ActionIconButton of(BuildContext context) {
    return ActionIconButton._(context);
  }

  Color _getBackgroundColor(bool value) => value ? ColorScheme.of(context).surfaceDim.withAlpha(200) : WidgetStateColor.transparent;

  Widget _defButton({
    VoidCallback? onTap,
    required IconData iconData,
    bool withBackground = false,
  }) {
    return CircleAvatar(
      backgroundColor: _getBackgroundColor(withBackground),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(iconData),
      ),
    );
  }

  Widget notification({bool withBackground = false}) => _defButton(
    onTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
    iconData: Icons.notifications_outlined,
    withBackground: withBackground,
  );

  Widget search({bool withBackground = false}) => _defButton(
    onTap: () => Navigator.of(context).pushNamed(AppRoutes.search),
    iconData: Icons.search,
    withBackground: withBackground,
  );

  Widget contactSupport({bool withBackground = false}) => _defButton(
    onTap: () => Navigator.of(context).pushNamed(AppRoutes.helpCenter),
    iconData: Icons.contact_support_outlined,
    withBackground: withBackground,
  );

  Widget menu({bool withBackground = false, required List<String> items}) {
    List<Map<String, dynamic>> menuList = [
      {
        "key": "home",
        "label": "Home",
        // "icon": Icons.home,
        "route": AppRoutes.appHome,
      },
      {
        "key": "settings",
        "label": "Settings",
        // "icon": Icons.settings,
        "route": AppRoutes.settings,
      },
      {
        "key": "notifications",
        "label": "Notifications",
        // "icon": Icons.notifications,
        "route": AppRoutes.notifications,
      },
    ];

    // List<Map<String, dynamic>> menuItems = menuList.where((item) {
    //   return true;
    //   return item["route"] != RouteObserverService.currentRoute;
    // }).toList();

    List<Map<String, dynamic>> menuItems = menuList.where((i) => items.contains(i["key"])).toList();

    menuItems.removeWhere((item) =>
        item["route"] == RouteObserverService.previousRoute &&
        item["key"] != "home");

    return CircleAvatar(
      backgroundColor: _getBackgroundColor(withBackground),
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          switch (value) {
            case "home":
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
              break;
            case "settings":
              Navigator.of(context).pushNamed(AppRoutes.settings);
              break;
            case "notifications":
              Navigator.of(context).pushNamed(AppRoutes.notifications);
              break;
          }
          debugPrint("Selected: $value");
        },
        position: PopupMenuPosition.under,
        tooltip: 'Menu',
        itemBuilder: (BuildContext context) {
          return menuItems.map((Map<String, dynamic> item) {
            return PopupMenuItem<String>(
              value: item["key"],
              child: Row(
                children: [
                  if (item["icon"] != null) ...[
                    Icon(item["icon"]),
                    const SizedBox(width: 12),
                  ],
                  Text(item["label"])
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }
}

/// v1.0
// class ActionIconButton {
//   static Widget notification(BuildContext context) {
//     return IconButton(
//         onPressed: () =>
//             Navigator.of(context).pushNamed(AppRoutes.notifications),
//         icon: Icon(Icons.notifications_outlined));
//   }
//
//   static Widget search(BuildContext context) {
//     return IconButton(
//         onPressed: () => Navigator.of(context).pushNamed(AppRoutes.search),
//         icon: Icon(Icons.search));
//   }
//
//   static Widget contactSupport(BuildContext context) {
//     return IconButton(
//         onPressed: () => Navigator.of(context).pushNamed(AppRoutes.helpCenter),
//         icon: Icon(Icons.contact_support_outlined));
//   }
//
//   static Widget menu(BuildContext context, {bool withBackground = false}) {
//     List<Map<String, dynamic>> menuList = [
//       {
//         "key": "home",
//         "label": "Home",
//         // "icon": Icons.home,
//         "route": AppRoutes.appHome,
//       },
//       {
//         "key": "settings",
//         "label": "Settings",
//         // "icon": Icons.settings,
//         "route": AppRoutes.settings,
//       },
//       {
//         "key": "notifications",
//         "label": "Notifications",
//         // "icon": Icons.notifications,
//         "route": AppRoutes.notifications,
//       },
//     ];
//
//     List<Map<String, dynamic>> items = menuList.where((item) {
//       return true;
//       return item["route"] != RouteObserverService.currentRoute;
//     }).toList();
//
//     items.removeWhere((item) =>
//         item["route"] == RouteObserverService.previousRoute &&
//         item["key"] != "home");
//
//     return CircleAvatar(
//       backgroundColor: withBackground ? ColorScheme.of(context).surfaceDim.withAlpha(200) : WidgetStateColor.transparent,
//       child: PopupMenuButton<String>(
//         onSelected: (String value) {
//           switch (value) {
//             case "home":
//               Navigator.of(context)
//                   .pushNamedAndRemoveUntil(AppRoutes.appHome, (route) => false);
//               break;
//             case "settings":
//               Navigator.of(context).pushNamed(AppRoutes.settings);
//               break;
//             case "notifications":
//               Navigator.of(context).pushNamed(AppRoutes.notifications);
//               break;
//           }
//           debugPrint("Selected: $value");
//         },
//         position: PopupMenuPosition.under,
//         tooltip: 'Menu',
//         itemBuilder: (BuildContext context) {
//           return items.map((Map<String, dynamic> item) {
//             return PopupMenuItem<String>(
//               value: item["key"],
//               child: Row(
//                 children: [
//                   if (item["icon"] != null) ...[
//                     Icon(item["icon"]),
//                     const SizedBox(width: 12),
//                   ],
//                   Text(item["label"])
//                 ],
//               ),
//             );
//           }).toList();
//         },
//       ),
//     );
//   }
//
//   // static Widget buildPeriodSelectionButton(BuildContext context) {
//   //   List<String> items = ["Home", "Account", "Notifications"];
//   //   return DropdownButtonHideUnderline(
//   //     child: DropdownButton2<String>(
//   //       isExpanded: true,
//   //       isDense: true,
//   //       items: items
//   //           .map((item) => DropdownMenuItem<String>(
//   //                 value: item,
//   //                 child: Text(item),
//   //               ))
//   //           .toList(),
//   //       // value: selectedPeriod,
//   //       onChanged: (value) {
//   //         // setState(() {
//   //         //   selectedPeriod = value!;
//   //         // });
//   //       },
//   //       buttonStyleData: const ButtonStyleData(
//   //         padding: EdgeInsets.symmetric(horizontal: 6.0),
//   //         width: 132.0,
//   //       ),
//   //       menuItemStyleData: const MenuItemStyleData(height: 42.0),
//   //     ),
//   //   );
//   // }
// }
