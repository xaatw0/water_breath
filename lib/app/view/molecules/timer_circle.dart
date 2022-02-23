import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimerCircle extends CustomPainter {
  final double radius;
  final double storokeWidth;
  double _rate = 1.0;

  TimerCircle(this.radius, this.storokeWidth);

  void setRate(double rate) {
    this._rate = rate;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, 2 * radius, 2 * radius);
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * _rate;
    final useCenter = false;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = storokeWidth;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
