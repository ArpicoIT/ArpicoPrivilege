import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum VerificationStatus { verified, unverified, unknown, waiting }

class FormWidgets {
  static Widget verificationIndicatorBuilder(
    BuildContext context, {
    required ValueNotifier<VerificationStatus> stateListener,
    required String hintText,
    required VoidCallback onPressed,
  }) {
    return ValueListenableBuilder(
      valueListenable: stateListener,
      builder: (context, state, _) {
        final colorScheme = Theme.of(context).colorScheme;
        Widget icon;
        String? message;

        switch (state) {
          case VerificationStatus.verified:
            icon =
                const Icon(Icons.check_circle, color: Colors.green, size: 24);
            message = 'Your $hintText is confirmed';
            break;
          case VerificationStatus.unverified:
            icon = Text('Verify', style: TextStyle(color: colorScheme.error));
            // icon = Icon(Icons.info, color: colorScheme.error, size: 24);
            message = 'Your $hintText must be verified first.';
            break;
          case VerificationStatus.unknown:
            icon = Text('Verify', style: TextStyle(color: colorScheme.primary));
            message = ''; //'Please verify your $hintText to proceed.';
            break;
          case VerificationStatus.waiting:
            icon = CupertinoActivityIndicator();
            message = 'Verifying...!';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Tooltip(
              message: message,
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(8),
                    minimumSize: Size.zero
                ),
                child: icon,
              )),
        );
      },
    );
  }

  static Widget titleBuilder(BuildContext context,
      {String? title, String? hint, EdgeInsetsGeometry? padding}) {
    return title != null
        ? Padding(
            padding: padding ?? const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(
                  text: title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(text: hint, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))
                  ]),
            ),
          )
        : const SizedBox.shrink();
  }

  static Widget suffixWithCloseBuilder(BuildContext context, {
    bool hasClearButton = false,
    required ValueNotifier<bool> valueListenable,
    required Function() onPressed,
    Widget? suffix
  }){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(hasClearButton)
          ValueListenableBuilder(
            valueListenable: valueListenable,
            builder: (context, value, child) {
              if(!value) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.only(right: suffix == null ? 8 : 0),
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.cancel),
                  style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero
                  ),
                ),
              );
            },
          )
        else
          const SizedBox.shrink(),

        suffix ?? const SizedBox.shrink()
      ],
    );
  }

  static Widget clearButtonBuilder(BuildContext context, {
    bool visibility = false,
    required ValueNotifier<bool> valueListenable,
    required Function() onPressed,
    bool hasSuffix = false,
  }){
    return visibility
        ? ValueListenableBuilder(
        valueListenable: valueListenable,
        builder: (context, value, child) {
          if(!value) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(right: hasSuffix ? 0 : 12), // 0:8
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.cancel),
            ),
          );
        },
      )
        : const SizedBox.shrink();
  }

  // static InputBorder verificationBorderBuilder(BuildContext context, {required ValueNotifier<VerificationStatus> stateListener}) {
  //   return ValueListenableBuilder<InputBorder>(
  //      valueListenable: stateListener,
  //      builder: (context, state, _) {
  //
  //      }
  //   );
  // }
}
