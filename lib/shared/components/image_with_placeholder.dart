import 'dart:io';

import 'package:flutter/material.dart';
import '../../core/utils/image_handler.dart';
import '../../shared/components/app_name.dart';

class ImageWithPlaceholder extends StatelessWidget {
  final String? image;
  final BoxFit fit;
  final Widget? placeholder;
  final String? placeAssetPath;
  final Duration fadeInDuration;

  const ImageWithPlaceholder(
    this.image, {
    super.key,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.placeAssetPath,
    this.fadeInDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    final dynamicAppName = Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: AppName.dynamicPlaceholder(),
    );

    final placeAsset =
        (placeAssetPath != null) ? Image.asset(placeAssetPath!) : null;

    if (image == null) {
      return placeholder ?? placeAsset ?? dynamicAppName;
    } else if (ImageHandler.isNetworkImage(image!)) {
      return Image.network(
        image!,
        fit: fit,
        // Placeholder for error
        errorBuilder: (context, error, stackTrace) {
          return placeholder ?? placeAsset ?? dynamicAppName;
        },
        // Placeholder while loading
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return placeholder ?? placeAsset ?? dynamicAppName;
          }
        },
        // Fade-in effect when the image is loaded
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child; // Show immediately if already loaded
          }
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: fadeInDuration,
            curve: Curves.easeIn,
            child: child,
          );
        },
      );
    } else if (image!.startsWith("file://")) {
      final file = File(Uri.parse(image!).path); // Convert URI to file path
      return Image.file(
        file,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return placeholder ?? placeAsset ?? dynamicAppName;
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: fadeInDuration,
            curve: Curves.easeIn,
            child: child,
          );
        },
      );
    } else {
      return Image.asset(
        image!,
        fit: fit,
        // Placeholder for error
        errorBuilder: (context, error, stackTrace) {
          return placeholder ?? placeAsset ?? dynamicAppName;
        },
        // Fade-in effect when the image is loaded
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child; // Show immediately if already loaded
          }
          return AnimatedOpacity(
            opacity: frame == null
                ? 0
                : 1, // Fade-in once the first frame is available
            duration: fadeInDuration,
            curve: Curves.easeIn,
            child: child,
          );
        },
      );
    }
  }
}

/*class NetworkImageWithPlaceholder extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final Widget? placeholder;
  final Duration fadeInDuration;

  const NetworkImageWithPlaceholder(this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.fadeInDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {

    final dynamicAppName = Container(
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: AppName.dynamicPlaceholder(),
    );

    return Image.network(
      url??'https://',
      fit: fit,
      // Placeholder for error
      errorBuilder: (context, error, stackTrace) {
        return placeholder ?? dynamicAppName;
      },
      // Placeholder while loading
      loadingBuilder: (context, child, loadingProgress) {
        if(loadingProgress == null) {
          return child;
        } else {
          return placeholder ?? dynamicAppName;
        }
      },
      // Fade-in effect when the image is loaded
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child; // Show immediately if already loaded
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1, // Fade-in once the first frame is available
          duration: fadeInDuration,
          curve: Curves.easeIn,
          child: child,
        );
      },
    );
  }
}*/
