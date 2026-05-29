import 'package:flutter/material.dart';

class PwParticleData {
  double x, y, speedX, speedY, size, opacity;
  PwParticleData({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.size,
    required this.opacity,
  });
}

class PwParticlePainter extends CustomPainter {
  final List<PwParticleData> particles;
  PwParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.drawCircle(
        Offset(p.x, p.y),
        p.size,
        Paint()..color = const Color(0xFF4EDEA3).withValues(alpha: p.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant PwParticlePainter oldDelegate) => true;
}

class PwSeededRandom {
  int _seed;
  PwSeededRandom(this._seed);

  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
