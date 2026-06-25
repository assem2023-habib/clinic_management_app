import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/utils/seeded_random.dart';

class StarfieldPainter extends CustomPainter {
  final Color color;
  final int starCount;
  final double minRadius;
  final double maxRadius;
  final int seed;

  const StarfieldPainter({
    required this.color,
    this.starCount = 50,
    this.minRadius = 0.5,
    this.maxRadius = 1.7,
    this.seed = 42,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = SeededRandom(seed);
    final paint = Paint()..color = color;
    for (var i = 0; i < starCount; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * (maxRadius - minRadius) + minRadius;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) => false;
}
