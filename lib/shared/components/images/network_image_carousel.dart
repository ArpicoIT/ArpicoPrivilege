import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../carousel/carousel_item_builder.dart';
import '../image_with_placeholder.dart';

export 'package:carousel_slider/carousel_slider.dart';

// enum CslIndicatorType { dots, counter, none }
//
// class CarouselIndicator {
//   final CslIndicatorType type;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final ShapeBorder? shape;
//   final AlignmentGeometry alignment;
//
//   const CarouselIndicator(
//       {
//         this.type = CslIndicatorType.none,
//         this.backgroundColor =
//         const Color(0x61000000), // Equivalent to Colors.black38
//         this.foregroundColor =
//         const Color(0xFFFFFFFF), // Equivalent to Colors.white
//         this.shape,
//         this.alignment = Alignment.bottomCenter
//       });
//
//   // CarouselIndicator.dots(this.type, this.backgroundColor, this.foregroundColor, this.shape);
//   // CarouselIndicator.counter(this.type, this.backgroundColor, this.foregroundColor, this.shape);
// }

class ImageCarousel extends StatelessWidget {
  /// List of image URLs for the carousel
  final List<String> images;

  /// A builder function to customize the display of each image
  final Widget Function(BuildContext context, String url, Widget child)? builder;

  /// Carousel options for configuring behavior
  final CarouselOptions options;

  /// A callback for when an image is tapped
  final Function(String url)? onTap;

  // final CarouselIndicatorType indicator;

  /// Customization arguments for the indicator
  final CarouselIndicator indicator;

  final Function(String image)? didBuildImage;

  final Function(String color)? didGetColor;

  /// Constructor
  ImageCarousel({
    super.key,
    required this.images,
    this.builder,
    required this.options,
    this.onTap,
    this.indicator = const CarouselIndicator(),
    this.didBuildImage,
    this.didGetColor,

  }) : assert(images.isNotEmpty, 'imageUrls cannot be empty');

  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  bool isBuiltInitialImage = false;

  @override
  Widget build(BuildContext context) {
    final int itemCount = images.length;

    return AspectRatio(
      aspectRatio: options.aspectRatio,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: itemCount,
            itemBuilder: (context, index, _) {
              final String image = images[index];
              // didGetColor?.call(image);

              if(!isBuiltInitialImage) {
                Future.delayed(const Duration(milliseconds: 400), (){
                  didBuildImage?.call(image);
                });
                isBuiltInitialImage = true;
              }

              final Widget child = ImageWithPlaceholder(image);

              return Stack(
                children: [
                  Positioned.fill(
                      child: builder?.call(context, image, child) ?? child),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: () => onTap?.call(image)),
                  ),
                ],
              );
            },
            options: options.copyWith(
              onPageChanged: (index, reason) {
                didBuildImage?.call(images[index]);
                _currentIndexNotifier.value = index; // Update the current index
              },
            ),
            carouselController: _carouselController,
          ),
          if (indicator.type != CslIndicatorType.none)
            Align(
              alignment: indicator.alignment,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentIndexNotifier,
                  builder: (context, currentIndex, child) {
                    switch (indicator.type) {
                      case CslIndicatorType.dots:
                        return _buildDots(currentIndex, itemCount);
                      case CslIndicatorType.counter:
                        return _buildCounter(currentIndex, itemCount);
                      case CslIndicatorType.none:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDots(int index, int length) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i in Iterable.generate(length))
          if (index == i)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(Icons.circle, size: 12, color: Colors.grey),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(Icons.circle,
                  size: 10, color: Colors.grey.withAlpha(50)),
            )
      ],
    );
  }

  Widget _buildCounter(int index, int length) {
    return Material(
        shape: indicator.shape,
        color: indicator.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text('${index + 1}/$length',
              style: TextStyle(
                  color: indicator.foregroundColor, fontSize: 12.0),
              textAlign: TextAlign.center),
        ));
  }
}
