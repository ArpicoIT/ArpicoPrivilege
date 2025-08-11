
import 'package:flutter/material.dart';

class LinkedTextButton extends StatelessWidget {
  final String text;
  final String link;
  final Function() onTap;
  const LinkedTextButton({super.key,
    required this.text,
    required this.link,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;



    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.all(8.0),
        // color: Colors.red,
        child: RichText(
          text: TextSpan(
              text: text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              children: [
                TextSpan(
                    text: link,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary
                    ))
              ]),
        ),
      ),
    );
  }
}
