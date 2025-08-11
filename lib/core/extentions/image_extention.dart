import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

extension ImageExtention on Image {
  static Image networkWithPlaceholder(
      String url, {
        BoxFit fit = BoxFit.cover,
        Widget? placeholder,
      }) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Use the provided placeholder or default to a generic one
        return placeholder ??
            Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              highlightColor: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Container(color: Theme.of(context).colorScheme.surfaceContainer),
            );
      },
    );
  }

}
