import 'package:flutter/material.dart';

class ButtonController {


}

class _Button {
  Widget content(
    context, {
    bool switchContent = false,
    IconData? icon,
    required String text,
  }) {
    final Widget childText = Text(text);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!switchContent) ...[
          (icon != null)
              ? Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(icon),
          )
              : const SizedBox.shrink(),
          childText
        ] else ...[
          childText,
          (icon != null)
              ? Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Icon(icon),
          )
              : const SizedBox.shrink(),
        ],
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Function()? onPressed;
  final Color? color;
  final Size? size;
  final double? width;
  final FocusNode? focusNode;
  final bool switchContent;
  final bool enable;

  final bool isOutline; // To differentiate filled and outlined buttons
  final bool isFilled; // To differentiate filled and transparent

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.size,
    this.width,
    this.focusNode,
    this.switchContent = false,
    this.enable = true,
    this.isOutline = false,
    this.isFilled = false,
  });

  // Named constructor for filled button
  const PrimaryButton.filled({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.size,
    this.width,
    this.focusNode,
    this.switchContent = false,
    this.enable = true,
    this.isOutline = false,
    this.isFilled = true,
  });

  // Named constructor for outline button
  const PrimaryButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.size,
    this.width,
    this.focusNode,
    this.switchContent = false,
    this.enable = true,
    this.isOutline = true,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.copyWith(primary: color);

    final bool kEnable = (onPressed != null) && enable;
    final Function()? kOnPressed = kEnable ? onPressed : null;
    final Size kSize = size ?? Size(width ?? 96, 48);

    // const EdgeInsetsGeometry padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
    const EdgeInsetsGeometry padding = EdgeInsets.all(16); // 18, 12

    final Widget content = _Button().content(
      context,
      text: text,
      icon: icon,
      switchContent: switchContent,
    );

    if (isOutline) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          disabledForegroundColor: Colors.grey[300],
          iconColor: colorScheme.primary,
          disabledIconColor: Colors.grey[300],

          side: BorderSide(color: kEnable ? colorScheme.primary : Colors.grey[300]!, width: 1.5),
          padding: padding,
          minimumSize: kSize,
        ),
        focusNode: focusNode,
        onPressed: kOnPressed,
        child: content,
      );
    } else if (isFilled) {
      return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: colorScheme.primary,
          disabledBackgroundColor: colorScheme.surfaceContainer,
          foregroundColor: Colors.white,
          disabledForegroundColor: colorScheme.surfaceContainerHighest,
          iconColor: Colors.white,
          disabledIconColor: colorScheme.surfaceContainerHighest,

          // backgroundColor: colorScheme.primary,
          // disabledBackgroundColor: colorScheme.surfaceContainerLow,
          // foregroundColor: Colors.white,
          // disabledForegroundColor: colorScheme.onInverseSurface,
          // iconColor: Colors.white,
          // disabledIconColor: colorScheme.primary.withAlpha(100),

          padding: padding,
          minimumSize: kSize,
        ),
        focusNode: focusNode,
        onPressed: kOnPressed,
        child: content,
      );

    } else {
      return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: colorScheme.primary.withAlpha(20),
          foregroundColor: colorScheme.primary,
          padding: padding,
          minimumSize: kSize,
          iconColor: colorScheme.primary
        ),
        focusNode: focusNode,
        onPressed: kOnPressed,
        child: content,
      );
    }

  }
}


