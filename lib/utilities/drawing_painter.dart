import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter({@required this.points, @required this.color});

  final List<Offset> points;
  final Color color;
  Color borderColor = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    if (color.computeLuminance() < 0.07) borderColor = Colors.white;
    Paint paintFill = Paint()
      ..color = borderColor
      ..strokeWidth = 5.0.w
      ..strokeCap = StrokeCap.round;

    Paint paintStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0.w;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paintFill);
      }
    }

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paintStroke);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
