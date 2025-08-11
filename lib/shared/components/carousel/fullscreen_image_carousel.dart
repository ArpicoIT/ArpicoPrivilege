import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../image_with_placeholder.dart';

class FullscreenImageCarousel extends StatelessWidget {
  /// List of image URLs for the carousel
  final String current;
  final List<String> list;

  FullscreenImageCarousel({super.key, required this.current, required this.list})
      : assert(list.isNotEmpty, 'Image list cannot be empty'),
        _initialPage = list.indexOf(current),
        _currentIndexNotifier = ValueNotifier<int>(list.indexOf(current));

  static Future<void> show(BuildContext context, {
    required String current,
    required List<String> list
  }) async{
    await showDialog(
      barrierColor: kBackgroundColor,
        context: context,
        useSafeArea: false,
        builder: (context)=> FullscreenImageCarousel(current: current, list: list)
    );
  }

  static final Color kBackgroundColor = Colors.black87;
  final Color kForegroundColor = Colors.white;

  final CarouselSliderController _carouselController = CarouselSliderController();
  late final ValueNotifier<int> _currentIndexNotifier;
  late final int _initialPage;

  int get itemCount => list.length;


  Widget get title => ValueListenableBuilder<int>(valueListenable: _currentIndexNotifier, builder: (context, value, child) => Text('${value+1} / $itemCount'));


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        foregroundColor: kForegroundColor,
        title: title,
        centerTitle: true,
        // leading: IconButton(onPressed: (){}, icon: Icon(Icons.close)),
        // actions: [
        //   IconButton(onPressed: (){}, icon: const Icon(Icons.photo))
        // ],
      ),
      body: CarouselSlider.builder(
        itemCount: itemCount,
        itemBuilder: (context, index, _) {
          final Widget child = ImageWithPlaceholder(
            list[index],
            fit: BoxFit.contain,
          );
          return child;
        },
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          viewportFraction: 0.9,
          aspectRatio: 9/16,
          initialPage: _initialPage,
          onPageChanged: (index, reason) {
            _currentIndexNotifier.value = index; // Update the current index
          },
        ),
        carouselController: _carouselController,
      ),
    );
  }
}