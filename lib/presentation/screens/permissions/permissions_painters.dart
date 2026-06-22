import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PsParticleData {
  double x, y, speedX, speedY, size, opacity;
  PsParticleData({required this.x, required this.y, required this.speedX, required this.speedY, required this.size, required this.opacity});
}

class PsParticlePainter extends CustomPainter {
  final List<PsParticleData> particles;
  PsParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.drawCircle(
        Offset(p.x, p.y),
        p.size,
        Paint()..shader = RadialGradient(
          colors: [AppColors.dark.emerald.withValues(alpha: p.opacity), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(p.x, p.y), radius: p.size * 3)),
      );
    }
  }
  @override
  bool shouldRepaint(covariant PsParticlePainter oldDelegate) => true;
}

class PsSeededRandom {
  int _seed;
  PsSeededRandom(this._seed);
  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}

class PsPulseRingPainter extends CustomPainter {
  final AnimationController controller;
  PsPulseRingPainter(this.controller);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final t = controller.value;
    for (int i = 0; i < 3; i++) {
      final phase = (t + i * 0.33) % 1.0;
      final radius = 50 + phase * 250;
      final alpha = ((1.0 - phase) * 0.3).clamp(0.0, 1.0);
      canvas.drawCircle(center, radius, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.dark.emerald.withValues(alpha: alpha));
    }
  }
  @override
  bool shouldRepaint(covariant PsPulseRingPainter oldDelegate) => true;
}
