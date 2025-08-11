import 'package:flutter/material.dart';

// class RatingCollector extends StatefulWidget {
//   final Function(int rate, String name) onChange;
//   final double? iconSize;
//   final bool showDescription;
//
//   const RatingCollector(
//       {super.key, required this.onChange, this.iconSize, this.showDescription = false});
//
//   @override
//   State<RatingCollector> createState() => _RatingCollectorState();
// }
//
// class _RatingCollectorState extends State<RatingCollector> {
//   int rating = 0;
//   String name = '';
//   final List<String> names = [
//     'Disappointing',
//     'Not Satisfactory',
//     'Average',
//     'Very Good',
//     'Outstanding'
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: List.generate(5, (index) {
//             return IconButton(
//               onPressed: () {
//                 rating = index + 1;
//                 name = names[rating - 1];
//                 widget.onChange.call(rating, name);
//                 setState(() {});
//               },
//               isSelected: (rating > index),
//               iconSize: widget.iconSize,
//               icon: Icon(Icons.star, color: Colors.grey[300]!),
//               selectedIcon: const Icon(Icons.star, color: Colors.orangeAccent),
//               style: IconButton.styleFrom(
//                 overlayColor: WidgetStateColor.transparent
//               ),
//             );
//           }),
//         ),
//         if(widget.showDescription && name.isNotEmpty)
//           Text(name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
//       ],
//     );
//   }
//
// }



class RatingCollector extends StatefulWidget {
  final Function(int rate, String name) onChange;
  final double? iconSize;
  final bool showDescription;

  const RatingCollector({
    super.key,
    required this.onChange,
    this.iconSize,
    this.showDescription = false,
  });

  @override
  State<RatingCollector> createState() => _RatingCollectorState();
}

class _RatingCollectorState extends State<RatingCollector>
    with TickerProviderStateMixin {
  int maxRating = 5;
  int currentRating = 0;
  String name = '';
  final List<String> names = [
    'Disappointing',
    'Not Satisfactory',
    'Average',
    'Very Good',
    'Outstanding'
  ];

  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      maxRating,
          (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(maxRating, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentRating = index + 1;
                  name = names[currentRating - 1];
                  widget.onChange.call(currentRating, name);
                  _controllers[index].forward(from: 0);
                });
              },
              child: AnimatedBuilder(
                animation: _controllers[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + _controllers[index].value * 0.2,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.star_rounded,
                    size: widget.iconSize,
                    color: (currentRating > index) ? Colors.orangeAccent : Colors.grey[300],
                  ),
                ),
              ),
            );
          }),
        ),
        // if (widget.showDescription && name.isNotEmpty)
        //   Text(
        //     name,
        //     style: Theme.of(context)
        //         .textTheme
        //         .bodyLarge
        //         ?.copyWith(color: Colors.grey),
        //   ),
      ],
    );
  }
}

