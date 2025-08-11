import 'package:flutter/material.dart';

class OffersScreen extends StatefulWidget {
  final bool showAppBar;
  const OffersScreen({super.key, this.showAppBar = true});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {

  @override
  void initState() {
    super.initState();
    print("Init offers screen");

    WidgetsBinding.instance.addPostFrameCallback((_){});
  }

  @override
  Widget build(BuildContext context) {
    return Container();

    // return Scaffold(
    //     appBar: appBar,
    //     body: Container(
    //       // padding: const EdgeInsets.all(12.0),
    //       child: SingleChildScrollView(
    //         child: LayoutBuilder(
    //             builder: (context, constraints){
    //               return Column(
    //                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                 children: [
    //                   CarouselWithDots(
    //                     images: testOffers,
    //                   ),
    //                   const SizedBox(height: 12.0),
    //                   Container(
    //                     margin: const EdgeInsets.all(12.0),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         PromotionWidgets.promoCategory(context, 'Limited Time', Icons.timer, Colors.green),
    //                         PromotionWidgets.promoCategory(context, 'Flash Sales', Icons.flash_on, Colors.orangeAccent),
    //                         PromotionWidgets.promoCategory(context, 'Rewards', Icons.card_giftcard, Colors.blue),
    //                         // OfferWidgets.promoCategory(context, 'Reward', Icons.card_giftcard, Colors.red),
    //                       ],
    //                     ),
    //                   ),
    //                   Container(
    //                     margin: const EdgeInsets.all(12.0),
    //                     child: Wrap(
    //                       runSpacing: 12.0,
    //                       children: [
    //                         PromotionWidgets.promoItem(context, 'Clearance Sale', 'Up to 70% off on select items'),
    //                         PromotionWidgets.promoItem(context, 'Member Only Deals', 'Exclusive 30% discount for members'),
    //                         PromotionWidgets.promoItem(context, 'Refer a Friend', 'Earn \$10 for each referral'),
    //
    //                         PromotionWidgets.promoItem(context, 'Weekend Mega Deal', 'Save up to 40% on all categories. Limited time only!'),
    //                       ]
    //                     ),
    //                   ),
    //
    //                   Container(
    //                     margin: const EdgeInsets.all(12.0),
    //                     child: Wrap(
    //                       runSpacing: 12.0,
    //                       children: [
    //                         // OfferWidgets.disItem(context, 'Clearance Sale', 'Up to 70% off on select items'),
    //                       ],
    //                     ),
    //                   ),
    //
    //                   // Text("Your Offers", style: Theme.of(context).textTheme.titleMedium),
    //                 ],
    //               );
    //             }
    //         ),
    //       ),
    //     )
    // );
  }

  // PreferredSizeWidget? get appBar => widget.showAppBar ? AppBar(
  //   title: const Text("Arpico Offers"),
  //   backgroundColor: Theme.of(context).colorScheme.surface,
  //   foregroundColor: Theme.of(context).colorScheme.onSurface,
  //   scrolledUnderElevation: 0,
  // ) : null;
  //
  // final List<String> testOffers = [
  //   "assets/offers/offer1.jpg",
  //   "assets/offers/offer2.jpg",
  //   "assets/offers/offer2.jpg",
  //   "assets/offers/offer3.jpg",
  //   "assets/offers/offer4.jpg",
  //   "assets/offers/offer5.jpg",
  //   "assets/offers/offer6.jpg"
  // ];
}

// class PromotionWidgets {
//
//   // Widget for promotion banners
//   static Widget promoBanners(BuildContext context, List<String> images){
//     return CarouselWithDots(images: images);
//   }
//
//   // Widget for promotion category
//   static Widget promoCategory(BuildContext context, String title, IconData icon, Color color) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return InkWell(
//       borderRadius: AppStyles.radiusAllS,
//       onTap: (){},
//       child: Container(
//         padding: const EdgeInsets.all(8.0),
//         // height: 84.0,
//         decoration: BoxDecoration(
//             // color: Colors.red,
//           borderRadius: AppStyles.radiusAllS,
//           border: Border.all(color: colorScheme.outline.withAlpha(300))
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: color, size: 28.0),
//             const SizedBox(height: 4.0),
//             Text(title),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget for a single promotion item
//   static Widget promoItem(BuildContext context, String title, String subtitle) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return ListTile(
//       // leading: CircleAvatar(
//       //   backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//       // ),
//       shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusAllS),
//       tileColor: colorScheme.surfaceContainer,
//       title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text(subtitle),
//       trailing:  InkWell(
//         onTap: (){},
//         child: Text('Shop Now', style: TextStyle(color: colorScheme.primary))
//       ),
//       titleAlignment: ListTileTitleAlignment.top,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
//       minVerticalPadding: 8.0,
//       // onTap: (){},
//     );
//   }
//
//   // Widget for discount item
//   static Widget disItem(BuildContext context, String image, String description) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Container(
//       width: 120,
//       height: 120,
//       child: Card(
//         elevation: 0,
//         margin: EdgeInsets.zero,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBUa8JR-zE7xEZ6opibLgTLnVGnMV4tohTvA&s",
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, _, __) => const SizedBox.shrink(),
//               ),
//             ),
//             Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: () {},
//                 // splashColor: Colors.white.withOpacity(0.3), // Optional: customize splash color
//                 // highlightColor: Colors.transparent, // Optional: customize highlight color
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



