import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndPrivacyCheckbox extends StatelessWidget {
  final Function(bool? value) onChanged;
  final bool agreeToTerms;
  const TermsAndPrivacyCheckbox({super.key, required this.onChanged, required this.agreeToTerms});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged.call(!agreeToTerms);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: Checkbox(
              onChanged: (bool? value) {
                if(value == null) {
                  return;
                }
                onChanged.call(value);
              },
              value: agreeToTerms,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashRadius: 0,
              visualDensity: VisualDensity.compact,
            ),
          ),
          Flexible(child: _termsAndPrivacy(context))
        ],
      ),
    );
  }

  RichText _termsAndPrivacy(BuildContext context){
    // By continuing, you confirm that you accept our Terms of Service  and Privacy Policy
    // By continuing, I confirm that I accept the Terms of Service and Privacy Policy.

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium, // Default text style
        children: [
          const TextSpan(text: "By continuing, I confirm that I accept the "),
          TextSpan(
            text: "Terms of Service",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              // color: Colors.blue,
              // fontWeight: FontWeight.bold,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              // color: Colors.blue,
              // fontWeight: FontWeight.bold,
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

}
