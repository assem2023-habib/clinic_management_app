import 'dart:math';
import 'package:flutter/material.dart';

class DpParticleData {
  double x, y, vx, vy, size, opacity;
  double life, maxLife;
  DpParticleData({
    required this.x, required this.y, required this.vx, required this.vy,
    required this.size, required this.opacity, required this.life, required this.maxLife,
  });
}

class DpPulseCirclesPainter extends CustomPainter {
  final double progress;
  final Size viewSize;
  DpPulseCirclesPainter(this.progress, this.viewSize);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(viewSize.width / 2, viewSize.height / 2);
    final maxRadius = sqrt(viewSize.width * viewSize.width + viewSize.height * viewSize.height) * 0.75;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF10B981).withValues(alpha: 0.1);
    for (int i = 0; i < 4; i++) {
      final fraction = (progress + i * 0.25) % 1.0;
      final radius = fraction * maxRadius;
      final alpha = 0.5 * (1.0 - fraction);
      paint.color = const Color(0xFF10B981).withValues(alpha: alpha * 0.1);
      canvas.drawCircle(center, radius, paint..strokeWidth = 1);
    }
  }
  @override
  bool shouldRepaint(covariant DpPulseCirclesPainter old) => old.progress != progress;
}

class DpParticlesPainter extends CustomPainter {
  final List<DpParticleData> particles;
  DpParticlesPainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.drawCircle(Offset(p.x, p.y), p.size, Paint()
        ..color = const Color(0xFF4EDEA3).withValues(alpha: p.opacity * 0.4));
    }
  }
  @override
  bool shouldRepaint(covariant DpParticlesPainter old) => true;
}

class DpProgressRingPainter extends CustomPainter {
  final double percent;
  DpProgressRingPainter(this.percent);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = Colors.white.withValues(alpha: 0.05);
    canvas.drawCircle(center, radius, trackPaint);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF10B981);
    final sweepAngle = 2 * pi * percent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweepAngle, false, progressPaint);
  }
  @override
  bool shouldRepaint(covariant DpProgressRingPainter old) => old.percent != percent;
}

class DpSeededRandom {
  int _seed;
  DpSeededRandom(this._seed);
  double next() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
