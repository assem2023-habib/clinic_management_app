import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/painters/particle_painter.dart';

class ParticleLayer extends StatelessWidget {
  final Color color;
  final int particleCount;
  final double minRadius;
  final double maxRadius;
  final double minAlpha;
  final double maxAlpha;
  final bool useBlur;
  final int seed;

  const ParticleLayer({
    super.key,
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
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: ParticlePainter(
            color: color,
            particleCount: particleCount,
            minRadius: minRadius,
            maxRadius: maxRadius,
            minAlpha: minAlpha,
            maxAlpha: maxAlpha,
            useBlur: useBlur,
            seed: seed,
          ),
        ),
      ),
    );
  }
}
