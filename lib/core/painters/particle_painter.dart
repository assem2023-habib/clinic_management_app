import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/utils/seeded_random.dart';

class ParticlePainter extends CustomPainter {
  final Color color;
  final int particleCount;
  final double minRadius;
  final double maxRadius;
  final double minAlpha;
  final double maxAlpha;
  final bool useBlur;
  final int seed;

  const ParticlePainter({
    required this.color,
    this.particleCount = 30,
    this.minRadius = 0.5,
    this.maxRadius = 1.5,
    this.minAlpha = 0.1,
    this.maxAlpha = 0.25,
    this.useBlur = false,
    this.seed = 42,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = SeededRandom(seed);
    for (var i = 0; i < particleCount; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * (maxRadius - minRadius) + minRadius;
      final alpha = rng.next() * (maxAlpha - minAlpha) + minAlpha;

      final paint = Paint()..color = color.withValues(alpha: alpha);
      if (useBlur) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      }
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => false;
}
