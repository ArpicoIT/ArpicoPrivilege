
import 'package:flutter/material.dart';

import '../../core/services/configure_service.dart';

class AppName extends StatelessWidget {
  final bool sloganVisibility;
  final double appNameSize;
  final double sloganSize;

  AppName({
    super.key,
    this.appNameSize = 45.0,
    this.sloganSize = 24.0,
    this.sloganVisibility = false,
  }) : isPlaceholder = false,
        dynamicSize = false;

  AppName.placeholder({
    super.key,
    this.appNameSize = 45.0,
    this.sloganSize = 22.0,
    this.sloganVisibility = false,
  }) : isPlaceholder = true,
        dynamicSize = false;

  AppName.dynamicPlaceholder({
    super.key,
    this.sloganVisibility = false,
  }) : isPlaceholder = true,
        dynamicSize = true,
        appNameSize = 24.0,
        sloganSize = 18.0;

  late bool isPlaceholder;
  late bool dynamicSize;

  @override
  Widget build(BuildContext context) {
    final ConfigService configService = ConfigService();
    final String appName =
        configService.getConfig("appInfo")["name"].toString();
    final String slogan =
        configService.getConfig("appInfo")["slogan"].toString();
    final colorScheme = Theme.of(context).colorScheme;

    final namePart1 = _splitAppName(0, appName);
    final namePart2 = _splitAppName(1, appName);

    return !isPlaceholder
        ? _withColor(context, colorScheme,
            namePart1: namePart1, namePart2: namePart2, slogan: slogan)
        : !dynamicSize ? _withoutColor(context, colorScheme,
            namePart1: namePart1, namePart2: namePart2, slogan: slogan)
        : _withDynamicSize(context, colorScheme,
        namePart1: namePart1, namePart2: namePart2, slogan: slogan);
  }

  Widget _withColor(BuildContext context, ColorScheme colorScheme, {String? namePart1, String? namePart2, String? slogan}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      color: colorScheme.onSurface, fontSize: appNameSize, fontWeight: FontWeight.w500),
                  children: [
                    if (namePart1 != null) TextSpan(text: namePart1),
                    if (namePart2 != null)
                      TextSpan(
                        text: namePart2,
                        style: TextStyle(color: colorScheme.secondary),
                      ),
                    // if (sloganVisibility)
                    //   TextSpan(
                    //     text: "\n$slogan",
                    //     style: TextStyle(
                    //       // color: colorScheme.onSurfaceVariant,
                    //       fontSize: sloganSize,
                    //     ),
                    //   ),
                  ])),
          if (sloganVisibility)
            ...[
              const SizedBox(height: 16),
              Text(
                "$slogan",
                style: TextStyle(
                  // color: colorScheme.onSurfaceVariant,
                  fontSize: sloganSize,
                  fontWeight: FontWeight.w500
                ),
              ),
            ]
          else
            const SizedBox.shrink()

        ],
      );

  Widget _withoutColor(BuildContext context, ColorScheme colorScheme,
          {String? namePart1, String? namePart2, String? slogan}) =>
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: TextStyle(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  fontSize: appNameSize),
              children: [
                if (namePart1 != null) TextSpan(text: namePart1),
                if (namePart2 != null)
                  TextSpan(
                    text: namePart2,
                    style: TextStyle(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.3)),
                  ),
                if (sloganVisibility)
                  TextSpan(
                    text: "\n$slogan",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.2),
                      fontSize: sloganSize,
                    ),
                  ),
              ]));

  Widget _withDynamicSize(BuildContext context, ColorScheme colorScheme,
      {String? namePart1, String? namePart2, String? slogan}) =>
      LayoutBuilder(
        builder: (context, constraints) {

          // Map constraints.maxWidth to a dynamic size
          // final double adjustedAppNameSize = _adjustSize(
          //   constraints.maxWidth,
          //   minSize: appNameSize,
          //   maxSize: 100.0,
          //   minWidth: 120.0,
          //   maxWidth: 1000.0,
          // );
          //
          // final double adjustedSloganSize = _adjustSize(
          //   constraints.maxWidth,
          //   minSize: sloganSize,
          //   maxSize: 50.0,
          //   minWidth: 120.0,
          //   maxWidth: 1000.0,
          // );


          final double maxWidth = constraints.maxWidth;

          // Calculate dynamic font sizes
          final double appNameFontSize = _calculateFontSize(
            text: "$namePart1 $namePart2",
            maxWidth: maxWidth,
            minFontSize: 24.0,
            maxFontSize: 42.0,
          );

          final double sloganFontSize = _calculateFontSize(
            text: slogan??'',
            maxWidth: maxWidth,
            minFontSize: 18.0,
            maxFontSize: 25.0,
          );

          return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.25),
                      fontSize: appNameFontSize),
                  children: [
                    if (namePart1 != null) TextSpan(text: namePart1),
                    if (namePart2 != null)
                      TextSpan(
                        text: namePart2,
                        style: TextStyle(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.2)),
                      ),
                    if (sloganVisibility && slogan != null)
                      TextSpan(
                        text: "\n$slogan",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.15),
                          fontSize: sloganFontSize,
                        ),
                      ),
                  ]));
        }
      );

  String? _splitAppName(int index, String? appName) {
    try {
      return appName?.split(' ')[index];
    } catch (e) {
      return null;
    }
  }

  double _adjustSize(
      double currentWidth, {
        required double minSize,
        required double maxSize,
        required double minWidth,
        required double maxWidth,
      }) {
    // Scale the size linearly based on the current width
    if (currentWidth <= minWidth) return minSize;
    if (currentWidth >= maxWidth) return maxSize;

    final double scale = (currentWidth - minWidth) / (maxWidth - minWidth);
    return minSize + (maxSize - minSize) * scale;
  }

  double _calculateFontSize({
    required String text,
    required double maxWidth,
    required double minFontSize,
    required double maxFontSize,
  }) {
    // Estimate font size based on character count and max width
    final int charCount = text.length;
    if (charCount == 0) return minFontSize;

    // Calculate potential font size
    final double calculatedFontSize = (maxWidth / charCount) * 1.4;
    return calculatedFontSize;

    // Clamp to min and max sizes
    // return calculatedFontSize.clamp(minFontSize, maxFontSize);
  }
}
