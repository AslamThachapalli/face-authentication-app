import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedCircle extends CustomPainter {
  final double value;
  final double opacity;
  final int sAngle;
  final int mAngle;
  final int lAngle;
  final bool showOnxSmallCircle;
  final bool showOnMediumCircle;
  final bool showOnLargeCircle;

  AnimatedCircle(
      {required this.mAngle,
      required this.lAngle,
      required this.value,
      required this.opacity,
      required this.sAngle,
      required this.showOnxSmallCircle,
      required this.showOnMediumCircle,
      required this.showOnLargeCircle});
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint();
    fillBrush.color = const Color(0xff55bd94).withOpacity(opacity);

    var largeCircle = Paint();
    largeCircle.style = PaintingStyle.stroke;
    largeCircle.strokeWidth = 1.0;
    largeCircle.color =
        (value <= 140 && value > 125) ? Colors.white : Colors.grey;

    var mediumCircle = Paint();
    mediumCircle.style = PaintingStyle.stroke;
    mediumCircle.strokeWidth = 1.0;
    mediumCircle.color =
        (value > 90 && value < 110) ? Colors.white : Colors.grey;

    var xsmallCircle = Paint();
    xsmallCircle.style = PaintingStyle.stroke;
    xsmallCircle.strokeWidth = 1.0;
    xsmallCircle.color =
        (value > 40 && value < 60) ? Colors.white : Colors.grey;

    var childDot = Paint();
    childDot.color = Colors.white;

    var centerdot = Paint();
    centerdot.color = Colors.deepPurple;

    canvas.drawCircle(center, value, fillBrush);
    canvas.drawCircle(center, radius, largeCircle);
    canvas.drawCircle(center, radius - 40, mediumCircle);
    canvas.drawCircle(center, radius - 80, xsmallCircle);
    if (showOnxSmallCircle) {
      double valX = x(70, sAngle, centerX);
      double valY = y(70, sAngle, centerY);
      Offset offset = Offset(valX, valY);
      canvas.drawCircle(
          offset, (value * .13).clamp(1, 10).toDouble(), childDot);
    }
    if (showOnMediumCircle) {
      double valX = x(110, mAngle, centerX);
      double valY = y(110, mAngle, centerY);
      Offset offset = Offset(valX, valY);
      canvas.drawCircle(
          offset, (value * .13).clamp(1, 15).toDouble(), childDot);
    }
    if (showOnLargeCircle) {
      double valX = x(min(centerX, centerY), lAngle, centerX);
      double valY = y(min(centerX, centerY), lAngle, centerY);
      Offset offset = Offset(valX, valY);
      canvas.drawCircle(
          offset, (value * .15).clamp(1, 20).toDouble(), childDot);
    }
    canvas.drawCircle(center, 5.0, centerdot);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

double x(r, angle, centerX) => r * cos((angle - pi / 2)) + centerX;
double y(r, angle, centerY) => r * sin((angle - pi / 2)) + centerY;
