import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppText {
  static Text boldTitle(String title) =>
      Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0));

  static RichText promotionExpiryText(BuildContext context, DateTime endDate) {
    final baseStyle = TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface);
    final difference = endDate.difference(DateTime.now());

    if (difference.isNegative) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            WidgetSpan(child: Icon(Icons.cancel, color: Colors.red, size: 18)),
            TextSpan(text: " This promotion has ended.", style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    } else if (difference.inDays > 10) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: "This promotion expires in "),
            TextSpan(
                text: "${difference.inDays} days",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            const TextSpan(text: "."),
          ],
        ),
      );
    } else if (difference.inDays > 1) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: "🛒 Hurry! Only "),
            TextSpan(
                text: "${difference.inDays} days",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const TextSpan(text: " left!"),
          ],
        ),
      );
    } else if (difference.inDays == 1) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            WidgetSpan(child: Icon(Icons.warning, color: Colors.red, size: 18)),
            TextSpan(text: " 🚨 Last chance! Ends tomorrow! ", style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    } else if (difference.inHours >= 1) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: "⏳ Act fast! Only "),
            TextSpan(
                text: "${difference.inHours} hours",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            const TextSpan(text: " left!"),
          ],
        ),
      );
    } else if (difference.inMinutes >= 1) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: "⚡ Hurry! Just "),
            TextSpan(
                text: "${difference.inMinutes} minutes",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            const TextSpan(text: " remaining!"),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: "🔥 Final call! Only "),
            TextSpan(
                text: "${difference.inSeconds} seconds",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            const TextSpan(text: " left!"),
          ],
        ),
      );
    }
  }

  static RichText termsAndPrivacy(BuildContext context){
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium, // Default text style
        children: [
          const TextSpan(text: "By continuing, you confirm that you accept our "),
          TextSpan(
            text: "Terms of Service",
            style: const TextStyle(
              // color: Colors.blue, // Highlight color
              fontWeight: FontWeight.bold,
              // decoration: TextDecoration.underline, // Underline for emphasis
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle Terms of Service tap
                print("Terms of Service Clicked");
              },
          ),
          const TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: const TextStyle(
              // color: Colors.blue, // Highlight color
              fontWeight: FontWeight.bold,
              // decoration: TextDecoration.underline, // Underline for emphasis
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle Privacy Policy tap
                print("Privacy Policy Clicked");
              },
          ),
          const TextSpan(text: "."),
        ],
      ),
    );
  }


// static Widget appName(BuildContext context, String name, {double fontSize = 45.0}){
  //   // DefaultTextStyle(
  //   //   style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: fontSize) ?? TextStyle(fontSize: fontSize),
  //   //   child: [Widget],
  //   // );
  //
  //   return RichText(
  //     textAlign: TextAlign.center,
  //     text: TextSpan(
  //       text: name.split(' ')[0],
  //       style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: fontSize),
  //       children: [
  //         TextSpan(
  //           text: " ${name.split(' ')[1]}",
  //           style: const TextStyle(color: Colors.orangeAccent),
  //         )
  //       ]
  //     )
  //   );
  // }

  // static Widget appName(BuildContext context, String appName, {String? slogan, double appNameSize = 45.0, double sloganSize = 22.0}){
  //   // DefaultTextStyle(
  //   //   style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: fontSize) ?? TextStyle(fontSize: fontSize),
  //   //   child: [Widget],
  //   // );
  //
  //   return RichText(
  //     textAlign: TextAlign.center,
  //     text: TextSpan(
  //       text: appName.split(' ')[0],
  //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: appNameSize),
  //       children: [
  //         TextSpan(
  //           text: appName.split(' ')[1],
  //           style: TextStyle(color: Theme.of(context).colorScheme.secondary),
  //         ),
  //         if(slogan != null)
  //           TextSpan(
  //             text: "\n$slogan",
  //             style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: sloganSize, /*fontWeight: FontWeight.bold*/),
  //           ),
  //       ]
  //     )
  //   );
  // }
}