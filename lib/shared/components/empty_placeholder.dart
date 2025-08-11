
import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;


  EmptyPlaceholder({
    super.key,
    this.height,
    this.width,
    this.child
  }) : _borderRadius = BorderRadius.circular(6.0), _lines = null;

  EmptyPlaceholder.round({
    super.key,
    double radius = 36.0,
    this.child
  }) : width = radius,
        height = radius,
        _borderRadius = BorderRadius.circular(radius/2), _lines = null;

  EmptyPlaceholder.box({
    super.key,
    double dimension = 48.0,
    this.child
  }) : width = dimension,
        height = dimension,
        _borderRadius = BorderRadius.circular(6.0), _lines = null;

  EmptyPlaceholder.paragraph({
    super.key,
    // double dimension = 48.0,
    int lines = 3,
    this.height,
    this.width,
    this.child
  }) : _borderRadius = BorderRadius.circular(6.0),
        _lines = lines;

  final BorderRadiusGeometry? _borderRadius;
  final int? _lines;

  @override
  Widget build(BuildContext context) {

    final Widget placeholder = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: _borderRadius
      ),
      child: child,
    );

    if(_lines != null){
      return Column(
        children: List.generate(_lines, (i) => Padding(
          padding: EdgeInsets.only(bottom: i==_lines-1?0.0:8.0),
          child: placeholder,
        ))
      );
    }

    return placeholder;
  }
}
