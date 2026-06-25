import 'dart:math' show pi;
import 'package:flutter/material.dart';

class RotatingGlowPainter extends CustomPainter {
  final double rotationAngle;
  final Color color;

  RotatingGlowPainter(this.rotationAngle, {required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        startAngle: rotationAngle,
        endAngle: rotationAngle + 2 * pi,
        colors: [
          Colors.transparent,
          color,
          Colors.transparent,
          color,
          Colors.transparent,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(rect);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant RotatingGlowPainter oldDelegate) =>
      oldDelegate.rotationAngle != rotationAngle;
}
