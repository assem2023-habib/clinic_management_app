import 'package:flutter/material.dart';

class OrbitPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const OrbitPainter({required this.color, this.strokeWidth = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: size.width - 8, height: size.height - 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) => false;
}
