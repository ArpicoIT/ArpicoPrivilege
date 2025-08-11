import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomToast {
  final BuildContext context;

  // Private constructor with context
  CustomToast._(this.context);

  // Factory constructor to create instance with context
  static CustomToast of(BuildContext context) {
    return CustomToast._(context);
  }

  /// Show toast
  void showPrimary(String message, [int millis = 4000]) {
    final colorScheme = Theme.of(context).colorScheme;

    final snackBar = SnackBar(
      elevation: 0,
      backgroundColor: WidgetStateColor.transparent,
      content: Center(
        child: Card(
          color: colorScheme.inverseSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
                message, style: TextStyle(color: colorScheme.onInverseSurface)
            ),
          ),
        ),
      ),
      duration: Duration(milliseconds: millis),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(24),
    );

    // final snackBar = SnackBar(
    //   elevation: 0,
    //   backgroundColor: WidgetStateColor.transparent,
    //   // content: Text(message),
    //   content: SizedBox.fromSize(
    //     size: MediaQuery.of(context).size,
    //     child: Center(
    //       child: Card(
    //         color: colorScheme.inverseSurface,
    //         child: Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: Text(
    //               message, style: TextStyle(color: colorScheme.onInverseSurface)
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    //   duration: Duration(milliseconds: millis),
    //   behavior: SnackBarBehavior.fixed,
    //   // margin: const EdgeInsets.all(24),
    // );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show toast with close
  void showWithAction(String message, String label, Function() onTap, [int millis = 4000]) {
    final colorScheme = Theme.of(context).colorScheme;
    final snackBarTheme = Theme.of(context).snackBarTheme;

    final snackBar = SnackBar(
      elevation: 0,
      content: RichText(
        text: TextSpan(
          style: snackBarTheme.contentTextStyle,
          children: [
            TextSpan(text: message),
            TextSpan(
              text: ' $label',
              style: TextStyle(color: colorScheme.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = onTap,
            ),
          ],
        ),
      ),
      duration: Duration(milliseconds: millis),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(24),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show toast with close
  void showWithClose(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      margin: const EdgeInsets.all(24),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}