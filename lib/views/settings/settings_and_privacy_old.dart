// import 'package:arpicoprivilege/shared/components/app_text.dart';
// import 'package:flutter/material.dart';
// import '../../core/services/configure_service.dart';
// import '../../data/models/tile_data.dart';
// import '../../shared/components/images/user_avatar.dart';
// import '../points/points_screen.dart';
//
// class SettingsAndPrivacy extends StatefulWidget {
//   const SettingsAndPrivacy({super.key});
//
//   @override
//   State<SettingsAndPrivacy> createState() => _SettingsAndPrivacyState();
// }
//
// class _SettingsAndPrivacyState extends State<SettingsAndPrivacy> {
//   final configService = ConfigService();
//   final membership = LoyaltyMembership.silver;
//
//   List<TileData> _generalSettingsTileData(BuildContext context) {
//     return [
//       TileData(
//         title: "Account Information",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Country & Region",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Language",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Currency",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Dark Mode",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Notifications",
//         onTap: (){},
//       ),
//     ];
//   }
//
//   List<TileData> _supportAndLegalTileData(BuildContext context) {
//     return [
//       TileData(
//         title: "Help Center",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Feedback",
//         onTap: (){},
//       ),
//       TileData(
//         title: "About Us",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Terms of Service",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Privacy Policy",
//         onTap: (){},
//       ),
//       TileData(
//         title: "Report a Problem",
//         onTap: (){},
//       ),
//     ];
//   }
//
//   Widget buildTile(BuildContext context, TileData tileData) {
//     return ListTile(
//       // onTap: tileData.onTap,
//       onTap: (){},
//       // leading: Icon(tileData.iconData),
//       title: Text(tileData.title!),
//       subtitle: (tileData.subtitle != null) ? Text(tileData.subtitle!, overflow: TextOverflow.ellipsis) : null,
//       trailing: const Icon(Icons.navigate_next),
//       tileColor: Theme.of(context).colorScheme.surface,
//       shape: Border(),
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//     );
//   }
//
//   Widget buildSection(BuildContext context, String title, List<TileData> tileDataList) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: AppText.boldTitle(title),
//         ),
//         ...tileDataList.asMap().map((i, tileData) =>
//             MapEntry(i, Column(
//               children: [
//                 (i != 0) ? Divider(height: 0, indent: 16, endIndent: 16) : const SizedBox.shrink(),
//                 buildTile(context, tileData),
//               ],
//             ))
//         ).values
//       ],
//     );
//   }
//
//   Widget buildDivider(BuildContext context) => Divider(height: 12, thickness: 12, color: Theme.of(context).colorScheme.surfaceContainerLowest);
//
//   Widget buildFooter(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       child: RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
//               children: [
//                 const TextSpan(
//                   text: "- Powered by -\n",
//                   // style: Theme.of(context).textTheme.bodySmall?.getTextStyle()
//                 ),
//                 TextSpan(
//                   text: "${configService.getConfig("appInfo")["department"]} - ${configService.getConfig("appInfo")["company"]}\n",
//                 ),
//                 TextSpan(
//                   text: "version ${configService.getConfig("appInfo")["version"]}",
//                 )
//               ]
//           )
//       ),
//     );
//   }
//
//   Widget buildHeader(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return FlexibleSpaceBar(
//       title: Container(
//         margin: const EdgeInsets.only(top: 16.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             InkWell(
//               onTap: (){},
//               child: const SizedBox(
//                 height: 72.0,
//                 width: 78.0,
//                 child: Stack(
//                   children: [
//                     UserAvatar(
//                       avatar: null,
//                       userName: 'Gayan',
//                       radius: 36.0,
//                     ),
//                     Align(
//                         alignment: Alignment.bottomRight,
//                         child: Icon(Icons.camera_alt_outlined)
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16.0),
//             Flexible(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Gayan Weerasinghe", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
//                     Text("+94710930444"),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget appBar(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         bool titleVisibility = constraints.maxHeight <= kToolbarHeight + MediaQuery.of(context).viewPadding.top;
//
//         return FlexibleSpaceBar(
//           title: titleVisibility
//               ? Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: Text("Account Settings"),
//               )
//               : null,
//           // centerTitle: true,
//           background: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               // color: Colors.orangeAccent,
//                 gradient: RadialGradient(
//                   colors: [
//                     membership.primaryColor.withAlpha(50),
//                     membership.primaryColor
//                   ],
//                   center: Alignment.topCenter,
//                 )),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 InkWell(
//                   onTap: (){},
//                   child: const SizedBox(
//                     height: 72.0,
//                     width: 78.0,
//                     child: Stack(
//                       children: [
//                         UserAvatar(
//                           avatar: null,
//                           userName: 'Gayan',
//                           radius: 36.0,
//                         ),
//                         Align(
//                             alignment: Alignment.bottomRight,
//                             child: Icon(Icons.camera_alt_outlined)
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text("Gayan Weerasinghe", style: TextStyle(fontSize: 24, /*color: colorScheme.surface, */fontWeight: FontWeight.bold)),
//                 Text("+94710930444", style: TextStyle(color: colorScheme.onSurfaceVariant)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             expandedHeight: 200,
//             floating: false,
//             pinned: true,
//             flexibleSpace: appBar(context),
//             actions: [
//               IconButton(onPressed: (){}, icon: Icon(Icons.search)),
//               IconButton(onPressed: (){}, icon: Icon(Icons.logout)),
//               // const SizedBox(width: 16),
//             ],
//           ),
//           SliverList.list(
//               children: [
//                 buildSection(context, "General Settings", _generalSettingsTileData(context)),
//                 buildDivider(context),
//                 buildSection(context, "Support & Legal", _supportAndLegalTileData(context)),
//                 buildDivider(context),
//                 buildFooter(context),
//               ]
//           )
//         ],
//       ),
//     );
//   }
//
// }
