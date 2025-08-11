import 'package:flutter/material.dart';

class RatingIndicator extends StatelessWidget {
  final int maxRating;
  final double? currentRating;
  final bool showLeading;
  final bool showAction;
  final double? iconSize;

  RatingIndicator({super.key,
    this.maxRating = 5,
    double? currentRating,
    this.showLeading = false,
    this.showAction = false,
    this.iconSize

  }) : currentRating = currentRating == null ? 0.0 : (currentRating > maxRating) ? maxRating.toDouble() : currentRating;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(showLeading)
          ...[
            Text((currentRating??0).toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 2.0),
          ],
        ...List.generate(maxRating, (index) {
          if (index < currentRating!.floor()) {
            // Full star
            return Icon(Icons.star, color: Colors.orangeAccent, size: iconSize);
          } else if (index < currentRating!) {
            // Half star for fractional ratings
            return Icon(Icons.star_half, color: Colors.orangeAccent, size: iconSize);
          } else {
            // Empty star
            return Icon(Icons.star_border, color: colorScheme.outlineVariant, size: iconSize);
          }
        }),
        if(showAction)
          Icon(Icons.navigate_next, color: colorScheme.outlineVariant, size: iconSize)
      ],
    );
  }
}


