
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageHandler {

  static Future<Color> getBackgroundColor(String? image, [Color initialColor = Colors.transparent]) async {
    try {
      ImageProvider imageProvider;

      if (image == null || image.isEmpty) {
        return initialColor;
      } else if (isNetworkImage(image)) {
        imageProvider = NetworkImage(image);
      } else {
        imageProvider = AssetImage(image);
      }

      final PaletteGenerator paletteGenerator = await PaletteGenerator
          .fromImageProvider(imageProvider);
      return paletteGenerator.dominantColor?.color ?? Colors.white;
    } catch (e) {
      return initialColor;
    }
  }

  static bool isNetworkImage(String imagePath) {
    // Check if the path is a valid URL
    final uri = Uri.tryParse(imagePath);
    return uri != null && (uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https'));
  }
}