import 'package:flutter/material.dart';

class SfParticleData {
  double x, y, speedX, speedY, size, opacity;
  SfParticleData({required this.x, required this.y, required this.speedX, required this.speedY, required this.size, required this.opacity});
}

class SfParticlePainter extends CustomPainter {
  final List<SfParticleData> particles;
  SfParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.drawCircle(Offset(p.x, p.y), p.size, Paint()
        ..color = const Color(0xFF4EDEA3).withValues(alpha: p.opacity));
    }
  }
  @override
  bool shouldRepaint(covariant SfParticlePainter oldDelegate) => true;
}

class SfSeededRandom {
  int _seed;
  SfSeededRandom(this._seed);
  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
