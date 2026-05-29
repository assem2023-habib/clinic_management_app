import 'package:flutter/material.dart';

class NfParticleData {
  double x, y, speedX, speedY, size, opacity;
  NfParticleData({required this.x, required this.y, required this.speedX, required this.speedY, required this.size, required this.opacity});
}

class NfParticlePainter extends CustomPainter {
  final List<NfParticleData> particles;
  NfParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.drawCircle(Offset(p.x, p.y), p.size, Paint()
        ..color = const Color(0xFF4EDEA3).withValues(alpha: p.opacity));
    }
  }
  @override
  bool shouldRepaint(covariant NfParticlePainter oldDelegate) => true;
}

class NfSeededRandom {
  int _seed;
  NfSeededRandom(this._seed);
  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
