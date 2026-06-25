import 'package:flutter/material.dart';

class ScanlinePainter extends CustomPainter {
  final double lineSpacing;
  final double lineAlpha;

  const ScanlinePainter({this.lineSpacing = 4, this.lineAlpha = 0.04});

  @override
  void paint(Canvas canvas, Size size) {
    for (double y = 0; y < size.height; y += lineSpacing) {
      canvas.drawLine(
        Offset(0, y + 2),
        Offset(size.width, y + 2),
        Paint()..color = Colors.black.withValues(alpha: lineAlpha),
      );
    }

    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.red.withValues(alpha: 0.005),
        Colors.green.withValues(alpha: 0.003),
        Colors.blue.withValues(alpha: 0.005),
      ],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant ScanlinePainter oldDelegate) => false;
}
