import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ParticleData {
  double x, y, speedX, speedY, size, opacity;

  ParticleData({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.size,
    required this.opacity,
  });
}

class MovingParticlePainter extends CustomPainter {
  final List<ParticleData> particles;

  MovingParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = AppColors.dark.mint.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MovingParticlePainter oldDelegate) => true;
}

class SeededRandom {
  int _seed;
  SeededRandom(this._seed);

  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
