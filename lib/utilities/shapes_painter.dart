import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

enum ShapeType { Circle, Star, Square }

class Shape {
  final ShapeType type;
  final Offset center;
  final Color color;

  Shape(this.type, this.center, this.color);
}

class ShapesPainter extends CustomPainter {
  final List<Shape> shapes;
  Color borderColor = Colors.black;

  ShapesPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      if (shape.color.computeLuminance() < 0.07) borderColor = Colors.white;
      switch (shape.type) {
        case ShapeType.Circle:
          _drawCircle(canvas, shape.center, shape.color, borderColor);
          break;
        case ShapeType.Star:
          _drawStar(canvas, shape.center, shape.color, borderColor);
          break;
        case ShapeType.Square:
          _drawSquare(canvas, shape.center, shape.color, borderColor);
          break;
      }
    }
  }

  void _drawCircle(
      Canvas canvas, Offset center, Color color, Color borderColor) {
    final paintFill = Paint()..color = color;

    final paintStroke = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0.w;

    final radius = 25.0.w;
    canvas.drawCircle(center, radius, paintFill);
    canvas.drawCircle(center, radius, paintStroke);
  }

  void _drawStar(Canvas canvas, Offset center, Color color, Color borderColor) {
    final paintFill = Paint()..color = color;

    final paintStroke = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0.w;

    final radius = 25.0.w;
    final innerRadius =
        radius * math.sin(math.pi / 10) / math.sin(7 * math.pi / 10);

    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = 2 * math.pi / 5 * i - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final point = Offset(x, y);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      final innerAngle = 2 * math.pi / 5 * i - math.pi / 2 + math.pi / 5;
      final innerX = center.dx + innerRadius * math.cos(innerAngle);
      final innerY = center.dy + innerRadius * math.sin(innerAngle);
      final innerPoint = Offset(innerX, innerY);
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }

    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  void _drawSquare(
      Canvas canvas, Offset center, Color color, Color borderColor) {
    final paintFill = Paint()..color = color;

    final paintStroke = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0.w;

    final size = 40.0.w;

    final rect = Rect.fromCenter(
      center: center,
      width: size,
      height: size,
    );

    canvas.drawRect(rect, paintFill);
    canvas.drawRect(rect, paintStroke);
  }

  @override
  bool shouldRepaint(ShapesPainter oldDelegate) => true;
}
