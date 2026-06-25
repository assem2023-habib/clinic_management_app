import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/utils/seeded_random.dart';
import 'package:flutter/material.dart';

class UaParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = SeededRandom(42);
    final paint = Paint()
      ..color = AppColors.dark.emerald.withValues(alpha: 0.25);
    for (var i = 0; i < 25; i++) {
      final x = rng.next() * size.width;
      final y = rng.next() * size.height;
      final radius = rng.next() * 4 + 2;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
