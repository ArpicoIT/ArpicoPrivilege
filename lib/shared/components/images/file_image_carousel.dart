// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// import '../image_with_placeholder.dart';
//
// export 'package:carousel_slider/carousel_slider.dart';
//
// class NetworkImageCarousel extends StatelessWidget {
//   /// List of image URLs for the carousel
//   final List<String> imageUrls;
//
//   /// A builder function to customize the display of each image
//   final Widget Function(BuildContext context, String url, Widget child)? builder;
//
//   /// Carousel options for configuring behavior
//   final CarouselOptions options;
//
//   /// A callback for when an image is tapped
//   final Function(String url)? onTap;
//
//   // final CarouselIndicatorType indicator;
//
//   /// Customization arguments for the indicator
//   final CarouselIndicator indicator;
//
//   /// Constructor
//   NetworkImageCarousel({
//     super.key,
//     required this.imageUrls,
//     this.builder,
//     required this.options,
//     this.onTap,
//     this.indicator = const CarouselIndicator(),
//   }) : assert(imageUrls.isNotEmpty, 'imageUrls cannot be empty');
//
//   final CarouselSliderController _carouselController =
//   CarouselSliderController();
//   final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
//
//   @override
//   Widget build(BuildContext context) {
//     final int itemCount = imageUrls.length;
//
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         CarouselSlider.builder(
//           itemCount: itemCount,
//           itemBuilder: (context, index, _) {
//             final Widget child = NetworkImageWithPlaceholder(imageUrls[index]);
//
//             return Stack(
//               children: [
//                 Positioned.fill(
//                     child: builder?.call(context, imageUrls[index], child) ?? child),
//                 Material(
//                   color: Colors.transparent,
//                   child: InkWell(onTap: () => onTap?.call(imageUrls[index])),
//                 ),
//               ],
//             );
//           },
//           options: options.copyWith(
//             onPageChanged: (index, reason) {
//               _currentIndexNotifier.value = index; // Update the current index
//             },
//           ),
//           carouselController: _carouselController,
//         ),
//         if (indicator.type != CslIndicatorType.none)
//           Positioned(
//             bottom: 8.0,
//             child: ValueListenableBuilder<int>(
//               valueListenable: _currentIndexNotifier,
//               builder: (context, currentIndex, child) {
//                 switch (indicator.type) {
//                   case CslIndicatorType.dots:
//                     return _buildDots(currentIndex, itemCount);
//                   case CslIndicatorType.counter:
//                     return _buildCounter(currentIndex, itemCount);
//                   case CslIndicatorType.none:
//                     return const SizedBox.shrink();
//                 }
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildDots(int index, int length) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         for (int i in Iterable.generate(length))
//           if (index == i)
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 2.0),
//               child: Icon(Icons.circle, size: 12, color: Colors.grey),
//             )
//           else
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 2.0),
//               child: Icon(Icons.circle,
//                   size: 10, color: Colors.grey.withAlpha(50)),
//             )
//       ],
//     );
//   }
//
//   Widget _buildCounter(int index, int length) {
//     return Material(
//         shape: indicator.shape,
//         color: indicator.backgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//           child: Text('${index + 1} / $length',
//               style: TextStyle(
//                   color: indicator.foregroundColor, fontSize: 12.0),
//               textAlign: TextAlign.center),
//         ));
//   }
// }
