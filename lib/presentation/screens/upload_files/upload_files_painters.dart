
import 'package:flutter/material.dart';

class SeededRandom {
  int _seed;
  SeededRandom(this._seed);

  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}

class UfParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = SeededRandom(42);
    final paint = Paint()
      ..color = AppColors.dark.emerald.withValues(alpha: 0.2);
    for (var i = 0; i < 20; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * 4 + 2;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
