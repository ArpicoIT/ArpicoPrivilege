import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final Color? fillColor;
  final double? topMargin;
  PolygonPainter({this.fillColor, this.topMargin}){
    _topPoint = 120.0;
    _topMargin = topMargin ?? 60.0;
    _bottomPoint = 120.0;
    _bottomMargin = 36.0;
  }

  late double _topPoint;
  late double _topMargin;

  late double _bottomPoint;
  late double _bottomMargin;

  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint for the polygon fill

    final width = size.width;
    final height = size.height;

    var fillPaint = Paint()
      ..color = fillColor ?? Colors.white
      ..style = PaintingStyle.fill;

    // Define the paint for the polygon outline
    // var outlinePaint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2.0;

    // Define the polygon path
    var path = Path();

    path.moveTo(0.0, _topPoint + _topMargin); // Start point
    path.quadraticBezierTo(width * 0.8, -(_topPoint/2) + _topMargin, width, (_topPoint * 3) + _topMargin); // Top curve
    path.lineTo(width, height-(_bottomPoint*0.25)-_bottomMargin); // Right verticalDown line
    path.quadraticBezierTo(width * 0.75, height-_bottomPoint-_bottomMargin, width * 0.5, height-(_bottomPoint*0.5)-_bottomMargin); // BottomRight curve
    path.quadraticBezierTo(width * 0.25, height-_bottomMargin, 0.0, height-_bottomPoint-_bottomMargin); // BottomLeft curve
    path.lineTo(0.0, _topPoint+_topMargin); // Right verticalUp line

    // Fill the polygon with blue
    canvas.drawPath(path, fillPaint);

    // Draw the outline of the polygon
    // canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    const double height = 120;

    path.lineTo(0.0, size.height - height);

    // Curve for the wave-like effect
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - (height/2));
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - height);
    var secondEndPoint = Offset(size.width, size.height - (height/2));
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start from top-left corner
    path.lineTo(0.0, size.height * 0.2); // Left side height (20% of total height)

    // Control and end points for the curve
    var controlPoint = Offset(size.width * 0.8, size.height * -0.1); // Middle point at the top
    var endPoint = Offset(size.width, size.height * 0.5); // Right side height (50% of total height)

    // Draw the curve using quadraticBezierTo
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    // Complete the path
    path.lineTo(size.width, 0.0); // Top-right corner
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 240.0);

    const double end = 80.0;

    var firstControlPoint = Offset(size.width * 0.15, size.height);
    var firstEndPoint = Offset(size.width * 0.6, size.height - 80);

    var secondControlPoint = Offset(size.width * 0.8, size.height - 120);
    var secondEndPoint = Offset(size.width, size.height - 80);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
