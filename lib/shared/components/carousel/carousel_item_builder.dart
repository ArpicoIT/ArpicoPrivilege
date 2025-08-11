import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
export 'package:carousel_slider/carousel_slider.dart';

enum CslIndicatorType { dots, counter, none }

class CarouselIndicator {
  final CslIndicatorType type;
  final Color backgroundColor;
  final Color foregroundColor;
  final ShapeBorder? shape;
  final AlignmentGeometry alignment;

  const CarouselIndicator(
      {
        this.type = CslIndicatorType.none,
        this.backgroundColor =
        const Color(0x61000000), // Equivalent to Colors.black38
        this.foregroundColor =
        const Color(0xFFFFFFFF), // Equivalent to Colors.white
        this.shape,
        this.alignment = Alignment.bottomCenter
      });

// CarouselIndicator.dots(this.type, this.backgroundColor, this.foregroundColor, this.shape);
// CarouselIndicator.counter(this.type, this.backgroundColor, this.foregroundColor, this.shape);
}

class CarouselItemBuilder<T> extends StatelessWidget {
  /// List of image URLs for the carousel
  final List<T> items;

  /// A builder function to customize the display of each image
  final Widget Function(BuildContext context, T item, Widget child)? builder;

  /// Carousel options for configuring behavior
  final CarouselOptions options;

  /// A callback for when an image is tapped
  final Function(T item)? onTap;

  // final CarouselIndicatorType indicator;

  /// Customization arguments for the indicator
  final CarouselIndicator indicator;

  final Function(T item)? onChangedItem;

  final Function(String color)? didGetColor;

  /// Constructor
  CarouselItemBuilder({
    super.key,
    required this.items,
    this.builder,
    required this.options,
    this.onTap,
    this.indicator = const CarouselIndicator(),
    this.onChangedItem,
    this.didGetColor,

  }) : assert(items.isNotEmpty, 'items cannot be empty');

  final CarouselSliderController _carouselController = CarouselSliderController();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  bool isBuiltInitialImage = false;

  @override
  Widget build(BuildContext context) {
    final int itemCount = items.length;

    return AspectRatio(
      aspectRatio: options.aspectRatio,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: itemCount,
            itemBuilder: (context, index, _) {

              final T item = items[index];

              if(!isBuiltInitialImage) {
                Future.delayed(const Duration(milliseconds: 400), (){
                  onChangedItem?.call(item);
                });
                isBuiltInitialImage = true;
              }

              final Widget child = const SizedBox.shrink();

              return Stack(
                children: [
                  Positioned.fill(
                      child: builder?.call(context, item, child) ?? child),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: () => onTap?.call(item)),
                  ),
                ],
              );
            },
            options: options.copyWith(
              onPageChanged: (index, reason) {
                onChangedItem?.call(items[index]);
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
