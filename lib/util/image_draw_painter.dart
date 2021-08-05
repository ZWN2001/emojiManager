import 'dart:ui';

import 'package:flutter/material.dart';

class Point {
  Color color;
  List<Offset> points;
  double strokeWidth = 5.0;

  Point(this.color, this.strokeWidth, this.points);
}

class ScrawlPainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  late Paint _linePaint;
  final bool isClear;
  final List<Point> points;

  ScrawlPainter({
    required this.points,
    required this.strokeColor,
    required this.strokeWidth,
    this.isClear = true,
  }) {
     _linePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    canvas.clipRect(rect);
    if (isClear || points.length == 0) {
      return;
    }
    for (int i = 0; i < points.length; i++) {
      _linePaint..color = points[i].color;
      _linePaint..strokeWidth = points[i].strokeWidth;
      List<Offset> curPoints = points[i].points;
      if (curPoints.length == 0) {
        break;
      }
      for (int i = 0; i < curPoints.length - 1; i++) {
        canvas.drawLine(curPoints[i], curPoints[i + 1], _linePaint);
      }
    }
  }

  bool shouldRepaint(ScrawlPainter other) => true;
}

class BorderPainter extends CustomPainter {
  Paint _paint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    canvas.clipRect(rect);
    Rect rectFromCenter =
    Rect.fromCenter(center: Offset(0, 0), width: 160, height: 160);
    canvas.drawRRect(RRect.fromRectXY(rectFromCenter, 10, 10), _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
