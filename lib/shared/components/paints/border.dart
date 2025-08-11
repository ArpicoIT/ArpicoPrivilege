import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBorderContainer extends StatelessWidget {
  // final double width;
  // final double height;
  final Color borderColor;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final bool isDotted; // Determines if the border is dotted or solid
  final Widget child;

  const CustomBorderContainer({
    Key? key,
    // required this.width,
    // required this.height,
    this.borderColor = Colors.black,
    this.borderRadius = 8.0,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    required this.isDotted, // Pass true for dotted border, false for solid border
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: isDotted
          ? DottedBorderPainter(
        color: borderColor,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      )
          : SolidBorderPainter(
        color: borderColor,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
      ),
      // child: Container(
      //   width: width,
      //   height: height,
      //   padding: const EdgeInsets.all(10),
      //   alignment: Alignment.center,
      //   child: child,
      // ),
      child: child,
    );
  }
}

// Dotted Border Painter
class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius)));

    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final Path extractPath =
        pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Solid Border Painter
class SolidBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  SolidBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
